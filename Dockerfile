FROM fedora:37 AS base

RUN dnf install -y --setopt=install_weak_deps=0 \
    python3-pip git && \
    useradd -m builder

USER builder
ENV PATH=/home/builder/.local/bin:${PATH}
WORKDIR /src

RUN python3 -m pip install ansible-lint && \
    git config --global --add safe.directory /src

# This image only has the ansible-core, without any collections installed globally
FROM base AS core-only
RUN python3 -m pip install ansible-core

# This image has ansible-core and the collections we need installed globally
FROM core-only as core-and-collections
RUN ansible-galaxy collection install kubernetes.core

# This image has all of ansible and collections installed
FROM base AS full
RUN python3 -m pip install ansible
