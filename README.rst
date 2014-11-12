==================================
Build Python Packages Using Docker
==================================

Is your operating system still stuck on Python 2.6? Do you want to move to
Python 2.7 or newer? This project is for you.

Python is a core component of operating systems. So, operating systems
can't easily upgrade the system Python install without a) breaking
backwards compatibility b) possibly breaking parts of the operating system
that rely on the older version of Python.

Since the operating system's Python is effectively frozen, people wishing
to deploy a newer Python must create a separate Python installation separate
from the system's. This project builds standalone Python installations
(using Docker) that can be transferred to and install on multiple machines
for use side-by-side the system's Python installation.

Using Docker to Build Python
============================

This project contains Docker environments for building Python from source and
for packaging that Python installation so it can easily be installed
on multiple machines.

How It Works
------------

Go to the directory of the operating system / distro you wish to build Python
for. Then, build and launch a Docker image that will build and package Python
for you.::

  $ cd centos6
  $ docker build -t pybuild-centos6 .
  $ docker run --rm -it pybuild-centos6

Then, follow the instructions to obtain an archive of the built Python
installation, which you can distribute to all your machines.

Python embeds some self-referential links in its installation. This means that
the directory we install Python into inside Docker **must be identical** to the
directory the archive is uncompressed to. The default location is
``/usr/local/python``.

Configuration
=============

By default, modern versions of Python, setuptools, pip, and virtualenv are
installed into ``/usr/local/python``. If you would like to change the versions
or installation location, you can set some environment variables.

PYTHON_VERSION
   The version of CPython to download and install.
SETUPTOOLS_VERSION
   The version of setuptools to install. This corresponds to a tag or changeset
   from the setuptools Mercurial repository.
PIP_VERSION
   The version of pip to install. This corresponds to a tag or commit from the pip
   Git repository.
VIRTUALENV_VERSION
   The version of virtualenv to install. This corresponds to a tag or commit from
   virtualenv Git repository.
PYTHON_INSTALL_DIR
   Prefix where we should install Python.

For example, to install Python in ``/opt/python27`` instead::

  $ docker run --rm -it -e PYTHON_INSTALL_DIR=/opt/python27 pybuild-centos6

Known Issues and Limitations
============================

This project is only tested on Python 2.7 and modern version (late 2014)
versions of setuptools, pip, and virtualenv.

We should probably do GPG verification of downloaded source and/or tags.

As new operating systems are added, we'll have a lot of redundant code. We
may want to provide a script that builds a Docker image from a dynamically
created, in-memory archive. See
https://hg.mozilla.org/hgcustom/version-control-tools/file/3ba7235c8b66/testing/vcttesting/docker.py#l122
for inspiration.

We are solving *building Python*, which has been solved before.
We may want to incorporate pyenv's
`python-build <https://github.com/yyuu/pyenv/blob/master/plugins/python-build/bin/python-build>`_
script so we don't have to reinvent the wheel. That being said, python-build
assumes a variable system. Courtesy of Docker, our system state should be
better-defined, so we don't need so much complexity.

The original project author is not 100% certain that others have not solved
this exact problem before. The author is aware of projects like pyenv.
However, the main purpose this project facilitates that the author believes
to be unique is the ability to easily produce a standalone Python installation
which can easily be distributed among several machines, independent of
operating system packaging. The author would appreciate enlightenment if he
is wrong.
