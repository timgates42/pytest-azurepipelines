#!/bin/bash

set -euxo pipefail

BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TOP="$( dirname "${BASEDIR}" )"

cd "${TOP}"
apt-get -qq update
apt-get -qq install -y python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install -e .
pytest tests -v -m "not testfail"
