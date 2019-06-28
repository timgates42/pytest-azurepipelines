#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( dirname "${BASEDIR}" )"

cd "${TOP}"
apt-get update
apt-get install -qq -y --no-install-recommends apt-utils
apt-get install -qq -y --no-install-recommends python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install -e .
pytest tests -v -m "not testfail"
