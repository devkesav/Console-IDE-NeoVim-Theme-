----── Settings state (DD = Console IDE runtime config) ────────────────────
local DD = {
    theme         = "dark",
    error_lens    = true,
    diag_live     = true,
    lsp_enabled   = true,
    pyright       = true,
    clangd        = true,
    lua_ls        = true,
    texlab        = true,
    nvim_cmp      = true,
    luasnip       = true,
    stylua        = true,
    treesitter    = true,
    opencode      = true,
    oc_width      = 53,
    whichkey      = true,
    gitsigns      = true,
    autosave      = true,
    autoread      = true,
    linenr        = true,
    relativenr    = false,
    ibl           = true,
    bufferline    = true,
    lualine       = true,
    wordwrap      = false,
    tabwidth      = 4,
    -- "vim" = pure Vim binds,  "vscode" = VSCode-style binds
    keybind_mode  = "vim",
    highlight_yank= true,
    guifont       = "JetBrainsMono NFM:h11",
}

-- ── Core editor options ───────────────────────────────────────────────────
vim.opt.number         = true
vim.opt.relativenumber = false
vim.opt.tabstop        = 4
vim.opt.shiftwidth     = 4
vim.opt.expandtab      = true
vim.opt.wrap           = false
vim.opt.termguicolors  = true
vim.opt.guifont        = DD.guifont
vim.opt.clipboard      = "unnamedplus"

-- ── Plugins ──────────────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
        }, true, {})
        return
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

    -- ── Colorschemes ─────────────────────────────────────────────────────
    {
        "ydkulks/cursor-dark.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            require("cursor-dark").setup({ style = "dark" })
            vim.cmd.colorscheme("cursor-dark")
        end,
    },
    {
        "catppuccin/nvim",
        lazy = false,
        priority = 1000,
        name = "catppuccin",
        config = function()
            require("catppuccin").setup({})
        end,
    },

    -- Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local alpha     = require("alpha")
            local dashboard = require("alpha.themes.dashboard")

    math.randomseed(os.time())

    local taglines = {
        "Where the terminal becomes your IDE.",
        "Code fast. Stay in the zone.",
        "One terminal to rule them all.",
        "Built for those who live in the terminal.",
        "No mouse. No mercy. Just code.",
        "Your terminal. Supercharged.",
        "Think in code. Move at the speed of thought.",
        "Vim soul. IDE power.",
    }

    local function center_line(text, width)
        local vis = vim.fn.strdisplaywidth(text)
        local left = math.floor((width - vis) / 2)
        local right = width - vis - left
        return string.rep(" ", left) .. text .. string.rep(" ", right)
    end

   dashboard.section.header.val = function()
    local tagline = taglines[math.random(#taglines)]
    local padded = center_line(tagline, 120)
    return {
        center_line("", 120),
        center_line(" ██████╗ ██████╗ ███╗   ██╗███████╗ ██████╗ ██╗     ███████╗    ██╗██████╗ ███████╗", 120),
        center_line("██╔════╝██╔═══██╗████╗  ██║██╔════╝██╔═══██╗██║     ██╔════╝    ██║██╔══██╗██╔════╝", 120),
        center_line("██║     ██║   ██║██╔██╗ ██║███████╗██║   ██║██║     █████╗      ██║██║  ██║█████╗  ", 120),
        center_line("██║     ██║   ██║██║╚██╗██║╚════██║██║   ██║██║     ██╔══╝      ██║██║  ██║██╔══╝  ", 120),
        center_line("╚██████╗╚██████╔╝██║ ╚████║███████║╚██████╔╝███████╗███████╗    ██║██████╔╝███████╗", 120),
        center_line(" ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝    ╚═╝╚═════╝ ╚══════╝", 120),
        center_line("", 120),
        center_line("Console IDE  ~  by Kesava D Raj", 120),
        padded,
        center_line("", 120),
    }
end
            dashboard.section.buttons.val = {
                dashboard.button("e", "  New File",      ":enew<CR>"),
                dashboard.button("f", "  Find File",     ":Telescope find_files<CR>"),
                dashboard.button("r", "  Recent Files",  ":Telescope oldfiles<CR>"),
                dashboard.button("g", "  Live Grep",     ":Telescope live_grep<CR>"),
                dashboard.button("s", "  Settings",      ":SettingsStatus<CR>"),
                dashboard.button("c", "  Customize",     ":Customize<CR>"),
                dashboard.button("h", "  Commands",      ":lua OpenCommandPalette()<CR>"),
                dashboard.button("a", "  About",         ":lua ShowAbout()<CR>"),
                dashboard.button("q", "  Quit",          ":qa<CR>"),
            }

            dashboard.section.footer.val = {
                center_line("", 107),
                center_line("SPC h — command palette  |  SPC s — settings  |  SPC ai — OpenCode", 107),
                center_line("Console IDE v0.1.0 — lightweight terminal IDE with AI  |  18 plugins loaded", 107),
            }

            dashboard.section.footer.opts.hl = "Comment"
            alpha.setup(dashboard.config)
        end,
    },

    -- File tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            vim.treesitter.language.register("lua", "lua")
            require("nvim-treesitter").setup({
                ensure_installed = { "lua", "python", "c", "cpp", "javascript", "typescript", "html", "css", "json", "bash", "tex", "bib" },
                highlight        = { enable = true },
                indent           = { enable = true },
            })
        end,
    },

    -- LaTeX + PDF support
    {
        "lervag/vimtex",
        lazy = false,
        config = function()
            vim.g.vimtex_view_method = "general"
            vim.g.vimtex_compiler_method = "latexmk"
            vim.g.vimtex_compiler_latexmk = {
                options = { "-pdf", "-shell-escape", "-interaction=nonstopmode", "-synctex=1" },
            }
        end,
    },

    -- (image.nvim skipped — not supported on Windows)

    -- Terminal
    {
        "akinsho/toggleterm.nvim",
        config = function()
            require("toggleterm").setup({
                direction = "horizontal",
                size = 10,
                shell = vim.fn.executable("pwsh") == 1 and "pwsh"
                    or vim.fn.executable("powershell") == 1 and "powershell"
                    or vim.fn.executable("bash") == 1 and "bash"
                    or vim.o.shell,
            })
        end,
    },

    -- Fuzzy finder
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("telescope").setup()
        end,
    },

    -- Keybind hints
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup()
        end,
    },

    -- LSP
    { "neovim/nvim-lspconfig" },

    -- Mason (LSP installer)
    { "williamboman/mason.nvim", config = function() require("mason").setup() end },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed    = { "pyright", "clangd", "lua_ls", "texlab" },
                automatic_installation = true,
            })
        end,
    },

    -- Autocomplete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = { expand = function(a) require("luasnip").lsp_expand(a.body) end },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"]     = cmp.mapping.select_next_item(),
                    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
                    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"]     = cmp.mapping.abort(),
                    ["<C-d>"]     = cmp.mapping.scroll_docs(4),
                    ["<C-u>"]     = cmp.mapping.scroll_docs(-4),
                }),
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip"  },
                    { name = "buffer"   },
                    { name = "path"     },
                },
            })
        end,
    },

    -- Formatter
    {
        "nvimtools/none-ls.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({ sources = { null_ls.builtins.formatting.stylua } })
        end,
    },

    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup({ options = { theme = "auto" } })
        end,
    },

    -- Indent lines
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function() require("ibl").setup() end,
    },

    -- Buffer tabs
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("bufferline").setup() end,
    },

    -- Git signs
    {
        "lewis6991/gitsigns.nvim",
        config = function() require("gitsigns").setup() end,
    },

    -- Lazygit
    {
        "kdheepak/lazygit.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            vim.g.lazygit_floating_window_use_plenary = 0
            vim.g.lazygit_use_neovim_remote = 0
        end,
    },

    -- Error lens (inline diagnostics)
    {
        "chikko80/error-lens.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
            require("error-lens").setup({
                enabled      = true,
                auto_adjust  = { enable = false },
                prefix       = 7,
            })
        end,
    },

    -- Auto pairs
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local ok, cmp = pcall(require, "cmp")
            if ok then cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done()) end
        end,
    },

    -- Comment toggling
    {
        "numToStr/Comment.nvim",
        config = function() require("Comment").setup() end,
    },

    -- Surround
    {
        "kylechui/nvim-surround",
        config = function() require("nvim-surround").setup() end,
    },

    -- Smooth scrolling
    {
        "karb94/neoscroll.nvim",
        config = function() require("neoscroll").setup() end,
    },
})

-- ── Leader ───────────────────────────────────────────────────────────────
vim.g.mapleader = " "

vim.api.nvim_set_hl(0, "VDESelection", {
    reverse = true,
    bold = true,
})

