# Neovim Docker Environment

A Docker-based isolated environment for experimenting with Neovim configuration using Lua, without affecting your current Neovim setup.

## Overview

This project creates a Docker container with Neovim and Lua installed, allowing you to:
- Experiment with Neovim configuration from scratch
- Use Lua for plugin management and configuration
- Keep your local Neovim setup untouched
- Share and reproduce the environment across different machines

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system

## Quick Start

### 1. Clone or download this repository

```bash
git clone <your-repo-url>
cd nvim_docker
```

### 2. Build the Docker image

The Dockerfile uses Ubuntu 22.04 as the base image and compiles Neovim from source, ensuring compatibility with all processor architectures including ARM64 (Apple Silicon) and x86_64.

Additionally, it installs:
- Git, curl, ninja-build, gettext, cmake
- Build tools (build-essential)
- ca-certificates

This approach guarantees compatibility across all platforms and avoids issues with architecture-specific binaries or missing AppImages.

```bash
docker build --no-cache -t nvim-lua .
```

### 3. Run the container

```bash
docker compose run --rm nvim-service
```

This will open the shell.

### 4. Start Neovim

From the container shell, run:

```bash
nvim
```

## Project Structure

```
nvim_docker/
├── Dockerfile              # Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── nvim_config/           # Your Neovim configuration (mounted as volume)
└── README.md              # This file
```

## Detailed Setup Steps

### Step 1: Build the Docker Image

The Dockerfile installs:
- Ubuntu 22.04 as base image
- Neovim (latest version, installed from the official AppImage release)
- Git, curl, wget, unzip
- Build tools (build-essential)
- Lua and LuaRocks
- Python3 and pip
- **fuse** (needed to extract and run the Neovim AppImage)

Neovim is downloaded as an AppImage from the [official releases](https://github.com/neovim/neovim/releases/latest), extracted, and linked as the main `nvim` binary. This ensures you always have the latest stable version, compatible with modern plugins like lazy.nvim.

```bash
docker build --no-cache -t nvim-lua .
```

### Step 2: Configure Docker Compose

The `docker-compose.yml` file:
- Maps your local `nvim_config/` directory to `/home/nvimuser/.config/nvim` in the container
- Creates a non-root user for security
- Sets up interactive terminal support
- Configures the working directory

## Usage

### Accessing the container shell

```bash
docker compose run --rm nvim-service
```

And from within the container, run:

```bash
nvim
```

## Configuration

### Visual Configuration Notes

- **iTerm2/Terminal**: Controls font, font size, background color, transparency, and terminal color scheme
- **Neovim**: Controls code syntax highlighting, Neovim interface theme, and editor-specific colors

To ensure consistent appearance between Docker and local Neovim:
1. Use the same color scheme in both iTerm2 and Neovim
2. Font and font size are controlled by your terminal, not Neovim

### Adding Your Neovim Configuration

Place your Neovim configuration files in the `nvim_config/` directory:

```
nvim_config/
├── init.lua              # Main Neovim configuration
├── lua/
│   ├── plugins.lua       # Plugin definitions
│   ├── keymaps.lua       # Key mappings
│   └── settings.lua      # Editor settings
└── after/
    └── plugin/           # Plugin-specific configurations
```

## Troubleshooting

### Configuration changes not reflected

Ensure the volume mapping is correct in `docker-compose.yml`:

```yaml
volumes:
  - ./nvim_config:/home/nvimuser/.config/nvim
```

### Permission issues

The container runs as a non-root user (`nvimuser`). If you encounter permission issues, check that the `nvim_config/` directory has appropriate permissions.

## Development Workflow

1. **Edit configuration**: Modify files in `nvim_config/` on your local machine
2. **Test changes**: Run `docker compose run --rm nvim-service` to test
3. **Iterate**: Make changes and test again
4. **Commit**: When satisfied, commit your configuration to version control

## Sharing and Reproducing

To use this setup on another machine:

1. Clone this repository
2. Ensure Docker and Docker Compose are installed
3. Run the setup commands:
   ```bash
   docker build -t nvim-lua .
   mkdir -p nvim_config
   docker compose run --rm nvim-service
   ```

## Contributing

Feel free to submit issues and enhancement requests!

## License

[Add your license here] 
