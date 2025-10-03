# Neovim Docker Environment for Ruby Developers

A Docker-based isolated environment for Ruby developers to experiment with Neovim configuration using Lua, without affecting your current Neovim setup.

## Overview

This project creates a Docker container with Neovim, Ruby, and essential Ruby development tools, allowing you to:
- Test Neovim configurations for Ruby development
- Use Lua for plugin management and configuration
- Keep your local Neovim setup untouched
- Share and reproduce the Ruby development environment across different machines
- **Ruby-focused setup**: Solargraph LSP, Rubocop linting, and Ruby-aware autocompletion
- **Modern autocompletion**: nvim-cmp with LSP, buffer, path, cmdline, and Lua sources
- **Diagnostics and search**: Telescope integration for diagnostics, files, and more

## Ruby Development Features

This environment is specifically configured for Ruby development with:

- **Ruby LSP**: Solargraph for intelligent code completion, go-to-definition, and refactoring
- **Ruby Linting**: Rubocop integration for code style and quality checks
- **Modern Plugin Manager**: lazy.nvim for efficient plugin management
- **Autocompletion**: nvim-cmp with Ruby-aware completion powered by Solargraph
- **Fuzzy Search**: Telescope for file navigation, diagnostics, and Ruby-specific searches
- **Diagnostics**: Real-time error highlighting and inline diagnostics from both LSP and Rubocop

## Testing This Solution

The easiest way to test this Neovim setup for Ruby development is using the provided Makefile commands:

### Available Commands

Run `make help` to see all available commands:

```bash
make help
```

### Quick Test Commands

1. **Build the Docker image** (first time only):
   ```bash
   make build
   ```

2. **Test with a Ruby project** (recommended):
   ```bash
   # Mount a specific Ruby project
   NVIM_WORKSPACE=/path/to/your/ruby/project make nvim
   
   # Or use your home directory (default)
   make nvim
   ```

3. **Open a shell for testing**:
   ```bash
   # Mount a specific Ruby project
   NVIM_WORKSPACE=/path/to/your/ruby/project make shell
   
   # Or use your home directory (default)
   make shell
   ```

### Testing Ruby Features

Once inside Neovim (via `make nvim`), test these Ruby development features:

1. **Open a Ruby file**:
   ```vim
   :e /workspace/your_ruby_file.rb
   ```

2. **Test autocompletion**: Type Ruby code and use `<Tab>` or `<C-Space>` for completions

3. **Test LSP features**:
   - `gd` - Go to definition
   - `gr` - Go to references
   - `K` - Show documentation

4. **Test diagnostics**: Look for inline error highlighting and use `:Telescope diagnostics` to see all issues

5. **Test Rubocop integration**: Save a file and check for style violations

6. **Check health**: Run `:checkhealth` to verify all components are working

### Workspace Mounting

The Makefile automatically mounts your workspace:
- If `NVIM_WORKSPACE` is set, that path is mounted at `/workspace`
- If not set, your home directory (`$HOME`) is mounted at `/workspace` by default

This allows you to edit Ruby files from your host system inside the Docker container.

## Prerequisites

- Docker installed on your system
- Docker Compose installed on your system

## Quick Start

### 1. Clone this repository

```bash
git clone <your-repo-url>
cd nvim-docker
```

### 2. Build and test the solution

```bash
# Build the Docker image (first time only)
make build

# Test with a Ruby project
NVIM_WORKSPACE=/path/to/your/ruby/project make nvim

# Or test with your home directory
make nvim
```

That's it! You're now testing the Neovim setup for Ruby development.

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

## Ruby Development Workflow

1. **Mount your Ruby project**: Use `NVIM_WORKSPACE=/path/to/ruby/project make nvim`
2. **Edit Ruby files**: Open files from `/workspace` inside Neovim
3. **Test Ruby features**: Use autocompletion, LSP navigation, and Rubocop linting
4. **Iterate configuration**: Modify files in `nvim_config/` and test with `make nvim`
5. **Share setup**: Commit your configuration to version control for team sharing

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