-- ══════════════════════════════════════════════════════════════════════════
--  ABOUT PAGE
-- ══════════════════════════════════════════════════════════════════════════
function ShowAbout()
    local buf = vim.api.nvim_create_buf(false, true)
  local lines = {
    "",
    "  ╔═════════════════════════════════════════════════════════════════╗",
    "  ║                        ABOUT THE DEVELOPER                      ║",
    "  ╚═════════════════════════════════════════════════════════════════╝",
    "",
    "  ┌─ Identity ──────────────────────────────────────────────────────┐",
    "  │                                                                 │",
    "  │   Name     :  Kesava D Raj                                      │",
    "  │   Handle   :  @devkesav                                         │",
    "  │   Degree   :  B.E - Electrical & Electronics Engineering        │",
    "  │   College  :  KPRIET  (2024 - 2028)                             │",
    "  │   Year     :  Second Year                                       │",
    "  │                                                                 │",
    "  └─────────────────────────────────────────────────────────────────┘",
    "",
    "  ┌─ Why I Built This ─────────────────────────────────────────────┐",
    "  │                                                                │",
    "  │   I live in the terminal. Not because it's trendy — because    │",
    "  │   it's where I think clearly and move fast.                    │",
    "  │                                                                │",
    "  │   I don't want fancy themes, icon packs, or splash screens.    │",
    "  │   I want my editor to get out of my way and let me code.       │",
    "  │                                                                │",
    "  │   Most Neovim configs felt like they were built to impress     │",
    "  │   on Reddit. Console IDE was built to actually be used —       │",
    "  │   every day, for real work, by someone who just wants to       │",
    "  │   open a file and start writing.                               │",
    "  │                                                                │",
    "  └────────────────────────────────────────────────────────────────┘",
    "",
    "  ┌─ About Console IDE ────────────────────────────────────────────┐",
    "  │                                                                │",
    "  │   Console IDE is a Neovim config built for developers who      │",
    "  │   are tired of bloated editors but still need a real setup.    │",
    "  │                                                                │",
    "  │   It gives you VSCode-level usability — fuzzy search, AI       │",
    "  │   coding via OpenCode, sane keybinds — without the GUI         │",
    "  │   overhead. Everything runs in your terminal, as it should.    │",
    "  │                                                                │",
    "  │   No mouse. No distractions. Just you and your codebase.       │",
    "  │                                                                │",
    "  │   v0.1.0 — live search palette, mode-locked keybind tabs,        │",
    "  │   VSCode keybind mode, cursor-light theme, 60+ vim commands.   │",
    "  │                                                                │",
    "  └────────────────────────────────────────────────────────────────┘",
    "",
    "  ┌─ Connect ──────────────────────────────────────────────────────┐",
    "  │                                                                │",
    "  │   GitHub    :  github.com/devkesav                             │",
    "  │   LinkedIn  :  linkedin.com/in/devkesav                        │",
    "  │   Instagram :  instagram.com/kesava_d_raj                      │",
    "  │                                                                │",
    "  └────────────────────────────────────────────────────────────────┘",
    "",
    "                      Press q to close",
    "",
}
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].buftype = "nofile"
    local width  = 72
    local height = #lines
    vim.api.nvim_open_win(buf, true, {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = math.floor((vim.o.lines - height) / 2),
        col       = math.floor((vim.o.columns - width) / 2),
        style     = "minimal",
        border    = "rounded",
        title     = "  Vim D IDE — About  ",
        title_pos = "center",
    })
    vim.api.nvim_buf_set_keymap(buf, "n", "q",     ":close<CR>", { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", { noremap = true, silent = true })
end

-- ══════════════════════════════════════════════════════════════════════════
--  COMMAND PALETTE  (SPC h)
-- ══════════════════════════════════════════════════════════════════════════
local prio_label = { [1] = "★★★", [2] = "★★ ", [3] = "★  " }

local keybinds_vim = {
    { "File & Search", "SPC ff",    "Find File (Telescope)",           1 },
    { "File & Search", "SPC fg",    "Live Grep across files",          1 },
    { "File & Search", "SPC fb",    "Switch Buffers",                  1 },
    { "Editor",        "SPC e",     "Toggle File Tree",                1 },
    { "Editor",        "SPC t",     "Toggle Terminal",                 1 },
    { "Editor",        "SPC ai",    "Open OpenCode AI",                1 },
    { "Editor",        "SPC g",     "Open Lazygit",                    1 },
    { "Editor",        "SPC pv",    "View compiled PDF",               2 },
    { "Editor",        "SPC fi",    "Submit feedback (GitHub Issues)", 2 },
    { "Editor",        "SPC s",     "Open Settings",                   1 },
    { "Editor",        "SPC uc",    "Customize theme, font & icons",    2 },
    { "Editor",        "SPC h",     "Open Command Palette",            1 },
    { "Navigation",    "Tab",       "Next Buffer",                     1 },
    { "Navigation",    "S-Tab",     "Previous Buffer",                 1 },
    { "Navigation",    "Alt h",     "Move to Left Panel",              2 },
    { "Navigation",    "Alt l",     "Move to Right Panel",             2 },
    { "Navigation",    "Ctrl d",    "Half page down (centered)",       2 },
    { "Navigation",    "Ctrl u",    "Half page up (centered)",         2 },
    { "Editing",       "u",         "Undo",                            1 },
    { "Editing",       "Ctrl r",    "Redo",                            1 },
    { "Editing",       "gcc",       "Toggle comment (line)",           1 },
    { "Editing",       "gc",        "Toggle comment (visual)",         1 },
    { "Editing",       "ys{m}{c}",  "Surround motion with char",       2 },
    { "Editing",       "cs{o}{n}",  "Change surrounding char",         2 },
    { "Editing",       "ds{c}",     "Delete surrounding char",         2 },
    { "LSP",           "Tab",       "Next completion item",            1 },
    { "LSP",           "S-Tab",     "Prev completion item",            1 },
    { "LSP",           "CR",        "Confirm completion",              1 },
    { "LSP",           "C-Space",   "Trigger completion",              2 },
    { "LSP",           "gd",        "Go to definition",                1 },
    { "LSP",           "gr",        "Go to references",                1 },
    { "LSP",           "K",         "Hover documentation",             1 },
    { "LSP",           "SPC rn",    "Rename symbol",                   2 },
    { "LSP",           "SPC ca",    "Code action",                     2 },
    { "LSP",           "SPC lf",    "Format file (LSP)",               2 },
    { "LSP",           "[d",        "Prev diagnostic",                 2 },
    { "LSP",           "]d",        "Next diagnostic",                 2 },
}

local keybinds_vscode = {
    { "File & Search", "Ctrl p",    "Find File (Telescope)",           1 },
    { "File & Search", "Ctrl g",    "Live Grep across files",          1 },
    { "File & Search", "Ctrl b",    "Toggle File Tree",                1 },
    { "Editor",        "Ctrl `",    "Toggle Terminal",                 1 },
    { "Editor",        "SPC ai",    "Open OpenCode AI",                1 },
    { "Editor",        "Ctrl ,",    "Open Settings",                   1 },
    { "Editor",        "SPC fi",    "Submit feedback (GitHub Issues)", 2 },
    { "Editor",        "SPC uc",    "Customize theme, font & icons",    2 },
    { "Editor",        "SPC g",     "Open Lazygit",                    1 },
    { "Navigation",    "Ctrl Tab",  "Next Buffer",                     1 },
    { "Navigation",    "Ctrl S-Tab","Previous Buffer",                 1 },
    { "Navigation",    "Alt h",     "Move to Left Panel",              2 },
    { "Navigation",    "Alt l",     "Move to Right Panel",             2 },
    { "Editing",       "Ctrl z",    "Undo",                            1 },
    { "Editing",       "Ctrl y",    "Redo",                            1 },
    { "Editing",       "Ctrl /",    "Toggle comment",                  1 },
    { "Editing",       "Ctrl c",    "Copy",                            1 },
    { "Editing",       "Ctrl x",    "Cut",                             1 },
    { "Editing",       "Ctrl v",    "Paste",                           1 },
    { "Editing",       "Ctrl s",    "Save file",                       1 },
    { "Editing",       "Ctrl a",    "Select all",                      1 },
    { "Editing",       "Ctrl f",    "Find in file",                    1 },
    { "Editing",       "Ctrl h",    "Find & Replace",                  1 },
    { "Editing",       "Ctrl d",    "Multi-cursor next match",         2 },
    { "Editing",       "Alt Up",    "Move line up",                    2 },
    { "Editing",       "Alt Down",  "Move line down",                  2 },
    { "Editing",       "S-Alt Up",  "Duplicate line up",               2 },
    { "Editing",       "S-Alt Down","Duplicate line down",             2 },
    { "LSP",           "Tab",       "Next completion item",            1 },
    { "LSP",           "CR",        "Confirm completion",              1 },
    { "LSP",           "F12",       "Go to definition",                1 },
    { "LSP",           "S-F12",     "Go to references",                1 },
    { "LSP",           "K",         "Hover documentation",             1 },
    { "LSP",           "F2",        "Rename symbol",                   2 },
    { "LSP",           "Ctrl .",    "Code action",                     2 },
    { "LSP",           "S-Alt F",   "Format file",                     2 },
}

local vim_commands = {
    { "Saving & Quitting", ":w",           "Save file",                       ":w<CR>"        },
    { "Saving & Quitting", ":W",           "Force save (sudo trick)",          ":w !sudo tee %<CR>" },
    { "Saving & Quitting", ":q",           "Quit",                            ":q<CR>"        },
    { "Saving & Quitting", ":wq / :x",     "Save and quit",                   ":wq<CR>"       },
    { "Saving & Quitting", ":q!",          "Force quit (discard changes)",    ":q!<CR>"       },
    { "Saving & Quitting", ":wqa",         "Save and quit all buffers",       ":wqa<CR>"      },
    { "Saving & Quitting", ":qa!",         "Force quit all (no save)",        ":qa!<CR>"      },
    { "Modes",             "i",            "Enter Insert (before cursor)",    "i"             },
    { "Modes",             "a",            "Enter Insert (after cursor)",     "a"             },
    { "Modes",             "I",            "Insert at line start",            "I"             },
    { "Modes",             "A",            "Insert at line end",              "A"             },
    { "Modes",             "o",            "New line below, Insert",          "o"             },
    { "Modes",             "O",            "New line above, Insert",          "O"             },
    { "Modes",             "v",            "Visual mode (char)",              "v"             },
    { "Modes",             "V",            "Visual Line mode",                "V"             },
    { "Modes",             "Ctrl v",       "Visual Block mode",               "<C-v>"         },
    { "Modes",             "<Esc>",        "Return to Normal mode",           "<Esc>"         },
    { "Modes",             "R",            "Replace mode",                    "R"             },
    { "Cursor Motion",     "h j k l",      "Move left/down/up/right",         "h"             },
    { "Cursor Motion",     "gg",           "Go to first line",                "gg"            },
    { "Cursor Motion",     "G",            "Go to last line",                 "G"             },
    { "Cursor Motion",     ":<n>",         "Go to line number n",             ":"             },
    { "Cursor Motion",     "0",            "Go to line start (col 0)",        "0"             },
    { "Cursor Motion",     "^",            "Go to first non-blank char",      "^"             },
    { "Cursor Motion",     "$",            "Go to line end",                  "$"             },
    { "Cursor Motion",     "w / W",        "Next word / WORD start",          "w"             },
    { "Cursor Motion",     "b / B",        "Prev word / WORD start",          "b"             },
    { "Cursor Motion",     "e / E",        "Next word / WORD end",            "e"             },
    { "Cursor Motion",     "ge",           "Prev word end",                   "ge"            },
    { "Cursor Motion",     "%",            "Jump to matching bracket",        "%"             },
    { "Cursor Motion",     "{ / }",        "Prev / next blank-line paragraph","{"             },
    { "Cursor Motion",     "Ctrl f/b",     "Page down / up",                  "<C-f>"         },
    { "Cursor Motion",     "Ctrl d/u",     "Half page down / up",             "<C-d>"         },
    { "Cursor Motion",     "H / M / L",    "Screen top / middle / bottom",    "H"             },
    { "Cursor Motion",     "zz / zt / zb", "Center / top / bottom cursor",    "zz"            },
    { "Cursor Motion",     "f{c}",         "Jump forward to char c",          "f"             },
    { "Cursor Motion",     "F{c}",         "Jump backward to char c",         "F"             },
    { "Cursor Motion",     "t{c} / T{c}",  "Jump before/after char c",        "t"             },
    { "Cursor Motion",     "; / ,",        "Repeat f/F/t/T forward/back",     ";"             },
    { "Cursor Motion",     "``",           "Jump back to last position",      "``"            },
    { "Cursor Motion",     "Ctrl o/i",     "Jump list: older / newer",        "<C-o>"         },
    { "Editing",           "dd",           "Delete (cut) line",               "dd"            },
    { "Editing",           "D",            "Delete to end of line",           "D"             },
    { "Editing",           "d{motion}",    "Delete by motion (dw, db...)",    "d"             },
    { "Editing",           "yy / Y",       "Yank (copy) line",                "yy"            },
    { "Editing",           "y{motion}",    "Yank by motion (yw, yb...)",      "y"             },
    { "Editing",           "p / P",        "Paste below / above cursor",      "p"             },
    { "Editing",           "x / X",        "Delete char forward / backward",  "x"             },
    { "Editing",           "r{c}",         "Replace char under cursor",       "r"             },
    { "Editing",           "~",            "Toggle case of char",             "~"             },
    { "Editing",           "u / U",        "Lower / upper case visual",       "u"             },
    { "Editing",           "ciw / caw",    "Change inner / around word",      "ciw"           },
    { "Editing",           "ci( / ca(",    "Change inner / around parens",    "ci("           },
    { "Editing",           "ci\" / ca\"",  "Change inner / around quotes",    "ci\""          },
    { "Editing",           "di{ / da{",    "Delete inner / around braces",    "di{"           },
    { "Editing",           ">> / <<",      "Indent / dedent line",            ">>"            },
    { "Editing",           ">% / <%",      "Indent / dedent to bracket",      ">%"            },
    { "Editing",           "J",            "Join line below to current",      "J"             },
    { "Editing",           "gJ",           "Join lines (no space)",           "gJ"            },
    { "Editing",           "Ctrl a/x",     "Increment / decrement number",    "<C-a>"         },
    { "Editing",           ".",            "Repeat last change",              "."             },
    { "Editing",           "q{r} ... q",   "Record macro into register r",    "q"             },
    { "Editing",           "@{r}",         "Play macro from register r",      "@"             },
    { "Editing",           "@@",           "Replay last macro",               "@@"            },
    { "Visual",            "v then i/a",   "Inner / around text object",      "v"             },
    { "Visual",            "viw",          "Select inner word",               "viw"           },
    { "Visual",            "vip",          "Select inner paragraph",          "vip"           },
    { "Visual",            "vi( / va(",    "Select inner / around parens",    "vi("           },
    { "Visual",            "vi{ / va{",    "Select inner / around braces",    "vi{"           },
    { "Visual",            "vi[ / va[",    "Select inner / around brackets",  "vi["           },
    { "Visual",            "vi\" / va\"",  "Select inner / around quotes",    "vi\""          },
    { "Visual",            "vi` / va`",    "Select inner / around backticks", "vi`"           },
    { "Visual",            "gv",           "Reselect last visual area",       "gv"            },
    { "Visual",            "o",            "Move to other end of selection",  "o"             },
    { "Visual",            "U",            "Uppercase selection",             "U"             },
    { "Visual",            "u",            "Lowercase selection",             "u"             },
    { "Visual",            "~",            "Toggle case of selection",        "~"             },
    { "Visual",            "=",            "Auto-indent selection",           "="             },
    { "Visual",            "> / <",        "Indent / dedent selection",       ">"             },
    { "Grammar",           "[count][op][motion]", "Vim grammar: verb + noun", "" },
    { "Grammar",           "d w",          "Delete next word",                "dw"            },
    { "Grammar",           "d 3 w",        "Delete next 3 words",             "d3w"           },
    { "Grammar",           "c i w",        "Change inner word",               "ciw"           },
    { "Grammar",           "y i p",        "Yank inner paragraph",            "yip"           },
    { "Grammar",           "g u i w",      "Lowercase inner word",            "guiw"          },
    { "Grammar",           "g U i w",      "Uppercase inner word",            "gUiw"          },
    { "Grammar",           "g ~ i w",      "Toggle case inner word",          "g~iw"          },
    { "Grammar",           "> a {",        "Indent around braces",            ">a{"           },
    { "Grammar",           "= i (  ",      "Auto-indent inside parens",       "=i("           },
    { "Command-line",      ":",            "Enter command-line mode",         ":"             },
    { "Command-line",      "Ctrl r Ctrl w","Insert word under cursor in cmd", ""              },
    { "Command-line",      "Up / Down",    "Cycle command history",           ""              },
    { "Command-line",      "Ctrl f",       "Open command history window",     ""              },
    { "Command-line",      "Tab",          "Autocomplete in command-line",    ""              },
    { "Command-line",      ":earlier {t}", "Undo to earlier time  (:ea 1m)",  ":earlier "     },
    { "Command-line",      ":later {t}",   "Redo to later time    (:lat 1m)", ":later "       },
    { "Command-line",      ":set nu!",     "Toggle line numbers",             ":set nu!<CR>"  },
    { "Command-line",      ":set rnu!",    "Toggle relative numbers",         ":set rnu!<CR>" },
    { "Command-line",      ":set wrap!",   "Toggle word wrap",                ":set wrap!<CR>"},
    { "Command-line",      ":set spell!",  "Toggle spell check",              ":set spell!<CR>"},
    { "Command-line",      ":set ic!",     "Toggle case-insensitive search",  ":set ic!<CR>"  },
    { "Command-line",      ":set list!",   "Toggle show whitespace chars",    ":set list!<CR>"},
    { "Command-line",      ":scriptnames", "List all loaded scripts",         ":scriptnames<CR>"},
    { "Command-line",      ":messages",    "Show recent Vim messages",        ":messages<CR>" },
    { "Command-line",      ":noa w",       "Save without triggering autocmds",":noa w<CR>"    },
    { "Diff & Quickfix",   ":copen",       "Open quickfix list",              ":copen<CR>"    },
    { "Diff & Quickfix",   ":cclose",      "Close quickfix list",             ":cclose<CR>"   },
    { "Diff & Quickfix",   ":cn / :cp",    "Next / prev quickfix item",       ":cn<CR>"       },
    { "Diff & Quickfix",   ":lopen",       "Open location list",              ":lopen<CR>"    },
    { "Diff & Quickfix",   ":lclose",      "Close location list",             ":lclose<CR>"   },
    { "Diff & Quickfix",   ":ln / :lp",    "Next / prev location item",       ":lnext<CR>"    },
    { "Diff & Quickfix",   ":diffsplit f", "Diff current file with f",        ":diffsplit "   },
    { "Diff & Quickfix",   "do / dp",      "Diff obtain / put (in diff mode)","do"            },
    { "Diff & Quickfix",   "]c / [c",      "Next / prev diff chunk",          "]c"            },
    { "Diff & Quickfix",   ":diffupdate",  "Refresh diff highlighting",       ":diffupdate<CR>"},
    { "Search",            "/pat",         "Search forward for pattern",      "/"             },
    { "Search",            "?pat",         "Search backward for pattern",     "?"             },
    { "Search",            "n / N",        "Next / prev search match",        "n"             },
    { "Search",            "*",            "Search word under cursor fwd",    "*"             },
    { "Search",            "#",            "Search word under cursor bwd",    "#"             },
    { "Search",            ":noh",         "Clear search highlight",          ":noh<CR>"      },
    { "Search",            ":%s/a/b/g",    "Replace all in file",             ":%s/"          },
    { "Search",            ":%s/a/b/gc",   "Replace all (confirm each)",      ":%s/"          },
    { "Search",            ":s/a/b/g",     "Replace all in current line",     ":s/"           },
    { "Search",            "'<,'>s/a/b/g", "Replace in visual selection",     ":'<,'>s/"      },
    { "Search",            ":g/pat/d",     "Delete all lines matching pat",   ":g/"           },
    { "Search",            ":g/pat/norm",  "Run normal cmd on matched lines", ":g/"           },
    { "Windows",           ":sp / Ctrl ws","Split horizontally",              ":sp<CR>"       },
    { "Windows",           ":vsp / Ctrl wv","Split vertically",               ":vsp<CR>"      },
    { "Windows",           "Ctrl w hjkl",  "Navigate between splits",         "<C-w>h"        },
    { "Windows",           "Ctrl w =",     "Equalize split sizes",            "<C-w>="        },
    { "Windows",           "Ctrl w _",     "Maximize split height",           "<C-w>_"        },
    { "Windows",           "Ctrl w |",     "Maximize split width",            "<C-w>|"        },
    { "Windows",           ":resize +n",   "Increase split height by n",      ":resize +"     },
    { "Windows",           ":vert res +n", "Increase split width by n",       ":vert resize +" },
    { "Windows",           ":bd",          "Close current buffer",            ":bd<CR>"       },
    { "Windows",           ":bw",          "Wipe buffer (close + remove)",    ":bw<CR>"       },
    { "Windows",           ":e file",      "Open / edit a file",              ":e "           },
    { "Windows",           ":ls / :buffers","List open buffers",              ":ls<CR>"       },
    { "Windows",           ":bnext / :bp", "Next / prev buffer",              ":bnext<CR>"    },
    { "Windows",           ":tabnew",      "Open new tab",                    ":tabnew<CR>"   },
    { "Windows",           ":tabn / :tabp","Next / prev tab",                 ":tabn<CR>"     },
    { "Windows",           ":tabclose",    "Close current tab",               ":tabclose<CR>" },
    { "Folds",             "za",           "Toggle fold under cursor",        "za"            },
    { "Folds",             "zo / zc",      "Open / close fold",               "zo"            },
    { "Folds",             "zR / zM",      "Open all / close all folds",      "zR"            },
    { "Folds",             "zf{motion}",   "Create fold over motion",         "zf"            },
    { "Registers",         ":reg",         "Show all registers",              ":reg<CR>"      },
    { "Registers",         "\"{r}y",       "Yank into named register r",      "\""            },
    { "Registers",         "\"{r}p",       "Paste from named register r",     "\""            },
    { "Registers",         "m{a}",         "Set mark a at cursor",            "m"             },
    { "Registers",         "'{a}",         "Jump to mark a (line)",           "'"             },
    { "Registers",         "`{a}",         "Jump to mark a (exact pos)",      "`"             },
    { "Registers",         ":marks",       "List all marks",                  ":marks<CR>"    },
    { "Misc",              ":sort",        "Sort selected lines",             ":sort<CR>"     },
    { "Misc",              ":sort!",       "Sort lines (reverse)",            ":sort!<CR>"    },
    { "Misc",              "Ctrl l",       "Redraw screen",                   "<C-l>"         },
    { "Misc",              ":set paste",   "Toggle paste mode (raw input)",   ":set paste<CR>" },
    { "Misc",              "ga",           "Show ASCII / Unicode of char",    "ga"            },
    { "Misc",              ":!{cmd}",      "Run shell command",               ":!"            },
    { "Misc",              ":.!{cmd}",     "Replace line with cmd output",    ":.!"           },
    { "Misc",              ":read !{cmd}", "Insert cmd output below line",    ":read !"       },
}

-- ── Active keybind table ──────────────────────────────────────────────────
local function active_keybinds()
    return DD.keybind_mode == "vscode" and keybinds_vscode or keybinds_vim
end

-- ══════════════════════════════════════════════════════════════════════════
--  COMMAND PALETTE  (SPC h)
-- ══════════════════════════════════════════════════════════════════════════
function OpenCommandPalette()
    -- cp_mode: "keys" | "vim"
    local cp_mode     = "keys"
    local cp_query    = ""
    local cp_cursor   = 4
    local search_mode = false
    local _on_key_ns  = nil

    -- ── helpers ──────────────────────────────────────────────────────────
    local function keybind_tab_label()
        return DD.keybind_mode == "vscode" and "Keybinds (VSCode)" or "Keybinds (Vim)"
    end

    local function build_lines(m, q)
        local lines = {}
        local meta  = {}
        local function add(line, action)
            table.insert(lines, line)
            table.insert(meta, action)
        end
        local function sep(t)  add(string.format("  ─── %s ", t), nil) end
        local function blank() add("", nil) end

        -- header bar
        blank()
        local tk = (m == "keys") and ("[ " .. keybind_tab_label() .. " ]")
                                  or ("  " .. keybind_tab_label() .. "  ")
        local tv = (m == "vim")  and "[ Vim Cmds ]" or "  Vim Cmds  "
        local search_bar
        if search_mode then
            search_bar = string.format("  /  %s█", cp_query)
        elseif cp_query ~= "" then
            search_bar = string.format("  /  %s  (ESC clears)", cp_query)
        else
            search_bar = "  /  type to search"
        end
        add(string.format("  %s   %s      Tab switch   q quit", tk, tv), nil)
        add(string.format("  %s", search_bar), nil)
        blank()

        -- results
        if m == "keys" then
            local cat = ""
            for _, cmd in ipairs(active_keybinds()) do
                local key_lc  = cmd[2]:lower()
                local desc_lc = cmd[3]:lower()
                local cat_lc  = cmd[1]:lower()
                if q == "" or key_lc:find(q, 1, true)
                           or desc_lc:find(q, 1, true)
                           or cat_lc:find(q, 1, true) then
                    if cmd[1] ~= cat then cat = cmd[1]; sep(cat) end
                    add(string.format("  %-16s  %-38s  %s",
                            cmd[2], cmd[3], prio_label[cmd[4]]),
                        { kind = "key", entry = cmd })
                end
            end
        else
            local cat = ""
            for _, cmd in ipairs(vim_commands) do
                local key_lc  = cmd[2]:lower()
                local desc_lc = cmd[3]:lower()
                local cat_lc  = cmd[1]:lower()
                if q == "" or key_lc:find(q, 1, true)
                           or desc_lc:find(q, 1, true)
                           or cat_lc:find(q, 1, true) then
                    if cmd[1] ~= cat then cat = cmd[1]; sep(cat) end
                    add(string.format("  %-20s  %-34s  ▶ run",
                            cmd[2], cmd[3]),
                        { kind = "vim", entry = cmd })
                end
            end
        end

        blank()
        return lines, meta
    end

    -- ── create floating window ────────────────────────────────────────────
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "vde_palette"

    local width  = 76
    local height = math.min(42, vim.o.lines - 4)
    local win    = vim.api.nvim_open_win(buf, true, {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = math.floor((vim.o.lines  - height) / 2),
        col       = math.floor((vim.o.columns - width)  / 2),
        style     = "minimal",
        border    = "rounded",
        title     = "  Console IDE — Command Palette  ",
        title_pos = "center",
    })

    local cur_meta = {}
    local _palette_ns = vim.api.nvim_create_namespace("vde_palette_hl")

    -- ── render ────────────────────────────────────────────────────────────
    local function render()
        local lines, meta = build_lines(cp_mode, cp_query)
        cur_meta = meta

        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.api.nvim_buf_clear_namespace(buf, _palette_ns, 0, -1)

        -- Header highlight
        vim.api.nvim_buf_add_highlight(buf, _palette_ns, "Title", 1, 0, -1)

        for i, m in ipairs(meta) do
            local row  = i - 1
            local line = lines[i] or ""
            if m == nil and line:find("───") then
                vim.api.nvim_buf_add_highlight(buf, _palette_ns, "Comment", row, 0, -1)
            elseif m ~= nil then
                if line:find("▶ run") then
                    vim.api.nvim_buf_add_highlight(buf, _palette_ns, "DiagnosticInfo", row, 0, -1)
                end
            end
        end

        -- Highlight selected row
        if cp_cursor >= 1 and cp_cursor <= #lines then
            vim.api.nvim_buf_add_highlight(buf, _palette_ns, "Visual", cp_cursor - 1, 0, -1)
        end

        vim.bo[buf].modifiable = false

        -- Clamp and sync cursor
        cp_cursor = math.max(1, math.min(cp_cursor, #lines))
        pcall(vim.api.nvim_win_set_cursor, win, { cp_cursor, 2 })
    end

    -- ── cleanup ───────────────────────────────────────────────────────────
    local function stop_search()
        if _on_key_ns then
            vim.on_key(nil, _on_key_ns)
            _on_key_ns = nil
        end
        search_mode = false
    end

    local function close_palette()
        stop_search()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    -- ── live search via vim.on_key ────────────────────────────────────────
    local function start_search()
        search_mode = true
        cp_query    = ""
        cp_cursor   = 4
        render()

        _on_key_ns = vim.api.nvim_create_namespace("vde_pal_search")
        vim.on_key(function(key)
            if not vim.api.nvim_win_is_valid(win) then
                stop_search(); return
            end
            if not search_mode then return end

            local k = vim.fn.keytrans(key)

            if k == "<Esc>" or k == "<CR>" then
                stop_search()
                render()
                return ""
            elseif k == "<BS>" or k == "<C-H>" then
                cp_query  = cp_query:sub(1, -2)
                cp_cursor = 4
                render()
                return ""
            elseif k == "<C-U>" then
                cp_query  = ""
                cp_cursor = 4
                render()
                return ""
            elseif #k == 1 then
                cp_query  = cp_query .. k:lower()
                cp_cursor = 4
                render()
                return ""
            end
        end, _on_key_ns)
    end

    -- ── normal-mode keybinds ──────────────────────────────────────────────
    local opts = { noremap = true, silent = true, nowait = true, buffer = buf }
    local function map(k, fn) vim.keymap.set("n", k, fn, opts) end

    map("q", function()
        if search_mode then
            stop_search(); render()
        else
            close_palette()
        end
    end)

    map("<Esc>", function()
        if search_mode then
            stop_search(); render()
        elseif cp_query ~= "" then
            cp_query = ""; cp_cursor = 4; render()
        else
            close_palette()
        end
    end)

    map("/", function()
        if not search_mode then start_search() end
    end)

    map("<CR>", function()
        if search_mode then stop_search(); render(); return end
        local m = cur_meta[cp_cursor]
        if not m then return end
        close_palette()
        if m.kind == "vim" then
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes(m.entry[4], true, false, true), "n", false)
        end
    end)

    map("<Tab>", function()
        stop_search()
        cp_mode   = (cp_mode == "keys") and "vim" or "keys"
        cp_cursor = 4; cp_query = ""; render()
    end)
    map("1", function() stop_search(); cp_mode = "keys"; cp_cursor = 4; cp_query = ""; render() end)
    map("2", function() stop_search(); cp_mode = "vim";  cp_cursor = 4; cp_query = ""; render() end)

    map("j", function()
        if search_mode then return end
        local total = vim.api.nvim_buf_line_count(buf)
        local r = cp_cursor + 1
        while r <= total do
            if cur_meta[r] ~= nil then break end
            r = r + 1
        end
        if r <= total then cp_cursor = r end
        pcall(vim.api.nvim_win_set_cursor, win, { cp_cursor, 2 })
        render()
    end)

    map("k", function()
        if search_mode then return end
        local r = cp_cursor - 1
        while r >= 1 do
            if cur_meta[r] ~= nil then break end
            r = r - 1
        end
        if r >= 1 then cp_cursor = r end
        pcall(vim.api.nvim_win_set_cursor, win, { cp_cursor, 2 })
        render()
    end)

    map("<Down>", function()
        if search_mode then return end
        local total = vim.api.nvim_buf_line_count(buf)
        local r = cp_cursor + 1
        while r <= total do
            if cur_meta[r] ~= nil then break end
            r = r + 1
        end
        if r <= total then cp_cursor = r end
        pcall(vim.api.nvim_win_set_cursor, win, { cp_cursor, 2 })
        render()
    end)

    map("<Up>", function()
        if search_mode then return end
        local r = cp_cursor - 1
        while r >= 1 do
            if cur_meta[r] ~= nil then break end
            r = r - 1
        end
        if r >= 1 then cp_cursor = r end
        pcall(vim.api.nvim_win_set_cursor, win, { cp_cursor, 2 })
        render()
    end)

    vim.api.nvim_create_autocmd("WinClosed", {
        pattern  = tostring(win),
        once     = true,
        callback = function() stop_search() end,
    })

    render()
end

-- ══════════════════════════════════════════════════════════════════════════
--  KEYBIND MODE APPLICATOR
-- ══════════════════════════════════════════════════════════════════════════
local _active_extra_maps = {}

local function clear_extra_maps()
    for _, v in ipairs(_active_extra_maps) do
        pcall(vim.keymap.del, v[1], v[2])
    end
    _active_extra_maps = {}
end

local function set_extra(mode, lhs, rhs, desc)
    for _, v in ipairs(_active_extra_maps) do
        if v[1] == mode and v[2] == lhs then return end
    end
    pcall(vim.keymap.set, mode, lhs, rhs, { silent = true, desc = desc })
    table.insert(_active_extra_maps, { mode, lhs })
end

local function apply_keybind_mode(m)
    clear_extra_maps()
    if m == "vscode" then
        set_extra("n", "<C-p>",     ":Telescope find_files<CR>",  "Find File")
        set_extra("n", "<C-b>",     ":NvimTreeToggle<CR>",        "Toggle Tree")
        set_extra("n", "<C-`>",     ":ToggleTerm<CR>",            "Toggle Terminal")
        set_extra("n", "<C-s>",     ":silent! write<CR>",         "Save")
        set_extra("i", "<C-s>",     "<Esc>:silent! write<CR>a",   "Save from insert")
        set_extra("n", "<C-z>",     "u",                          "Undo")
        set_extra("n", "<C-y>",     "<C-r>",                      "Redo")
        set_extra("n", "<C-/>",     "gcc",                        "Toggle comment")
        set_extra("v", "<C-/>",     "gc",                         "Toggle comment (visual)")
        set_extra("n", "<C-a>",     "ggVG",                       "Select all")
        set_extra("n", "<C-f>",     "/",                          "Find")
        set_extra("n", "<A-Up>",    ":m .-2<CR>==",               "Move line up")
        set_extra("n", "<A-Down>",  ":m .+1<CR>==",               "Move line down")
        set_extra("v", "<A-Up>",    ":m '<-2<CR>gv=gv",           "Move selection up")
        set_extra("v", "<A-Down>",  ":m '>+1<CR>gv=gv",          "Move selection down")
        set_extra("n", "<S-A-Up>",  "yyP",                        "Duplicate line up")
        set_extra("n", "<S-A-Down>","yyp",                        "Duplicate line down")
        set_extra("n", "<F12>",     vim.lsp.buf.definition,       "Go to definition")
        set_extra("n", "<S-F12>",   vim.lsp.buf.references,       "Go to references")
        set_extra("n", "<F2>",      vim.lsp.buf.rename,           "Rename symbol")
        set_extra("n", "<C-.>",     vim.lsp.buf.code_action,      "Code action")
        set_extra("n", "K",          vim.lsp.buf.hover,            "Hover docs")
        set_extra("n", "<leader>fi", ":Feedback<CR>",              "GitHub Issues feedback")
        set_extra("n", "<leader>uc", ":Customize<CR>",            "Customize theme, font & icons")
        set_extra("n", "<S-A-f>",   function()
            pcall(vim.lsp.buf.format, { async = true })
        end, "Format file")
    else
        set_extra("n", "gd",         vim.lsp.buf.definition,       "Go to definition")
        set_extra("n", "gr",         vim.lsp.buf.references,       "Go to references")
        set_extra("n", "K",          vim.lsp.buf.hover,            "Hover docs")
        set_extra("n", "<leader>rn", vim.lsp.buf.rename,           "Rename symbol")
        set_extra("n", "<leader>ca", vim.lsp.buf.code_action,      "Code action")
        set_extra("n", "<leader>lf", function()
            pcall(vim.lsp.buf.format, { async = true })
        end, "Format file (LSP)")
        set_extra("n", "[d",         vim.diagnostic.goto_prev,     "Prev diagnostic")
        set_extra("n", "]d",         vim.diagnostic.goto_next,     "Next diagnostic")
        set_extra("n", "<C-d>",      "<C-d>zz",                    "Half page down (centered)")
        set_extra("n", "<C-u>",      "<C-u>zz",                    "Half page up (centered)")
        set_extra("n", "n",          "nzzzv",                      "Next match centered")
        set_extra("n", "N",          "Nzzzv",                      "Prev match centered")
    end
end

-- ══════════════════════════════════════════════════════════════════════════
--  SETTINGS COMMANDS  (replace GUI)
-- ══════════════════════════════════════════════════════════════════════════

local function bool_str(v) return v and "ON" or "OFF" end

local function apply_theme(t)
    if t == "dark" then
        local ok, cd = pcall(require, "cursor-dark")
        if ok then
            cd.setup({ style = "dark" })
            vim.cmd.colorscheme("cursor-dark")
        end
    elseif t == "light" then
        local ok = pcall(vim.cmd.colorscheme, "catppuccin-latte")
        if not ok then
            pcall(vim.cmd.colorscheme, "catppuccin")
            vim.g.catppuccin_flavour = "latte"
        end
    elseif t == "mocha" then
        local ok = pcall(vim.cmd.colorscheme, "catppuccin-mocha")
        if not ok then
            pcall(vim.cmd.colorscheme, "catppuccin")
            vim.g.catppuccin_flavour = "mocha"
        end
    end
end

local function apply_error_lens(v)
    local ok, el = pcall(require, "error-lens")
    if ok then el.setup({ enabled = v, auto_adjust = { enable = false }, prefix = 7 }) end
end

vim.lsp.config.lua_ls = {
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
}

local function apply_lsp(v)
    local servers = {}
    if DD.pyright then table.insert(servers, "pyright") end
    if DD.clangd  then table.insert(servers, "clangd")  end
    if DD.lua_ls  then table.insert(servers, "lua_ls")  end
    if DD.texlab  then table.insert(servers, "texlab")  end
    if v and #servers > 0 then
        vim.lsp.enable(servers)
    elseif not v or #servers == 0 then
        for _, c in ipairs(vim.lsp.get_clients()) do
            if vim.tbl_contains(servers, c.name) or #servers == 0 then
                c.stop()
            end
        end
    end
end

local _autosave_au = nil
local function apply_autosave(v)
    if _autosave_au then
        pcall(vim.api.nvim_del_autocmd, _autosave_au)
        _autosave_au = nil
    end
    if v then
        _autosave_au = vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave" }, {
            callback = function()
                if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
                    vim.cmd("silent! write")
                end
            end,
        })
    end
end

-- Helper: apply a boolean toggle + call apply_fn
local function toggle_option(key, apply_fn)
    DD[key] = not DD[key]
    if apply_fn then apply_fn(DD[key]) end
end

local toggle_cmds = {
    linenr     = { desc = "Line numbers",       fn = function(v) vim.opt.number = v end },
    relativenr = { desc = "Relative numbers",    fn = function(v) vim.opt.relativenumber = v end },
    wordwrap   = { desc = "Word wrap",           fn = function(v) vim.opt.wrap = v end },
    ibl        = { desc = "Indent guides",       fn = function(v) pcall(vim.cmd, v and "IBLEnable" or "IBLDisable") end },
    bufferline = { desc = "Buffer tab bar",      fn = function(v) vim.opt.showtabline = v and 2 or 0 end },
    lualine    = { desc = "Status line",         fn = function(v) pcall(vim.cmd, v and "LualineEnable" or "LualineDisable") end },
    autosave   = { desc = "Auto save",           fn = function(v) apply_autosave(v) end },
    error_lens = { desc = "Error lens",          fn = function(v) apply_error_lens(v) end },
    diag_live  = { desc = "Live diagnostics",    fn = function(v) vim.diagnostic.config({ update_in_insert = v }) end },
    highlight_yank = { desc = "Yank flash",      fn = nil },
    gitsigns   = { desc = "Git signs",           fn = function(v) pcall(require("gitsigns").toggle_signs) end },
    autoread   = { desc = "Live reload",         fn = function(v) vim.o.autoread = v end },
    lsp_enabled = { desc = "LSP engine",         fn = function(v) apply_lsp(v) end },
    pyright    = { desc = "Pyright",             fn = function(v) if DD.lsp_enabled then apply_lsp(true) end end },
    clangd     = { desc = "Clangd",              fn = function(v) if DD.lsp_enabled then apply_lsp(true) end end },
    lua_ls     = { desc = "Lua language server", fn = function(v) if DD.lsp_enabled then apply_lsp(true) end end },
    texlab     = { desc = "TexLab (LaTeX)",      fn = function(v) if DD.lsp_enabled then apply_lsp(true) end end },
    nvim_cmp   = { desc = "nvim-cmp",            fn = nil },
    luasnip    = { desc = "LuaSnip",             fn = nil },
    stylua     = { desc = "Stylua formatter",    fn = nil },
    opencode   = { desc = "OpenCode panel",      fn = nil },
    treesitter = { desc = "Treesitter",          fn = function(v)
        for _, b in ipairs(vim.api.nvim_list_bufs()) do
            pcall(v and vim.treesitter.start or vim.treesitter.stop, b)
        end
    end },
    whichkey   = { desc = "Which-key hints",     fn = nil },
}

vim.api.nvim_create_user_command("SettingsStatus", function()
    local items = {
        { desc = "Line numbers",         key = "linenr",         type = "toggle", cmd = ":ToggleLinenr",         usage = "Toggle line numbers ON/OFF" },
        { desc = "Relative numbers",     key = "relativenr",    type = "toggle", cmd = ":ToggleRelativenr",     usage = "Toggle relative line numbers ON/OFF" },
        { desc = "Word wrap",            key = "wordwrap",      type = "toggle", cmd = ":ToggleWordwrap",       usage = "Toggle word wrapping ON/OFF" },
        { desc = "Indent guides",        key = "ibl",           type = "toggle", cmd = ":ToggleIbl",            usage = "Toggle indent guide lines ON/OFF" },
        { desc = "Buffer tab bar",       key = "bufferline",    type = "toggle", cmd = ":ToggleBufferline",     usage = "Toggle buffer tab bar ON/OFF" },
        { desc = "Status line",          key = "lualine",       type = "toggle", cmd = ":ToggleLualine",        usage = "Toggle status line ON/OFF" },
        { desc = "Auto save",            key = "autosave",      type = "toggle", cmd = ":ToggleAutosave",       usage = "Toggle auto-save ON/OFF" },
        { desc = "Error lens",           key = "error_lens",    type = "toggle", cmd = ":ToggleError_lens",     usage = "Toggle error lens ON/OFF" },
        { desc = "Live diagnostics",     key = "diag_live",     type = "toggle", cmd = ":ToggleDiag_live",      usage = "Toggle live diagnostics ON/OFF" },
        { desc = "Yank flash",           key = "highlight_yank",type = "toggle", cmd = ":ToggleHighlight_yank", usage = "Toggle yank highlight ON/OFF" },
        { desc = "Git signs",            key = "gitsigns",      type = "toggle", cmd = ":ToggleGitsigns",       usage = "Toggle git sign indicators ON/OFF" },
        { desc = "Live reload",          key = "autoread",      type = "toggle", cmd = ":ToggleAutoread",       usage = "Toggle live file reload ON/OFF" },
        { desc = "LSP engine",           key = "lsp_enabled",   type = "toggle", cmd = ":ToggleLsp_enabled",    usage = "Toggle LSP engine ON/OFF" },
        { desc = "Pyright",              key = "pyright",       type = "toggle", cmd = ":TogglePyright",        usage = "Toggle Pyright LSP ON/OFF" },
        { desc = "Clangd",               key = "clangd",        type = "toggle", cmd = ":ToggleClangd",         usage = "Toggle clangd LSP ON/OFF" },
        { desc = "Lua language server",  key = "lua_ls",        type = "toggle", cmd = ":ToggleLua_ls",         usage = "Toggle Lua language server ON/OFF" },
        { desc = "TexLab (LaTeX)",       key = "texlab",        type = "toggle", cmd = ":ToggleTexlab",          usage = "Toggle TexLab LaTeX LSP ON/OFF" },
        { desc = "nvim-cmp",             key = "nvim_cmp",      type = "toggle", cmd = ":ToggleNvim_cmp",       usage = "Toggle nvim-cmp completion ON/OFF" },
        { desc = "LuaSnip",              key = "luasnip",       type = "toggle", cmd = ":ToggleLuasnip",        usage = "Toggle LuaSnip snippets ON/OFF" },
        { desc = "Stylua formatter",     key = "stylua",        type = "toggle", cmd = ":ToggleStylua",         usage = "Toggle Stylua formatter ON/OFF" },
        { desc = "OpenCode panel",       key = "opencode",      type = "toggle", cmd = ":ToggleOpencode",       usage = "Toggle OpenCode panel ON/OFF" },
        { desc = "Treesitter",           key = "treesitter",    type = "toggle", cmd = ":ToggleTreesitter",     usage = "Toggle Treesitter highlighting ON/OFF" },
        { desc = "Which-key hints",      key = "whichkey",      type = "toggle", cmd = ":ToggleWhichkey",       usage = "Toggle which-key hints ON/OFF" },
        { desc = "Tab width",            key = "tabwidth",      type = "setter", cmd = ":SetTabWidth {2-8}",     fn = function(v) local n = tonumber(v); if n and n >= 2 and n <= 8 then DD.tabwidth = n; vim.opt.tabstop = n; vim.opt.shiftwidth = n end end },
        { desc = "OC width",             key = "oc_width",      type = "setter", cmd = ":SetOCWidth {30-90}",    fn = function(v) local n = tonumber(v); if n and n >= 30 and n <= 90 then DD.oc_width = n end end },
        { desc = "Theme",                key = "theme",         type = "setter", cmd = ":SetTheme {dark|light|mocha}", cycle = { "dark", "light", "mocha" }, fn = function(v) DD.theme = v; apply_theme(v) end },
        { desc = "Keybind mode",         key = "keybind_mode",  type = "setter", cmd = ":SetKeybindMode {vim|vscode}", cycle = { "vim", "vscode" }, fn = function(v) DD.keybind_mode = v; apply_keybind_mode(v) end },
    }

    local function get_status(key)
        local v = DD[key]
        if type(v) == "boolean" then return bool_str(v) end
        return tostring(v)
    end

    local function render_lines()
        local lines = {
            "  Settings                                                    [q] close  |  <CR> toggle / usage",
            string.rep("━", 78),
            string.format("  %-23s %-7s %-33s %s", "Function", "Status", "Command", ""),
            string.rep("─", 78),
        }
        for _, item in ipairs(items) do
            local status = get_status(item.key)
            table.insert(lines, string.format("  %-23s %-7s %-33s [+]",
                item.desc, status, item.cmd))
        end
        table.insert(lines, string.rep("━", 78))
        return lines
    end

    vim.cmd("tabnew")
    local buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].modifiable = true
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, render_lines())
    vim.bo[buf].modifiable = false

    vim.keymap.set("n", "q", function()
        pcall(vim.cmd, "tabclose")
    end, { buffer = buf, nowait = true, desc = "Close settings tab" })

    vim.keymap.set("n", "<CR>", function()
        local ln = vim.fn.line(".")
        local idx = ln - 4
        if idx < 1 or idx > #items then return end
        local item = items[idx]

        if item.type == "toggle" then
            local tc = toggle_cmds[item.key]
            if tc then
                toggle_option(item.key, tc.fn)
            end
        elseif item.type == "setter" then
            if item.cycle then
                local cur = DD[item.key]
                local next_idx = 1
                for i, v in ipairs(item.cycle) do
                    if v == cur then next_idx = i % #item.cycle + 1; break end
                end
                item.fn(item.cycle[next_idx])
            else
                local val = vim.fn.input(item.desc .. ": ", DD[item.key])
                if val ~= "" then
                    local n = tonumber(val)
                    item.fn(n or val)
                else
                    return
                end
            end
        end
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, render_lines())
        vim.bo[buf].modifiable = false
    end, { buffer = buf, desc = "Toggle/cycle setting" })
