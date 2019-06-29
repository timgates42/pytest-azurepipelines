#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( dirname "${BASEDIR}" )"

CMD="${1:-test}"
if ! which docker ; then
    echo 'Docker is missing!' >&2
    exit 1
fi

TMPFILE=$(mktemp /tmp/vso_check.XXXXXX)
function finish {
  rm -f "${TMPFILE}"
}
trap finish EXIT

docker run \
    --rm \
    --mount "type=bind,src=${TOP},dst=/workspace" \
    ubuntu:18.04 \
    /workspace/ci/in_docker.sh $(id -u) $(id -g) | tee "${TMPFILE}"

# Validate the path mapping has occurred.
if ! grep "^[#][#]*vso[[].*${BASEDIR}" "${TMPFILE}" ; then
    echo "Implicit Docker Path Mapping is missing! check availability of /proc/1/mountinfo" >&2
    echo "see https://github.com/tonybaloney/pytest-azurepipelines/pull/25" >&2
    exit 1
fi
