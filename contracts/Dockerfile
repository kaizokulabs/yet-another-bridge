FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends git curl ca-certificates \
    && update-ca-certificates \
    && curl -L https://foundry.paradigm.xyz | bash \
    && . /root/.bashrc \
    && foundryup \
    && which forge \
    && rm -rf /var/lib/apt/lists/*

COPY . /contracts

ENTRYPOINT ["/contracts/deploy.sh"]