end, {})

for key, cfg in pairs(toggle_cmds) do
    local k, c = key, cfg
    local cmd_name = "Toggle" .. k:gsub("_(.)", function(s) return s:upper() end):gsub("^.", string.upper)
    vim.api.nvim_create_user_command(cmd_name, function()
        toggle_option(k, c.fn)
        vim.api.nvim_echo({ { c.desc .. ": " .. bool_str(DD[k]), "None" } }, false, {})
    end, { desc = "Toggle " .. c.desc })
end

vim.api.nvim_create_user_command("SetTheme", function(opts)
    local t = opts.args
    if t ~= "dark" and t ~= "light" and t ~= "mocha" then
        vim.api.nvim_echo({ { "Usage: SetTheme {dark|light|mocha}", "ErrorMsg" } }, false, {})
        return
    end
    DD.theme = t
    apply_theme(t)
    vim.api.nvim_echo({ { "Theme: " .. t, "None" } }, false, {})
end, { nargs = 1, desc = "Set theme: dark, light, or mocha" })

vim.api.nvim_create_user_command("SetTabWidth", function(opts)
    local n = tonumber(opts.args)
    if not n or n < 2 or n > 8 then
        vim.api.nvim_echo({ { "Usage: SetTabWidth {2-8}", "ErrorMsg" } }, false, {})
        return
    end
    DD.tabwidth = n
    vim.opt.tabstop = n; vim.opt.shiftwidth = n
    vim.api.nvim_echo({ { "Tab width: " .. n, "None" } }, false, {})
end, { nargs = 1, desc = "Set tab/indent width (2-8)" })

