# Neovim Config

Single-file Neovim configuration at `init.lua`. Entrypoint for all changes.

## Platform

- Windows (pwsh/powershell default terminal shell)
- Uses Neovim 0.12+ LSP API (`vim.lsp.config`, `vim.lsp.enable`)

## Plugin setup

- **Manager**: lazy.nvim — add/remove plugins inside `require("lazy").setup({...})` in `init.lua`
- **Lockfile**: `lazy-lock.json` — auto-managed, do not edit manually
- All config is inline in `init.lua`; there is no `lua/` directory

## Added plugins

- **vimtex** — full LaTeX suite: compilation, PDF viewing, forward/inverse search
- **texlab** — LaTeX LSP server (auto-installed by mason)

## Keymaps

| Binding | Action |
|---|---|
| `<leader>e` / `<C-e>` | Toggle file tree (nvim-tree) |
| `<leader>t` / `<C-t>` | Toggle terminal (toggleterm) |
| `<leader>ff` | Telescope find_files |
| `<leader>fg` | Telescope live_grep |
| `<leader>fb` | Telescope buffers |
| `<leader>g` | Lazygit |
| `<leader>ai` | Open OpenCode in vertical terminal split |
| `<leader>pv` | Open compiled PDF in system default viewer |
| `<leader>fi` | Submit feedback via GitHub Issues |
| `<leader>uc` | Customize theme, font & icons |
| `<Tab>` / `<S-Tab>` | BufferLine cycle next/prev |
| `<C-x/c/v>` (n/v) | Clipboard cut/copy/paste via `"+` register |
| `<A-h>` / `<A-l>` (n/t) | Navigate windows left/right |

## Conventions

- Auto-save on `TextChanged` / `InsertLeave` (all writable named buffers)
- Empty unnamed buffers auto-close on `BufLeave`
- Tab completion maps `<Tab>` / `<S-Tab>` for nvim-cmp navigation
- LSP servers auto-installed by mason: `pyright`, `clangd`, `lua_ls`, `texlab`
- Only formatter configured: `stylua` (via none-ls.nvim)
- **Live reload**: `autoread` + `checktime` on `FocusGained`/`BufEnter` + 1s timer — designed so external file writes (e.g. OpenCode) appear without manual `:e`
- **None-ls quirk**: plugin `nvimtools/none-ls.nvim` exposes API as `require("null-ls")`, not `require("none-ls")`
- **Null-ls vs none-ls quirk**: the plugin `nvimtools/none-ls.nvim` exposes its API via `require("null-ls")`, not `require("none-ls")`

## No dev commands

This is an end-user config, not a library or application. No tests, no build, no CI.
