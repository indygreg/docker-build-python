#!/bin/bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

set -e

mkdir -p /python-build

cd python-build

if [ ! -f python.tar.gz ]; then
  python_url="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz"
  echo "downloading Python from ${python_url}"
  wget -O python.tar.gz ${python_url}
fi

if [ ! -d setuptools ]; then
  echo "obtaining setuptools source code"
  hg clone https://bitbucket.org/pypa/setuptools setuptools
else
  hg -R setuptools pull
fi

if [ ! -d pip ]; then
  echo "obtaining pip source code"
  git clone https://github.com/pypa/pip.git pip
else
  git -C pip fetch
fi

if [ ! -d virtualenv ]; then
  echo "obtaining virtualenv source code"
  git clone https://github.com/pypa/virtualenv.git virtualenv
else
  git -C virtualenv fetch
fi

if [ ! -d source ]; then
  echo "uncompressing Python source"
  mkdir source
  tar -C source --strip-components 1 -xzf python.tar.gz
fi

cd source

./configure --prefix=${PYTHON_INSTALL_DIR}

numcores="$(grep ^processor /proc/cpuinfo 2>/dev/null | wc -l | xargs)"
numcores="${numcores#0}"

make -j${numcores}
make install

PYTHON=${PYTHON_INSTALL_DIR}/bin/python

cd ..

echo "installing setuptools"
cd setuptools
hg up ${SETUPTOOLS_VERSION}
${PYTHON} setup.py install
cd ..

echo "installing pip"
cd pip
git checkout ${PIP_VERSION}
${PYTHON} setup.py install
cd ..

echo "installing virtualenv"
cd virtualenv
git checkout ${VIRTUALENV_VERSION}
${PYTHON} setup.py install
cd ..

echo "packaging python"
tar -czf python.tar.gz -C ${PYTHON_INSTALL_DIR} .

echo "python packages built successfully!"
echo ""
echo "To obtain the archives, use 'docker cp' to copy the archives:"
echo ""
echo "  $ docker cp <container> /python-build/python.tar.gz python.tar.gz"
echo ""
echo "To find the ID of this container, run 'docker ps'. e.g. "
echo ""
echo "  $ container=\$(docker ps | grep pybuild | awk '{print \$1}')"
echo "  $ docker cp ${container} /python-build/python.tar.gz python.tar.gz"
echo ""
echo "(We have started a shell inside the container for your convenience.)"

cd /

exec "$@"
