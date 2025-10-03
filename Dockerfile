FROM ruby:latest

# Install dependencies for Neovim
RUN apt-get update && apt-get install -y \
    git \
    curl \
    autoconf \
    bison \
    build-essential \
    libssl-dev \
    libyaml-dev \
    libreadline-dev \
    zlib1g-dev \
    libncurses5-dev \
    libffi-dev \
    libgdbm6 \
    libgdbm-dev \
    libdb-dev \
    unzip \
    ca-certificates \
    ripgrep \
    cmake \
    ninja-build \
    gettext \
    gnupg \
    nodejs \
    npm

# Clean cache to reduce container size
RUN rm -rf /var/lib/apt/lists/*

# Clone and build Neovim from GitHub (as root)
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    rm -rf /tmp/neovim

# Create non-root user
RUN useradd -ms /bin/bash nvimuser

USER nvimuser
WORKDIR /home/nvimuser

# Install gems as nvimuser
RUN gem install bundler neovim solargraph

# Create config directory
RUN mkdir -p /home/nvimuser/.config/nvim

CMD ["nvim"]