vim.api.nvim_create_user_command("SetOCWidth", function(opts)
    local n = tonumber(opts.args)
    if not n or n < 30 or n > 90 then
        vim.api.nvim_echo({ { "Usage: SetOCWidth {30-90}", "ErrorMsg" } }, false, {})
        return
    end
    DD.oc_width = n
    vim.api.nvim_echo({ { "OpenCode panel width: " .. n, "None" } }, false, {})
end, { nargs = 1, desc = "Set OpenCode panel width (30-90)" })

vim.api.nvim_create_user_command("SetKeybindMode", function(opts)
    local m = opts.args
    if m ~= "vim" and m ~= "vscode" then
        vim.api.nvim_echo({ { "Usage: SetKeybindMode {vim|vscode}", "ErrorMsg" } }, false, {})
        return
    end
    DD.keybind_mode = m
    apply_keybind_mode(m)
    vim.api.nvim_echo({ { "Keybind mode: " .. m, "None" } }, false, {})
end, { nargs = 1, desc = "Set keybind mode: vim or vscode" })

vim.api.nvim_create_user_command("SetFont", function(opts)
    local font = opts.args
    if font == "" then
        vim.api.nvim_echo({ { "Current font: " .. vim.o.guifont, "None" } }, false, {})
        return
    end
    DD.guifont = font
    vim.opt.guifont = font
    vim.api.nvim_echo({ { "Font set to: " .. font, "None" } }, false, {})
    vim.cmd("redraw!")
end, { nargs = "?", desc = "Set GUI font (e.g. :SetFont JetBrainsMono NFM:h11)" })

