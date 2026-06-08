# Console IDE

> *Where the terminal becomes your IDE.*

A Neovim configuration that bridges the gap between Vim, VSCode, and Cursor — built for developers who live in the terminal and want a fast, keyboard-driven editor with modern IDE features.

**Console IDE** is a single-file, zero-bloat Neovim config that gives you VSCode-level usability — fuzzy search, LSP autocomplete, inline diagnostics, AI coding via OpenCode, and sane keybinds — without the GUI overhead. Everything runs in your terminal, as it should.

No mouse. No distractions. Just you and your codebase.

## Features

- **Dashboard** — Alpha-nvim dashboard with rotating taglines and ASCII art
- **Command Palette** (`<leader>h`) — Fuzzy searchable keybind reference and Vim command explorer with live search
- **LSP Integration** — Auto-installed language servers (pyright, clangd, lua_ls) via Mason with goto-definition, hover docs, rename, code actions, and formatting
- **Autocomplete** — nvim-cmp with LSP, snippet, buffer, and path sources (Tab/S-Tab navigation)
- **Dual Keybind Mode** — Switch between pure Vim keybinds and VSCode-style binds via `:SetKeybindMode {vim|vscode}`
- **Themes** — Dark (cursor-dark), Light (catppuccin-latte), Mocha (catppuccin-mocha) via `:SetTheme {dark|light|mocha}`
- **Inline Diagnostics** — Error-lens shows LSP diagnostics inline; live diagnostics in insert mode
- **File Tree** — nvim-tree with `<leader>e` or `<C-e>`
- **Terminal** — ToggleTerm with `<leader>t` or `<C-t>` (auto-detects pwsh/powershell/bash)
- **Fuzzy Finder** — Telescope for files, live grep, and buffers
- **Buffer Tabs** — BufferLine with `<Tab>` / `<S-Tab>` cycling
- **Status Line** — Lualine with auto theme
- **Git Integration** — Gitsigns for inline git indicators; Lazygit via `<leader>g`
- **Auto-save** — Automatic saving on TextChanged and InsertLeave
- **Live Reload** — Auto-read detects external file changes (1s polling timer)
- **AI Coding** — OpenCode integration via `<leader>ai` in a vertical split
- **Settings Panel** (`:SettingsStatus`) — Tab-based interactive settings with toggle/setter commands
- **First-launch Welcome** — Floating welcome popup on initial startup
- **Session Persistence** — Lazy.nvim locks plugin versions in `lazy-lock.json`
- **LaTeX Support** — vimtex for compilation, texlab LSP for autocomplete, treesitter for syntax highlighting
- **PDF Viewer** (`<leader>pv`) — Opens compiled PDF in system default viewer; guard prevents raw binary display
- **Update Checker** — Checks GitHub for new commits on startup (800ms defer), shows release notes popup with `y` to install
- **Feedback** (`<leader>fi`) — Opens GitHub Issues page with pre-filled system info for bug reports
- **Customization Panel** (`<leader>uc`) — Interactive panel to change theme, font, and check/install Nerd Font for icons

## Prerequisites

Install these **before** setting up Console IDE:

