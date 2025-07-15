FROM ubuntu:22.04

# Install dependencies for asdf and Ruby
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
    gettext

# Install asdf
ENV ASDF_DIR=/opt/asdf
RUN git clone https://github.com/asdf-vm/asdf.git $ASDF_DIR --branch v0.14.0
ENV PATH="$ASDF_DIR/bin:$ASDF_DIR/shims:$PATH"

# Ensure asdf is available for all users
RUN echo '. /opt/asdf/asdf.sh' >> /etc/profile.d/asdf.sh && \
    echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"' >> /etc/profile.d/asdf.sh

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

# Set up asdf for nvimuser
RUN echo '. /opt/asdf/asdf.sh' >> ~/.bashrc && \
    echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"' >> ~/.bashrc

# Install Ruby plugin and Ruby 3.3.8 as nvimuser
# Install gem bundler and solargraph
RUN bash -c ". /opt/asdf/asdf.sh && asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git && asdf install ruby 3.3.8 && asdf global ruby 3.3.8 && gem install bundler solargraph"

# Create config directory
RUN mkdir -p /home/nvimuser/.config/nvim

CMD ["nvim"]