local function check_nerd_font()
    local installed = {}
    local key = "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts"
    local fonts = vim.fn.system('powershell -c "Get-ItemProperty -Path ' .. key .. ' 2>$null | ForEach-Object { $_.PSObject.Properties | Where-Object { $_.Name -match \\\"(Nerd| NF[MP]? |^JetBrains.* NF\\\\)\\\" } } | ForEach-Object { $_.Name }"')
    for line in fonts:gmatch("[^\r\n]+") do
        if line ~= "" then table.insert(installed, line) end
    end
    return installed
end

vim.api.nvim_create_user_command("CheckNerdFont", function()
    local fonts = check_nerd_font()
    if #fonts == 0 then
        vim.api.nvim_echo({ { "No Nerd Font found. Run :Customize for install guide.", "WarningMsg" } }, false, {})
    else
        vim.api.nvim_echo({ { "Nerd Fonts installed: " .. table.concat(fonts, ", "), "None" } }, false, {})
    end
end, { desc = "Check if Nerd Fonts are installed" })

vim.api.nvim_create_user_command("Customize", function()
    local fonts = check_nerd_font()
    local has_nerd = #fonts > 0
    local lines = {
        "",
        "  ╔════════════════════════════════════════════════════════════╗",
        "  ║                  Customize Console IDE                    ║",
        "  ╚════════════════════════════════════════════════════════════╝",
        "",
        "  Theme        : " .. DD.theme,
        "  Font (GUI)   : " .. vim.o.guifont,
        "  Nerd Font    : " .. (has_nerd and "Installed" or "Not found"),
        "",
        "  ── Quick actions ──",
        "",
        "  [1]  Cycle Theme        (dark -> light -> mocha)",
        "  [2]  Set Font           (enter font name)",
        "  [3]  Open WT Settings   (Windows Terminal font config)",
        "  [4]  Recheck Nerd Font",
        "  [5]  Install Nerd Font  (winget)",
        "",
        "  Press number key to select, or q to close.",
        "",
    }
    if not has_nerd then
        table.insert(lines, 8, "  ⚠  Install Nerd Font for icons:")
        table.insert(lines, 9, "       Press [5] or run: winget install DEVCOM.JetBrainsMonoNerdFont")
        table.insert(lines, 10, "")
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

    local width = 62
    local height = #lines + 2
    local ui = vim.api.nvim_list_uis()[1]
    local row = math.floor(((ui and ui.height or 24) - height) / 2)
    local col = math.floor(((ui and ui.width or 80) - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = "rounded",
    })

    vim.api.nvim_win_set_option(win, "winhl", "NormalFloat:Normal")

    vim.keymap.set("n", "q", function()
        pcall(vim.api.nvim_win_close, win, true)
    end, { buffer = buf, nowait = true, silent = true })

    vim.keymap.set("n", "1", function()
        local t = DD.theme
        local themes = { "dark", "light", "mocha" }
        local next_idx = 1
        for i, v in ipairs(themes) do
            if v == t then next_idx = i % #themes + 1; break end
        end
        DD.theme = themes[next_idx]
        apply_theme(DD.theme)
        pcall(vim.api.nvim_win_close, win, true)
        vim.api.nvim_echo({ { "Theme: " .. DD.theme, "None" } }, false, {})
        vim.cmd("Customize")
    end, { buffer = buf, nowait = true, silent = true, desc = "Cycle theme" })

    vim.keymap.set("n", "2", function()
        pcall(vim.api.nvim_win_close, win, true)
        local font = vim.fn.input("Font name (e.g. JetBrainsMono NFM:h11): ", vim.o.guifont)
        if font ~= "" then
            DD.guifont = font
            vim.opt.guifont = font
            vim.cmd("redraw!")
            vim.api.nvim_echo({ { "Font: " .. font, "None" } }, false, {})
        end
        vim.cmd("Customize")
    end, { buffer = buf, nowait = true, silent = true, desc = "Set font" })

    vim.keymap.set("n", "3", function()
        pcall(vim.api.nvim_win_close, win, true)
        local wt = vim.fn.expand("$LOCALAPPDATA\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json")
        local wt_prev = vim.fn.expand("$LOCALAPPDATA\\Packages\\Microsoft.WindowsTerminalPreview_8wekyb3d8bbwe\\LocalState\\settings.json")
        if vim.fn.filereadable(wt) == 1 then
            vim.ui.open(wt)
        elseif vim.fn.filereadable(wt_prev) == 1 then
            vim.ui.open(wt_prev)
        else
            vim.api.nvim_echo({ { "Windows Terminal settings.json not found. Look in Terminal > Settings > Open JSON file.", "None" } }, false, {})
        end
        vim.api.nvim_echo({ { "Set font face to 'JetBrainsMono Nerd Font Mono' in Windows Terminal settings.", "None" } }, false, {})
    end, { buffer = buf, nowait = true, silent = true, desc = "Open WT settings" })

    vim.keymap.set("n", "4", function()
        pcall(vim.api.nvim_win_close, win, true)
        vim.cmd("Customize")
    end, { buffer = buf, nowait = true, silent = true, desc = "Recheck Nerd Font" })

    vim.keymap.set("n", "5", function()
        pcall(vim.api.nvim_win_close, win, true)
        vim.fn.system("winget install DEVCOM.JetBrainsMonoNerdFont --accept-source-agreements --accept-package-agreements")
        vim.api.nvim_echo({ { "Installed JetBrainsMono Nerd Font. Configure it in your terminal settings.", "None" } }, false, {})
    end, { buffer = buf, nowait = true, silent = true, desc = "Install Nerd Font" })
end, { desc = "Open customization panel for theme, font, and icons" })

