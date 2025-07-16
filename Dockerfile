FROM ubuntu:22.04

# Accept Ruby version as build argument and set it in the environment
ARG RUBY_VERSION
ENV ASDF_RUBY_VERSION=${RUBY_VERSION}

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

# Copy entrypoint script and make it executable
COPY entrypoint-ruby-nvim.sh /entrypoint-ruby-nvim.sh
RUN chmod +x /entrypoint-ruby-nvim.sh

# Create non-root user
RUN useradd -ms /bin/bash nvimuser

# Copy .ruby-version to nvimuser's home directory for entrypoint/runtime usage
COPY .ruby-version /home/nvimuser/.ruby-version
RUN chown nvimuser:nvimuser /home/nvimuser/.ruby-version

USER nvimuser
WORKDIR /home/nvimuser

# Set up asdf for nvimuser
RUN echo '. /opt/asdf/asdf.sh' >> ~/.bashrc && \
    echo 'export PATH="/opt/asdf/bin:/opt/asdf/shims:$PATH"' >> ~/.bashrc

# Install Ruby plugin as nvimuser
RUN bash -c ". /opt/asdf/asdf.sh && asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git"
# Install Ruby version and gems as nvimuser using build arg
RUN bash -c ". /opt/asdf/asdf.sh && asdf install ruby $ASDF_RUBY_VERSION && asdf global ruby $ASDF_RUBY_VERSION && gem install bundler solargraph"

# Create config directory
RUN mkdir -p /home/nvimuser/.config/nvim

CMD ["nvim"]
