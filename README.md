# Neovim Docker Environment

A Docker-based isolated environment for experimenting with Neovim configuration using Lua, without affecting your current Neovim setup.

## Overview

This project creates a Docker container with Neovim and Lua installed, allowing you to:
- Experiment with Neovim configuration from scratch
- Use Lua for plugin management and configuration
- Keep your local Neovim setup untouched
- Share and reproduce the environment across different machines
- **Advanced Ruby support**: asdf-managed Ruby, Solargraph LSP, Rubocop diagnostics
- **Modern autocompletion**: nvim-cmp with LSP, buffer, path, cmdline, and Lua sources
- **Diagnostics and search**: Telescope integration for diagnostics, files, and more

## Notable Plugins

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletion engine
  - [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
  - [cmp-buffer](https://github.com/hrsh7th/cmp-buffer)
  - [cmp-path](https://github.com/hrsh7th/cmp-path)
  - [cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline)
  - [cmp-nvim-lua](https://github.com/hrsh7th/cmp-nvim-lua)
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP/DAP/linter installer
- [mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP configuration
- [none-ls.nvim (null-ls)](https://github.com/nvimtools/none-ls.nvim) - External diagnostics (Rubocop)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder and diagnostics picker
- [solargraph](https://solargraph.org/) - Ruby LSP (via gem and Mason)
- [rubocop](https://github.com/rubocop/rubocop) - Ruby linter (via null-ls)

## Ruby Support

- Ruby is managed via [asdf](https://asdf-vm.com/), with the version specified at build time (see `.ruby-version`).
- Solargraph LSP is installed globally (via Mason) and can be used in any Ruby project.
- Rubocop diagnostics are provided via null-ls, using `bundle exec` if a Gemfile is present.

## Autocompletion

- nvim-cmp provides autocompletion from LSP, buffer, path, cmdline, and Lua sources.
- Solargraph powers Ruby-aware completion and navigation.

## Diagnostics and Search

- Telescope is integrated for searching files, buffers, and diagnostics (`<leader>sd`).
- Diagnostics from both LSP and Rubocop are shown inline and in Telescope.

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
- ripgrep (for fast text searching with Telescope)

This approach guarantees compatibility across all platforms and avoids issues with architecture-specific binaries or missing AppImages. Neovim is cloned and built from the official GitHub repository during the image build process.

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

The Dockerfile compiles Neovim from source on top of Ubuntu 22.04, ensuring compatibility with all processor architectures (including ARM64/Apple Silicon and x86_64).

Dependencies installed include:
- Git, curl, ninja-build, gettext, cmake
- Build tools (build-essential)
- ca-certificates
- ripgrep (for fast text searching with Telescope)

Neovim is cloned from the official GitHub repository and built during the image build process. This approach avoids issues with pre-built binaries and ensures the latest stable version is used, regardless of your host architecture.

To build the image:

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

### Mounting a Local Folder as Workspace

You can mount any local folder into the container at `/workspace` by setting the `NVIM_WORKSPACE` environment variable. This allows you to use Neovim inside Docker with any project or directory from your host system.

- If `NVIM_WORKSPACE` is set, that path will be mounted at `/workspace` inside the container.
- If `NVIM_WORKSPACE` is **not** set, your home directory (`$HOME`) will be mounted at `/workspace` by default.

**Examples:**

- Mount a specific project folder:
  ```sh
  NVIM_WORKSPACE=/Users/youruser/projects/myproject make nvim
  ```
- Use your home directory (default):
  ```sh
  make nvim
  ```

Inside Neovim (in Docker), you can then open files from `/workspace` as needed.

This makes the setup flexible and user-friendly for different workflows and users.

## Configuration

### Visual Configuration Notes

- **Terminal color scheme (iTerm2, Terminal, etc.):** Controls the base colors of the terminal background, text, and ANSI colors. This affects all terminal applications, including Neovim.
- **Neovim color scheme (via plugins like lazy.nvim):** Controls how Neovim colors code, UI, and background. Examples: `tokyonight`, `gruvbox`, etc.

If you have `termguicolors` enabled in your Neovim config (which is recommended and already set in this setup), Neovim will use truecolor (24-bit) and display its themes as intended, regardless of the terminal's color scheme—**as long as your terminal supports truecolor**.

**Recommendation:**
- For the best visual experience with modern Neovim themes, use a terminal with full truecolor support, such as iTerm2, Alacritty, or Kitty.
- The default Terminal app on macOS may display colors differently or less vibrantly, even with `termguicolors` enabled.
- You do NOT need to match your terminal's color scheme to your Neovim theme if you use truecolor.

**Summary:**
- Use a modern terminal with truecolor support for the best Neovim appearance.
- `termguicolors` should be enabled in your Neovim config (already set).
- Neovim's theme will look the same inside and outside Docker, provided your terminal supports truecolor.

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