-- ══════════════════════════════════════════════════════════════════════════
--  PDF VIEWER  (opens in system-default PDF viewer)
-- ══════════════════════════════════════════════════════════════════════════
vim.api.nvim_create_user_command("PdfView", function(opts)
    local pdf_file
    local arg = opts.args
    if arg ~= "" and vim.fn.filereadable(arg) == 1 then
        pdf_file = arg
    else
        local ext = vim.fn.expand("%:e"):lower()
        if ext == "pdf" then
            pdf_file = vim.fn.expand("%:p")
        else
            local dir = vim.fn.expand("%:p:h")
            local base = vim.fn.expand("%:t:r")
            for _, e in ipairs({ ".pdf", ".PDF" }) do
                local candidate = dir .. "/" .. base .. e
                if vim.fn.filereadable(candidate) == 1 then
                    pdf_file = candidate
                    break
                end
            end
            if not pdf_file then
                vim.api.nvim_echo({ { "PDF not found for: " .. vim.fn.expand("%"), "ErrorMsg" } }, false, {})
                return
            end
        end
    end
    vim.ui.open(vim.fn.fnamemodify(pdf_file, ":p"))
    vim.api.nvim_echo({ { "Opening: " .. vim.fn.fnamemodify(pdf_file, ":t"), "None" } }, false, {})
end, { nargs = "?", desc = "Open compiled PDF in system default viewer" })

