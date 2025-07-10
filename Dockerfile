FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias de compilación
RUN apt-get update && apt-get install -y \
    git \
    curl \
    ninja-build \
    gettext \
    cmake \
    unzip \
    build-essential \
    ca-certificates

# Clonar y compilar Neovim desde GitHub
RUN git clone https://github.com/neovim/neovim.git /tmp/neovim && \
    cd /tmp/neovim && \
    make CMAKE_BUILD_TYPE=Release && \
    make install && \
    rm -rf /tmp/neovim

# Crear usuario no root
RUN useradd -ms /bin/bash nvimuser
USER nvimuser
WORKDIR /home/nvimuser

CMD ["nvim"]
