#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( dirname "${BASEDIR}" )"

CMD="${1:-test}"
if ! which docker ; then
    echo 'Docker is missing!' >&2
    exit 1
fi

docker run \
    --rm \
    --mount "type=bind,src=${TOP},dst=/workspace" \
    ubuntu:18.04 \
    /workspace/ci/in_docker.sh | tee "${TMPFILE}"

# Validate the path mapping has occurred.
grep "^[#][#]vso[[].*${BASEDIR}" "${TMPFILE}"
