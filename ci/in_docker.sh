#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( dirname "${BASEDIR}" )"

cd "${TOP}"
DEBIAN_FRONTEND=noninteractive apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends apt-utils
DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install pytest pytest-cov
python3 setup.py install
python3 -m pytest --cov=. --cov-report=xml -v -m "not testfail" tests
