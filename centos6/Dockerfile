FROM centos:centos6

ENV PYTHON_VERSION 2.7.8
ENV SETUPTOOLS_VERSION 7.0
ENV PIP_VERSION 1.5.6
ENV VIRTUALENV_VERSION 1.11.6
ENV PYTHON_INSTALL_DIR /usr/local/python

RUN yum update -y && \
    yum install -y gcc git mercurial tar wget \
      bzip2-devel gdbm-devel openssl-devel readline-devel sqlite-devel zlib-devel

ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/bin/bash"]
