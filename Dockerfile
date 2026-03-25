FROM ghcr.io/astral-sh/uv:0.9.24-python3.9-bookworm AS astral-sh

FROM node:22

RUN set ex; \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    bash-completion=1:2.* \
    gosu=1.* \
    jq=1.* \
    python3-dev=3.* \
    sudo=1.* \
    ripgrep=13.* && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3 1 && \
    sed -i '/^node/d' /etc/passwd && \
    useradd --uid 1000 --gid 1000 --non-unique --create-home --home-dir /h/ivan --password ivan --shell /bin/bash ivan && \
    echo 'ivan ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-ivan

RUN set ex; curl -sSL -o /tmp/docker.sh https://get.docker.com/ && sh /tmp/docker.sh

RUN set ex; \
    curl -sSL -o /tmp/claude.sh https://claude.ai/install.sh &&  \
    bash /tmp/claude.sh stable && \
    cp "$(readlink -f /root/.local/bin/claude)" /usr/local/bin/claude && \
    chmod +x /usr/local/bin/claude

RUN set ex; \
    curl -sSL -o /usr/local/bin/firebase https://firebase.tools/bin/linux/latest && \
    chmod +x /usr/local/bin/firebase

RUN set -ex; \
    npm i -g pyright@1.1.408

COPY --from=astral-sh /usr/local/bin/uv* /usr/local/bin/
