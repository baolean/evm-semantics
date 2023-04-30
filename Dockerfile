FROM ubuntu:latest
RUN apt update -y
RUN apt install curl -y

# Install nix
RUN curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install linux --init none --n>
ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

# Install kup, kevm, 
RUN nix profile install github:runtimeverification/kup#kup \
  --option extra-substituters 'https://k-framework.cachix.org' \
  --option extra-trusted-public-keys 'k-framework.cachix.org-1:jeyMXB2h28gpNRjuVkehg+zLj62ma1RnyyopA/20yFE=' \
  --experimental-features 'nix-command flakes'
RUN kup install kevm

# Install Foundry
RUN curl -L https://foundry.paradigm.xyz | bash
ENV PATH=/.root/.foundry/bin:$PATH

RUN apt-get update \
  && apt-get install -y \
    curl wget vim git

RUN /root/.foundry/bin/foundryup