-- ══════════════════════════════════════════════════════════════════════════
--  FEEDBACK  (opens GitHub Issues with system info pre-filled)
-- ══════════════════════════════════════════════════════════════════════════
local function urlencode(s)
    return s:gsub("([^%w%.%- ])", function(c)
        return ("%%%02X"):format(string.byte(c))
    end):gsub(" ", "+")
end

vim.api.nvim_create_user_command("Feedback", function()
    local nvim_ver = vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
    local os_name = vim.loop.os_uname().sysname
    local os_ver = vim.loop.os_uname().release
    local config_ver = "v0.1.0"

    local body = table.concat({
        "",
        "**Describe your feedback or issue**",
        "",
        "",
        "---",
        "**System info:**",
        "- Console IDE: " .. config_ver,
        "- Neovim: " .. nvim_ver,
        "- OS: " .. os_name .. " " .. os_ver,
        "- Shell: " .. (vim.o.shell or "unknown"),
        "",
    }, "\n")

    local url = "https://github.com/devkesav/Console-IDE-NeoVim-Theme-/issues/new?body=" .. urlencode(body)
    vim.ui.open(url)
    vim.api.nvim_echo({ { "Opening GitHub Issues page in browser...", "None" } }, false, {})
end, { desc = "Open GitHub Issues to submit feedback" })

-- ══════════════════════════════════════════════════════════════════════════
--  PDF GUARD  (show friendly message instead of raw binary)
-- ══════════════════════════════════════════════════════════════════════════
vim.api.nvim_create_autocmd("BufReadCmd", {
    pattern = { "*.pdf", "*.PDF" },
    callback = function()
        local lines = {
            "",
            "  ╔══════════════════════════════════════════════════════════════════╗",
            "  ║                     PDF Preview Not Available                   ║",
            "  ╚══════════════════════════════════════════════════════════════════╝",
            "",
            "  This file is a binary PDF and cannot be displayed in Neovim.",
            "",
            "  Press  <leader>pv  to open it in your system's default PDF viewer.",
            "  Or run  :PdfView",
            "  Press  q  or  <Esc>  to close this buffer.",
            "",
        }
        vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
        vim.bo.bufhidden = "wipe"
        vim.bo.modifiable = false
        vim.bo.filetype = "pdf"
        local buf = vim.api.nvim_get_current_buf()
        local close = function() pcall(vim.api.nvim_buf_delete, buf, { force = true }) end
        vim.keymap.set("n", "q", close, { buffer = buf, silent = true, nowait = true, desc = "Close PDF guard" })
        vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true, nowait = true, desc = "Close PDF guard" })
    end,
})

-- ══════════════════════════════════════════════════════════════════════════
--  CORE KEYBINDS  (always active regardless of mode)
-- ══════════════════════════════════════════════════════════════════════════
vim.keymap.set("n", "<leader>e",  ":NvimTreeToggle<CR>",            { silent = true })
vim.keymap.set("n", "<leader>t",  ":ToggleTerm<CR>",                { silent = true })
vim.keymap.set("n", "<C-e>",      ":NvimTreeToggle<CR>",            { silent = true })
vim.keymap.set("n", "<C-t>",      ":ToggleTerm<CR>",                { silent = true })

vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>",      { silent = true })
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>",       { silent = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>",         { silent = true })

vim.keymap.set("n", "<leader>s",  ":SettingsStatus<CR>",   { silent = true, desc = "Show settings status" })
vim.keymap.set("n", "<C-,>",      ":SettingsStatus<CR>",   { silent = true, desc = "Show settings status" })
vim.keymap.set("n", "<leader>h",  OpenCommandPalette,  { silent = true, desc = "Command palette" })
vim.keymap.set("n", "<leader>pv", ":PdfView<CR>",     { silent = true, desc = "View compiled PDF" })
vim.keymap.set("n", "<leader>fi", ":Feedback<CR>",    { silent = true, desc = "Submit feedback via GitHub Issues" })
vim.keymap.set("n", "<leader>uc", ":Customize<CR>",   { silent = true, desc = "Customize theme, font, and icons" })

