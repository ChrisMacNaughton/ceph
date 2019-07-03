#!/usr/bin/env bash

function dump_envvars {
  echo "WITH_PYTHON3: ->$WITH_PYTHON3<-"
  echo "TOX_PATH: ->$TOX_PATH<-"
  echo "ENV_LIST: ->$ENV_LIST<-"
}

# run from ./ or from ../
: ${MGR_JUJU_VIRTUALENV:=$CEPH_BUILD_DIR/mgr-juju-virtualenv}
: ${WITH_PYTHON3:=3}
: ${CEPH_BUILD_DIR:=$PWD/.tox}
test -d juju && cd juju

if [ -e tox.ini ]; then
    TOX_PATH=$(readlink -f tox.ini)
else
    TOX_PATH=$(readlink -f $(dirname $0)/tox.ini)
fi

# tox.ini will take care of this.
unset PYTHONPATH
export CEPH_BUILD_DIR=$CEPH_BUILD_DIR

source ${MGR_JUJU_VIRTUALENV}/bin/activate

# WITH_PYTHON3 might be set to "ON" or to the python3 RPM version number
# prevailing on the system - e.g. "3", "36"
if [[ "$WITH_PYTHON3" =~ (^3|^ON) ]]; then
  ENV_LIST+="py3,"
fi
# use bash string manipulation to strip off any trailing comma
ENV_LIST=${ENV_LIST%,}

tox -c "${TOX_PATH}" -e "${ENV_LIST}" "$@"
TOX_STATUS="$?"
test "$TOX_STATUS" -ne "0" && dump_envvars
exit $TOX_STATUS
