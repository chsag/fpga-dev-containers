ARG REPOSITORY
FROM $REPOSITORY/ghdl

ARG VUNIT_VERSION

# Install vunit
RUN pip3 install \
        wheel \
    && rm -rf ~/.cache

RUN pip3 install \
        vunit_hdl==${VUNIT_VERSION} \
    && rm -rf ~/.cache