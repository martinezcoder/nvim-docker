FROM ubuntu:22.04

# Install build dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ninja-build \
    gettext \
    cmake \
    unzip \
    build-essential \
    ca-certificates \
    ripgrep

# Clone and build Neovim from GitHub
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    rm -rf /tmp/neovim

# Create non-root user
RUN useradd -ms /bin/bash nvimuser
USER nvimuser
WORKDIR /home/nvimuser

# Create config directory
RUN mkdir -p /home/nvimuser/.config/nvim

CMD ["nvim"]
