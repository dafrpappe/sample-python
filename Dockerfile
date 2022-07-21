FROM ubuntu:18.04

# There is no official Ubuntu-18-based image for Python in Вocker Hub.
# But using Ubuntu 18 as a base (for everything that can't run in Alpine) is a requirement from SEC team.
# So we compile Python into Ubuntu-18 image ourselves

ENV PYTHON_VERSION 3.7.7
ENV PYTHON_PIP_VERSION 20.1
ENV DEBIAN_FRONTEND=noninteractive

# Ensure that the local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

## Install Python
RUN set -ex && apt-get -qqy update \
    # The dependencies that are required for Python build and run are taken from https://github.com/docker-library/python/blob/master/3.7/buster/slim/Dockerfile
    && apt-get -qqy install --no-install-recommends autoconf automake make unzip bzip2 dpkg-dev file gcc g++ libbz2-dev libc-dev \
    libc6-dev libcurl4-openssl-dev libdb-dev libevent-dev libgdbm-dev libglib2.0-dev libgmp-dev libkrb5-dev liblzma-dev \
    libmaxminddb-dev libncurses5-dev libncursesw5-dev libffi-dev libreadline-dev libsqlite3-dev libssl-dev libtool libwebp-dev \
    libxml2-dev libxslt-dev libyaml-dev patch tk-dev uuid-dev xz-utils zlib1g-dev ca-certificates gnupg libexpat-dev curl \
    && curl -sL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz" --output python.tar.xz \
 && curl -sL "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc" --output python.tar.xz.asc \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --batch --keyserver ha.pool.sks-keyservers.net --recv-keys "0D96DF4D4110E5C43FBFB17F2D347EA6AA65421D" \
 && gpg --batch --verify python.tar.xz.asc python.tar.xz \
 && { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
 && rm -rf "$GNUPGHOME" python.tar.xz.asc \
 && mkdir -p /usr/src/python && tar -xJC /usr/src/python --strip-components=1 -f python.tar.xz && rm python.tar.xz \
 && cd /usr/src/python && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
 && ./configure --build="$gnuArch" --enable-loadable-sqlite-extensions --enable-optimizations --enable-option-checking=fatal \
             --enable-shared --with-system-expat --with-system-ffi --without-ensurepip \
 && make -j "$(nproc)" \
  PROFILE_TASK='-m test.regrtest --pgo test_array test_base64 test_binascii test_binhex test_binop test_bytes \
   test_c_locale_coercion test_class test_cmath test_codecs test_compile test_complex test_csv test_decimal \
   test_dict test_float test_fstring test_hashlib test_io test_iter test_json test_long test_math \
   test_memoryview test_pickle test_re test_set test_slice test_struct test_threading test_time \
   test_traceback test_unicode' \
 && make install && ldconfig && find /usr/local -depth \
  \( \
   \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
   -o \
   \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
  \) -exec rm -rf '{}' + \
 && cd /usr/local/bin && ln -s idle3 idle && ln -s pydoc3 pydoc && ln -s python3 python && ln -s python3-config python-config \
 && rm -rf /usr/src/python && apt --purge -qqy remove autoconf automake make unzip gnupg && apt-get -qqy autoremove
## End install Python

## Install pip
RUN set -ex; curl -sL "https://github.com/pypa/get-pip/raw/1fe530e9e3d800be94e04f6428460fc4fb94f5a9/get-pip.py" --output get-pip.py; \
 python get-pip.py --disable-pip-version-check --no-cache-dir "pip==$PYTHON_PIP_VERSION"; \
 find /usr/local -depth \
  \( \
   \( -type d -a \( -name test -o -name tests -o -name idle_test \) \) \
   -o \
   \( -type f -a \( -name '*.pyc' -o -name '*.pyo' \) \) \
  \) -exec rm -rf '{}' +; \
 rm -f get-pip.py
## End install pip

RUN python --version
RUN pip --version

CMD ["python3"]