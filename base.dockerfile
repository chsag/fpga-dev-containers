ARG BASE_IMAGE
FROM $BASE_IMAGE

# Install dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        gnat \
        libglib2.0-0 \
        libtcmalloc-minimal4 \
        locales \
        python3 \
        python3-pip \
        python3-setuptools \
        make \
        unzip \
        zlib1g-dev \
    && update-ca-certificates \
    && apt-get autoclean \
    && apt-get clean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/*