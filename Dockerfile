FROM ghcr.io/astral-sh/uv:python3.11-trixie AS astral-sh

FROM node:lts-trixie-slim

RUN set ex; \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends \
    bash-completion=1:2.* \
    curl=8.* \
    ca-certificates=202* \
    gosu=1.* \
    jq=1.* \
    python3-dev=3.* \
    sudo=1.* \
    ripgrep=14.* && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    sed -i '/^node/d' /etc/passwd && \
    useradd --uid 1000 --gid 1000 --non-unique --create-home --home-dir /h/ivan --password ivan --shell /bin/bash ivan && \
    echo 'ivan ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-ivan

COPY .bash_aliases /h/ivan/.bash_aliases

RUN set ex; curl -sSL -o /tmp/docker.sh https://get.docker.com/ && sh /tmp/docker.sh

RUN set ex; \
    curl -sSL -o /tmp/claude.sh https://claude.ai/install.sh &&  \
    bash /tmp/claude.sh stable && \
    cp "$(readlink -f /root/.local/bin/claude)" /usr/local/bin/claude && \
    chmod +x /usr/local/bin/claude

COPY --from=astral-sh /usr/local/bin/uv* /usr/local/bin/

RUN npm install -g marked@18.0.9