| Requirement | Version | Download |
|---|---|---|
| [Neovim](https://neovim.io) | 0.12+ | [neovim.io/download](https://neovim.io/download) |
| [Git](https://git-scm.com) | Any recent | [git-scm.com](https://git-scm.com/downloads) |
| [Node.js / npm](https://nodejs.org) | 18+ LTS | [nodejs.org](https://nodejs.org) |
| [opencode](https://opencode.ai) | Latest | [opencode.ai/download](https://opencode.ai/download) |
| Terminal | True color support | Windows Terminal / iTerm2 / Kitty / Alacritty |

### Why each is needed

- **Neovim** — The editor itself (uses `vim.lsp.config`, `vim.lsp.enable` APIs from 0.12+)
- **Git** — Required by lazy.nvim to clone plugins; also needed for Git signs and Lazygit features
- **Node.js / npm** — Many LSP servers (pyright, etc.) and tools like opencode depend on the npm ecosystem
- **opencode** — Powers the AI coding assistant opened via `<leader>ai`
- **Terminal with true color** — Essential for correct colorscheme rendering (dark/light/mocha themes)

### Optional (recommended)

- A [Nerd Font](https://www.nerdfonts.com/) for icon rendering (auto-installed by `setup.ps1`)
- [lazygit](https://github.com/jesseduffield/lazygit) for the `<leader>g` git UI

## Installation

### Windows

```powershell
# 1. Back up your existing config (if any)
Rename-Item "$env:LOCALAPPDATA\nvim" "$env:LOCALAPPDATA\nvim.bak" -ErrorAction SilentlyContinue
Rename-Item "$env:LOCALAPPDATA\nvim-data" "$env:LOCALAPPDATA\nvim-data.bak" -ErrorAction SilentlyContinue

# 2. Clone the repo
git clone https://github.com/devkesav/Console-IDE-NeoVim-Theme-.git "$env:LOCALAPPDATA\nvim"

# 3. (Recommended) Run setup script to install Nerd Font & configure terminal
#    Run as Administrator:
#    powershell -ExecutionPolicy Bypass -File "$env:LOCALAPPDATA\nvim\setup.ps1"

# 4. Launch Neovim — plugins will auto-install
nvim
```

### macOS / Linux

```bash
# 1. Back up your existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null
mv ~/.cache/nvim ~/.cache/nvim.bak 2>/dev/null

# 2. Clone the repo
git clone https://github.com/devkesav/Console-IDE-NeoVim-Theme-.git ~/.config/nvim

# 3. Launch Neovim — plugins will auto-install
nvim
```

### Post-installation

On first launch, Lazy.nvim will automatically:
1. Install all plugins listed in the config
2. Mason will download language servers (pyright, clangd, lua_ls)
3. Treesitter will install parsers for supported languages
4. A welcome popup will greet you

This may take 1–3 minutes depending on your internet connection.

### Updating

Plugins update automatically via lazy.nvim. To manually update:

```
:Lazy update
```

Or check status with:

```
:Lazy
```

## First Launch

When you start Neovim for the first time:

1. **Plugin installation** begins automatically — you'll see Lazy.nvim's install window
2. **Welcome popup** appears on the first successful launch (dismiss by pressing any key)
3. **Dashboard** displays the Console IDE logo, a random tagline, and action buttons
4. **Mason** downloads LSP servers in the background (check `:Mason` for status)

## Usage

### Dashboard

| Button | Action |
|---|---|
| `e` | New File |
| `f` | Find File (Telescope) |
| `r` | Recent Files |
| `g` | Live Grep |
| `s` | Settings Panel |
| `c` | Customize (theme, font, icons) |
| `h` | Command Palette |
| `a` | About |
| `q` | Quit |

### Keybindings

#### Default (Vim mode)

| Binding | Action |
|---|---|
| `<leader>ff` | Find File |
| `<leader>fg` | Live Grep |
| `<leader>fb` | Switch Buffers |
| `<leader>e` / `<C-e>` | Toggle File Tree |
| `<leader>t` / `<C-t>` | Toggle Terminal |
| `<leader>ai` | Open OpenCode AI |
| `<leader>g` | Open Lazygit |
| `<leader>s` / `<C-,>` | Open Settings |
| `<leader>pv` | View compiled PDF |
| `<leader>fi` | Submit feedback (GitHub Issues) |
| `<leader>uc` | Customize theme, font & icons |
| `<leader>h` | Command Palette |
| `<Tab>` / `<S-Tab>` | Next / Previous Buffer |
| `<A-h>` / `<A-l>` | Navigate windows left/right |
| `<C-x/c/v>` | Cut / Copy / Paste |

#### VSCode mode

Switch with `:SetKeybindMode vscode`:

| Binding | Action |
|---|---|
| `<C-p>` | Find File |
| `<C-b>` | Toggle File Tree |
| `<C-``>` | Toggle Terminal |
| `<C-s>` | Save |
| `<C-z>` / `<C-y>` | Undo / Redo |
| `<C-/>` | Toggle Comment |
| `<C-a>` | Select All |
| `<C-f>` | Find in File |
| `<Tab>` / `<C-Tab>` | Next / Previous Buffer |
| `<A-Up>` / `<A-Down>` | Move line up/down |
| `<leader>pv` | View compiled PDF |
| `<leader>fi` | Submit feedback (GitHub Issues) |
| `<leader>uc` | Customize theme, font & icons |

> Press `<leader>h` to open the Command Palette which lists all available keybinds and Vim commands with live fuzzy search.

### Command Palette (`<leader>h`)

A fuzzy-searchable floating window with two tabs:

- **Keybinds tab** — Lists all active keybinds for the current mode (Vim/VSCode) with priority ratings
- **Vim Cmds tab** — Lists 60+ Vim commands organized by category with run-on-enter execution

| Key | Action |
|---|---|
| `Tab` | Switch between Keybinds / Vim Cmds tabs |
| `/` | Start live search (type to filter) |
| `j` / `k` | Navigate results |
| `Enter` | Execute selected Vim command |
| `Esc` | Clear search / close palette |
| `q` | Close palette |
| `1` / `2` | Jump to Keybinds / Vim Cmds tab |

### Settings Panel (`:SettingsStatus`)

Opens a new tab showing all configurable options:

- **Toggle items** — Press Enter to toggle ON/OFF (line numbers, word wrap, LSP, autosave, etc.)
- **Setter items** — Tab width (2–8), OC width (30–90), Theme (dark/light/mocha), Keybind mode (vim/vscode)
- **Cycle items** — Theme and Keybind mode cycle through options on each Enter press

Individual toggle commands are also available:

```
:ToggleLinenr
:ToggleWordwrap
:ToggleLsp_enabled
:ToggleAutosave
:ToggleBufferline
... (23+ commands)
```

### LaTeX

Console IDE includes full LaTeX support via vimtex and texlab:

| Key / Command | Action |
|---|---|
| `<leader>pv` | Open compiled PDF in system default viewer |
| `:PdfView` | Same as above |
| `:ToggleTexlab` | Toggle texlab LSP on/off on the fly |

LaTeX features:
- **Compilation** — vimtex auto-detects `latexmk` and compiles on save
- **LSP** — texlab provides autocomplete, hover docs, goto-definition
- **Syntax** — treesitter highlights `.tex` and `.bib` files
- **PDF guard** — opening a `.pdf` shows a friendly message with `<leader>pv` prompt instead of raw binary

### Themes

Three themes available:

| Name | Command | Colorscheme |
|---|---|---|
| Dark | `:SetTheme dark` | cursor-dark (default) |
| Light | `:SetTheme light` | catppuccin-latte |
| Mocha | `:SetTheme mocha` | catppuccin-mocha |

## Custom Commands Reference

| Command | Arguments | Description |
|---|---|---|
| `:SettingsStatus` | — | Open interactive settings table |
| `:SetTheme` | `{dark\|light\|mocha}` | Change colorscheme |
| `:SetTabWidth` | `{2-8}` | Set tab/indent width |
| `:SetOCWidth` | `{30-90}` | Set OpenCode panel width |
| `:SetKeybindMode` | `{vim\|vscode}` | Switch keybinding mode |
| `:Toggle*` | — | Toggle any boolean setting (23+ commands) |
| `:PdfView` | `[file]` | Open PDF in system default viewer |
| `:Feedback` | — | Open GitHub Issues with pre-filled system info |
| `:Customize` | — | Open customization panel (theme, font, icons) |
| `:SetFont` | `{name:h#}` | Set GUI font (e.g. `JetBrainsMono Nerd Font Mono:h11`) |
| `:CheckNerdFont` | — | Check if Nerd Font is installed |
| `:ToggleTexlab` | — | Enable/disable texlab LSP server |

## Project Structure

```
~/.config/nvim/          # or %LOCALAPPDATA%\nvim on Windows
├── init.lua             # Single-file configuration (~1990 lines)
├── lazy-lock.json       # Plugin version lockfile (auto-managed)
├── AGENTS.md            # Instructions for AI agents
├── windows-terminal.json  # Windows Terminal font config snippet (merge manually)
├── setup.ps1            # One-click setup script (font install + terminal config)
└── README.md            # This file
```

There is no `lua/` directory — everything lives in `init.lua` for simplicity.

## Troubleshooting

### Windows

#### "Failed to clone lazy.nvim"

Ensure Git is installed and available in your PATH. Test with:

```powershell
git --version
```

If Git is not found, install it from [git-scm.com](https://git-scm.com) and restart your terminal.

#### Plugins fail to install / SSL errors

Open PowerShell as Administrator and run:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
```

Then run `:Lazy install` inside Neovim.

#### Terminal shows garbled icons / missing characters

Install a Nerd Font (e.g., [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads)) and set it as your terminal font.

#### LSP servers not starting

Check Mason status:

```
:Mason
```

Ensure the server is installed. If not, install manually:

```
:MasonInstall pyright clangd lua_ls
```

#### Colors look wrong / no syntax highlighting

Ensure your terminal supports true color (24-bit color). In Windows Terminal, add to your `settings.json`:

```json
"experimental.rendering.forceFullRepaint": true,
"colorScheme": "Campbell"
```

#### Lazygit not opening

Install lazygit via:

```powershell
winget install lazygit
```

Or download from [github.com/jesseduffield/lazygit](https://github.com/jesseduffield/lazygit).

### macOS

#### "Operation not permitted" on config directory

Ensure the `~/.config/nvim` directory has correct permissions:

```bash
chmod -R 755 ~/.config/nvim
```

#### LSP servers not found

Mason installs to `~/.local/share/nvim/mason`. Ensure this path is in your system PATH or let Mason handle it automatically.

#### Terminal colors are incorrect

Make sure your terminal emulator (iTerm2, Kitty, Alacritty) has true color enabled:

```bash
# For iTerm2 — set "Minimum contrast" to 0 in Preferences > Profiles > Colors
# For Kitty — ensure `true_color` is not disabled in kitty.conf
```

### Linux

#### Missing dependencies for Treesitter parsers

Some parsers need a C compiler. Install build-essential:

```bash
# Debian/Ubuntu
sudo apt install build-essential

# Fedora
sudo dnf groupinstall "Development Tools"

# Arch
sudo pacman -S base-devel
```

#### Clipboard not working

Neovim requires `xclip` or `wl-clipboard` for system clipboard integration:

```bash
# X11
sudo apt install xclip

# Wayland
sudo apt install wl-clipboard
```

#### Slow startup

If startup feels slow, profile it:

```
: Lazy profile
: Lazy log
```

Common causes: slow DNS for Git operations, large treesitter parsers, or Mason downloading in the background.

### General

#### Plugin errors after update

If a plugin update breaks something:

```
:Lazy restore
```

This reverts to the locked versions in `lazy-lock.json`.

#### All plugins failed to load

Delete the lockfile and reinstall:

```bash
# macOS / Linux
rm -rf ~/.local/share/nvim/lazy ~/.cache/nvim
nvim

# Windows PowerShell
Remove-Item -Recurse "$env:LOCALAPPDATA\nvim-data\lazy", "$env:LOCALAPPDATA\nvim-data\cache" -ErrorAction SilentlyContinue
nvim
```

#### Mason won't install LSP servers

Check your internet connection and proxy settings. Mason uses `curl` on macOS/Linux and `powershell` on Windows for downloads.

#### "E5113" or Lua errors after editing init.lua

Run `:luafile %` from within `init.lua` to check for syntax errors:

```
:luafile %
```

If there's an error, open an issue with the error message on the [GitHub repository](https://github.com/devkesav/Console-IDE-NeoVim-Theme-).

#### Nvim-tree shows "E5108: Error executing lua"

This can happen if `nvim-web-devicons` is missing or broken. Reinstall:

```
:Lazy sync
```

## Plugins

Console IDE uses the following plugins (managed by Lazy.nvim):

| Plugin | Purpose |
|---|---|
| [alpha-nvim](https://github.com/goolord/alpha-nvim) | Dashboard |
| [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) | File explorer |
| [toggleterm](https://github.com/akinsho/toggleterm.nvim) | Terminal |
| [telescope](https://github.com/nvim-telescope/telescope.nvim) | Fuzzy finder |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) | Autocomplete |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) | LSP client |
| [mason](https://github.com/williamboman/mason.nvim) | LSP installer |
| [treesitter](https://github.com/nvim-treesitter/nvim-treesitter) | Syntax highlighting |
| [cursor-dark.nvim](https://github.com/ydkulks/cursor-dark.nvim) | Dark theme |
| [catppuccin](https://github.com/catppuccin/nvim) | Light/Mocha themes |
| [bufferline](https://github.com/akinsho/bufferline.nvim) | Buffer tabs |
| [lualine](https://github.com/nvim-lualine/lualine.nvim) | Status line |
| [which-key](https://github.com/folke/which-key.nvim) | Keybind hints |
| [gitsigns](https://github.com/lewis6991/gitsigns.nvim) | Git indicators |
| [lazygit](https://github.com/kdheepak/lazygit.nvim) | Git UI |
| [error-lens](https://github.com/chikko80/error-lens.nvim) | Inline diagnostics |
| [indent-blankline](https://github.com/lukas-reineke/indent-blankline.nvim) | Indent guides |
| [none-ls](https://github.com/nvimtools/none-ls.nvim) | Formatter (stylua) |
| [nvim-autopairs](https://github.com/windwp/nvim-autopairs) | Auto pairs |
| [Comment.nvim](https://github.com/numToStr/Comment.nvim) | Comment toggling |
| [nvim-surround](https://github.com/kylechui/nvim-surround) | Surround editing |
| [neoscroll](https://github.com/karb94/neoscroll.nvim) | Smooth scrolling |
| [vimtex](https://github.com/lervag/vimtex) | LaTeX suite (compile, view, forward search) |

## C Development Setup Guide

A quick reference for setting up C development with this config (Clang on Windows, GCC on Linux).

### Overview

| Tool | Purpose | Platform |
|------|---------|----------|
| **GCC** | Compile C code | Linux |
| **Clang** | Compile C code | Windows |
| **clangd** | LSP for Neovim (autocomplete, errors) | Both |
| **VS Build Tools** | C standard headers (`stdio.h` etc.) | Windows only |

### Windows Setup (Clang)

#### 1. Install LLVM/Clang

```powershell
winget install LLVM.LLVM
```

#### 2. Add LLVM to PATH

1. Search **"Environment Variables"** in Windows Start
2. Click **"Edit the system environment variables"**
3. Click **"Environment Variables"**
4. Under **System variables**, find **Path** → click **Edit**
5. Click **New** and add: `C:\Program Files\LLVM\bin`
6. Click OK → OK → OK

#### 3. Verify

```powershell
clang --version
```

#### 4. Install Visual Studio Build Tools (for headers)

```powershell
winget install Microsoft.VisualStudio.2022.BuildTools
```

Then:
1. Open **Visual Studio Installer** from Start menu
2. Click **Modify** on Build Tools 2022
3. Check **"Desktop development with C++"**
4. Click **Install** (~1.6 GB)

#### 5. Configure clangd (fix `stdio.h not found`)

Create `~\.config\clangd\config.yaml`:

```powershell
mkdir "$env:USERPROFILE\.config\clangd" -Force
notepad "$env:USERPROFILE\.config\clangd\config.yaml"
```

Content:

```yaml
CompileFlags:
  Add: ["-IC:/Program Files/LLVM/lib/clang/22/include"]
```

#### 6. Compile and Run

```powershell
clang hello.c -o hello.exe
./hello.exe
```

### Linux Setup (GCC)

#### 1. Install GCC

```bash
sudo apt install gcc
```

#### 2. Verify

```bash
gcc --version
```

#### 3. Compile and Run

```bash
gcc hello.c -o hello
./hello
```

### Neovim LSP Setup (Both Platforms)

clangd is already auto-installed via Mason on first launch (see [Features](#features)). To manually trigger:

```
:MasonInstall clangd
```

Restart Neovim — clangd will activate automatically on `.c` files.

### Clang vs GCC — When to Use Which

| Situation | Use |
|-----------|-----|
| Windows C development | **Clang** |
| Linux C development | **GCC** |
| C + Python app | **GCC** |
| Embedded systems | **GCC** |
| Better error messages | **Clang** |
| Open source Linux projects | **GCC** |
| macOS development | **Clang** |

### Quick Reference

| Command | Description |
|---------|-------------|
| `clang hello.c -o hello.exe` | Compile with Clang (Windows) |
| `gcc hello.c -o hello` | Compile with GCC (Linux) |
| `./hello.exe` | Run on Windows |
| `./hello` | Run on Linux |
| `clang --version` | Check Clang version |
| `gcc --version` | Check GCC version |
| `:MasonInstall clangd` | Install clangd LSP in Neovim |
| `:LspRestart` | Restart LSP in Neovim |

## Connect

- **GitHub** — [github.com/devkesav](https://github.com/devkesav)
- **LinkedIn** — [linkedin.com/in/devkesav](https://linkedin.com/in/devkesav)
- **Instagram** — [instagram.com/kesava_d_raj](https://instagram.com/kesava_d_raj)

---

Built with ❤️ by **Kesava D Raj** — Think in code. Move at the speed of thought.
