# Stage with just the uv binaries (distroless)
FROM ghcr.io/astral-sh/uv:latest AS uvbin

FROM node:22

ARG TZ
ENV TZ="$TZ"

# Install basic development tools and iptables/ipset
RUN apt update && apt install -y less \
  procps \
  sudo \
  fzf \
  zsh \
  man-db \
  unzip \
  gnupg2 \
  gh \
  iptables \
  ipset \
  iproute2 \
  dnsutils \
  aggregate \
  jq \
  ripgrep \
  socat \
  curl \
  wget \
  ca-certificates \
  lsb-release

# Build Git 2.51.0 from source for relativeWorktrees extension support
RUN apt update && apt install -y --no-install-recommends \
  build-essential \
  libssl-dev \
  libcurl4-gnutls-dev \
  libexpat1-dev \
  gettext \
  zlib1g-dev \
  && cd /tmp \
  && wget -q https://cdn.kernel.org/pub/software/scm/git/git-2.51.0.tar.xz \
  && tar -xf git-2.51.0.tar.xz \
  && cd git-2.51.0 \
  && make configure \
  && ./configure --prefix=/usr/local \
  && make -j$(nproc) all \
  && make install \
  && make -C contrib/subtree prefix=/usr/local install \
  && cd / \
  && rm -rf /tmp/git-2.51.0* \
  && apt purge -y \
  build-essential \
  libssl-dev \
  libcurl4-gnutls-dev \
  libexpat1-dev \
  zlib1g-dev \
  && apt autoremove -y \
  && rm -rf /var/lib/apt/lists/* \
  && git --version

# Install Docker CLI and Compose using official Debian packages
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt update \
  && apt install -y docker-ce-cli docker-compose-plugin

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R node:node /usr/local/share

ARG USERNAME=node

# Persist bash history.
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R $USERNAME /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace and config directories and set permissions
RUN mkdir -p /workspace /home/node/.claude && \
  chown -R node:node /workspace /home/node/.claude

WORKDIR /workspace

RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/0.18.2/git-delta_0.18.2_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_0.18.2_${ARCH}.deb" && \
  rm "git-delta_0.18.2_${ARCH}.deb"


# Copy uv + uvx into PATH (docs show /uv and /uvx at the root)
COPY --from=uvbin /uv /uvx /usr/local/bin/
# Smoke test
RUN uv --version && uvx --version


# Set up non-root user
USER node

# Install Bun as node user
ENV BUN_INSTALL="/home/node/.bun"
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="$BUN_INSTALL/bin:$PATH"

# Install global packages
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to bash rather than sh
ENV SHELL=/bin/zsh

# Default powerline10k theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.2.0/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

RUN npm install -g @anthropic-ai/claude-code@2.0.32
