ARG REPOSITORY
FROM $REPOSITORY/base

ARG GHDL_VERSION

RUN mkdir /tmp/ghdl \
    && cd /tmp/ghdl \
    && curl --location --progress-bar --remote-name \
        https://github.com/ghdl/ghdl/archive/v${GHDL_VERSION}.zip \
    && unzip v${GHDL_VERSION}.zip \
    && cd ghdl-${GHDL_VERSION} \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && rm -rf /tmp/ghdl