vim.keymap.set("n", "<leader>g", function()
    require("toggleterm.terminal").Terminal:new({
        cmd       = "lazygit",
        direction = "tab",
        on_open   = function() vim.cmd("startinsert!") end,
        on_close  = function()
            if #vim.api.nvim_list_tabpages() > 1 then vim.cmd("tabclose") end
        end,
    }):toggle()
end, { silent = true, desc = "Open Lazygit" })

vim.keymap.set("n", "<Tab>",   ":BufferLineCycleNext<CR>", { silent = true })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { silent = true })

-- Clipboard
vim.keymap.set({ "n", "v" }, "<C-x>", '"+d',  { silent = true })
vim.keymap.set({ "n", "v" }, "<C-c>", '"+y',  { silent = true })
vim.keymap.set({ "n", "v" }, "<C-v>", '"+p',  { silent = true })
vim.keymap.set("n",           "<C-x>", '"+dd', { silent = true })
vim.keymap.set("n",           "<C-c>", '"+yy', { silent = true })

-- Panel navigation
vim.keymap.set("n", "<A-h>", "<C-w>h",            { silent = true })
vim.keymap.set("n", "<A-l>", "<C-w>l",            { silent = true })
vim.keymap.set("t", "<A-h>", "<C-\\><C-n><C-w>h", { silent = true })
vim.keymap.set("t", "<A-l>", "<C-\\><C-n><C-w>l", { silent = true })

-- OpenCode AI panel
vim.keymap.set("n", "<leader>ai", function()
    require("toggleterm.terminal").Terminal:new({
        cmd       = "opencode",
        direction = "vertical",
        size      = DD.oc_width,
        hidden    = true,
        on_open   = function()
            vim.api.nvim_win_set_width(0, DD.oc_width)
            vim.cmd("startinsert!")
        end,
    }):toggle()
end, { silent = true, desc = "Open OpenCode AI" })

-- Terminal scrolling (for OpenCode panel etc.)
vim.keymap.set("t", "<C-Up>",   "<C-\\><C-N><C-Up>",   { silent = true, desc = "Scroll terminal up" })
vim.keymap.set("t", "<C-Down>", "<C-\\><C-N><C-Down>", { silent = true, desc = "Scroll terminal down" })

-- Apply initial keybind mode
apply_keybind_mode(DD.keybind_mode)

-- ══════════════════════════════════════════════════════════════════════════
--  AUTOCMDS
-- ══════════════════════════════════════════════════════════════════════════

apply_autosave(DD.autosave)
apply_lsp(DD.lsp_enabled)

vim.api.nvim_create_autocmd("BufLeave", {
    callback = function()
        local bufname  = vim.fn.expand("%")
        local is_empty = vim.fn.line("$") == 1 and vim.fn.getline(1) == ""
        if bufname == "" and is_empty then vim.cmd("bd!") end
    end,
})

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
})
vim.fn.timer_start(1000, function()
    vim.cmd("silent! checktime")
end, { ["repeat"] = -1 })

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        if DD.highlight_yank then
            vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
        end
    end,
})

vim.diagnostic.config({ update_in_insert = true })

-- ══════════════════════════════════════════════════════════════════════════
--  WELCOME POPUP (first launch only)
-- ══════════════════════════════════════════════════════════════════════════

local welcome_marker = vim.fn.stdpath("data") .. "/.console_ide_welcome"
if vim.fn.filereadable(welcome_marker) == 0 then
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "console_ide_welcome"

    local lines = {
        "",
        "     Thank you for choosing",
        "        Console IDE v0.1.0",
        "",
        "     [Press any key to continue]",
        "",
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    local width, height = 38, #lines
    local win = vim.api.nvim_open_win(buf, true, {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = math.floor((vim.o.lines - height) / 2),
        col       = math.floor((vim.o.columns - width) / 2),
        style     = "minimal",
        border    = "double",
        title     = "  Welcome  ",
        title_pos = "center",
    })

    local ok_f = pcall(io.open, welcome_marker, "w")
    if ok_f then
        local f = io.open(welcome_marker, "w")
        f:write("shown")
        f:close()
    end

    local welcome_ns = vim.api.nvim_create_namespace("welcome_cleanup")
    vim.on_key(function(key)
        vim.on_key(nil, welcome_ns)
        pcall(vim.api.nvim_win_close, win, true)
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end, welcome_ns)
end

-- ══════════════════════════════════════════════════════════════════════════
--  UPDATE CHECKER  (checks GitHub for new commits)
-- ══════════════════════════════════════════════════════════════════════════
local nvim_dir = vim.fn.stdpath("config")
local update_later_file = vim.fn.stdpath("data") .. "/.console_ide_update_later"
local remind_after = 86400

local function should_skip_check()
    local f = io.open(update_later_file, "r")
    if not f then return false end
    local stored = tonumber(f:read("*a"))
    f:close()
    return stored and stored > os.time()
end

local function save_later()
    local f = io.open(update_later_file, "w")
    if f then
        f:write(tostring(os.time() + remind_after))
        f:close()
    end
end

local function show_update_popup(behind)
    local log_output = vim.fn.system({
        "git", "-C", nvim_dir, "log", "--oneline",
        string.format("HEAD..origin/master"),
        "--no-decorate",
    })
    local log_lines = vim.split(vim.trim(log_output), "\n", { plain = true })
    if #log_lines > 15 then
        log_lines = vim.list_slice(log_lines, 1, 15)
        table.insert(log_lines, "...")
    end

    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].filetype = "console_ide_update"

    local lines = {
        "",
        "  ╔═══════════════════════════════════════════════════╗",
        "  ║              UPDATE AVAILABLE                    ║",
        "  ╚═══════════════════════════════════════════════════╝",
        "",
        string.format("  Console IDE is %d commit%s behind.", behind, behind > 1 and "s" or ""),
        "",
    }
    for _, l in ipairs(log_lines) do
        table.insert(lines, "  " .. l)
    end
    table.insert(lines, "")
    table.insert(lines, "  [y]  Yes       — Download & install now")
    table.insert(lines, "  [l]  Later     — Remind me tomorrow")
    table.insert(lines, "  [d]  Dismiss   — Don't ask again this session")
    table.insert(lines, "")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false

    local width, height = 60, #lines
    local win = vim.api.nvim_open_win(buf, true, {
        relative  = "editor",
        width     = width,
        height    = height,
        row       = math.floor((vim.o.lines - height) / 2),
        col       = math.floor((vim.o.columns - width) / 2),
        style     = "minimal",
        border    = "rounded",
        title     = "  Update  ",
        title_pos = "center",
    })

    local function close()
        pcall(vim.api.nvim_win_close, win, true)
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
    end

    vim.keymap.set("n", "y", function()
        vim.bo[buf].modifiable = true
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
            "", "  Installing update...", "",
        })
        vim.bo[buf].modifiable = false
        vim.cmd("redraw")
        vim.fn.system({ "git", "-C", nvim_dir, "pull", "--ff-only" })
        if vim.v.shell_error == 0 then
            local updated_lines = {
                "",
                "  ╔═══════════════════════════════════════════════════╗",
                "  ║              UPDATE INSTALLED                   ║",
                "  ╚═══════════════════════════════════════════════════╝",
                "",
                "  Restart Neovim for changes to take effect.",
                "",
            }
            for _, l in ipairs(log_lines) do
                table.insert(updated_lines, "  " .. l)
            end
            table.insert(updated_lines, "")
            table.insert(updated_lines, "  Press any key to exit")

            vim.bo[buf].modifiable = true
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, updated_lines)
            vim.bo[buf].modifiable = false

            local ns = vim.api.nvim_create_namespace("update_dismiss")
            vim.on_key(function()
                vim.on_key(nil, ns)
                close()
            end, ns)
        else
            vim.bo[buf].modifiable = true
            vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
                "", "  Update failed — check network or resolve conflicts.", "",
            })
            vim.bo[buf].modifiable = false
            vim.keymap.set("n", "q", close, { buffer = buf, silent = true, nowait = true })
            vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true, nowait = true })
        end
    end, { buffer = buf, silent = true, nowait = true })

    vim.keymap.set("n", "l", function()
        save_later()
        close()
    end, { buffer = buf, silent = true, nowait = true })

    vim.keymap.set("n", "d", close, { buffer = buf, silent = true, nowait = true })
    vim.keymap.set("n", "q", close, { buffer = buf, silent = true, nowait = true })
    vim.keymap.set("n", "<Esc>", close, { buffer = buf, silent = true, nowait = true })
end

-- Run check shortly after startup (non-blocking)
vim.defer_fn(function()
    if not vim.fn.isdirectory(nvim_dir .. "/.git") then return end
    if should_skip_check() then return end

    vim.fn.system({ "git", "-C", nvim_dir, "fetch", "origin", "--quiet" })
    if vim.v.shell_error ~= 0 then return end

    local behind_str = vim.fn.system({
        "git", "-C", nvim_dir, "rev-list", "--count", "HEAD..origin/master",
    })
    local behind = tonumber(behind_str)
    if behind and behind > 0 then
        show_update_popup(behind)
    end
end, 800)

-- Nerd Font check — warn once if no Nerd Font is installed
vim.defer_fn(function()
    if vim.g.console_ide_nerd_checked then return end
    vim.g.console_ide_nerd_checked = true
    local key = "HKLM:\\SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Fonts"
    local result = vim.fn.system('powershell -c "Get-ItemProperty -Path ' .. key .. ' 2>$null | ForEach-Object { $_.PSObject.Properties | Where-Object { $_.Name -match \\\"(Nerd| NF[MP]? )\\\" } } | Select-Object -First 1"')
    if result == nil or result:match("^%s*$") then
        vim.defer_fn(function()
            vim.api.nvim_echo({
                { "Nerd Font not detected — icons may show as ", "None" },
                { "�", "WarningMsg" },
                { ". Run ", "None" },
                { ":Customize", "Title" },
                { " to install and configure.", "None" },
            }, false, {})
        end, 100)
    end
end, 2000)
