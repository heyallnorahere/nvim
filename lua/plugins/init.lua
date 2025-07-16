-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("config.set")

local colorscheme = {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
        style = "night",
    },
}

-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        -- lsp
        {
            "mason-org/mason.nvim",
            opts = {}
        },

        {
            "neovim/nvim-lspconfig",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "hrsh7th/nvim-cmp",
            },
            config = require("plugins.lsp"),
            ft = { "cpp", "c", "cmake", "bash", "yaml", "lua", "json", "glsl" }
        },

        {
            "mason-org/mason-lspconfig.nvim",
            opts = {
                automatic_enable = true,
                ensure_installed = {
                    "cmake",
                    "clangd",
                    "lua_ls",
                    "yamlls",
                    "glslls",
                    "jsonls",
                },
            },
            dependencies = {
                "mason-org/mason.nvim",
                "neovim/nvim-lspconfig",
            },
        },

        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,

            ---@type snacks.Config
            opts = {
                picker = { enabled = true },
            }
        },

        -- treesitter
        {
            "nvim-treesitter/nvim-treesitter",
            branch = "master",
            lazy = false,
            build = ":TSUpdate",
            opts = {
                ensure_installed = { "cpp", "c", "glsl", "json", "yaml", "cmake", "lua" },
            },
            config = function()
                require("nvim-treesitter.configs").setup({
                    -- A list of parser names, or "all" (the listed parsers MUST always be installed)
                    ensure_installed = { "c", "glsl", "cpp", "glsl", "yaml", "bash", "cmake", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

                    -- Install parsers synchronously (only applied to `ensure_installed`)
                    sync_install = false,

                    -- Automatically install missing parsers when entering buffer
                    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
                    auto_install = true,

                    -- List of parsers to ignore installing (or "all")
                    --ignore_install = { "javascript" },

                    ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
                    -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

                    highlight = {
                        enable = true,

                        -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
                        -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
                        -- the name of the parser)
                        -- list of language that will be disabled
                        --disable = { "c", "rust" },
                        -- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
                        disable = function(lang, buf)
                            local max_filesize = 100 * 1024 -- 100 KB
                            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                            if ok and stats and stats.size > max_filesize then
                                return true
                            end
                        end,

                        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                        -- Using this option may slow down your editor, and you may see some duplicate highlights.
                        -- Instead of true it can also be a list of languages
                        additional_vim_regex_highlighting = true,
                    },
                })
            end,
        },

        -- ide-like features
        {
            "nvim-telescope/telescope.nvim",
            tag = "0.1.8",
            dependencies = { "nvim-lua/plenary.nvim" }
        },

        {
            "theprimeagen/harpoon",
        },

        -- theme
        colorscheme,

        -- keymapping
        {
            "folke/which-key.nvim",
        },

        -- git
        {
            "tpope/vim-fugitive",
        },

        -- status line
        {
            "nvim-lualine/lualine.nvim",
            dependencies = {
                colorscheme[1],
                "echasnovski/mini.icons",
                "stevearc/overseer.nvim",
            },
            config = function()
                local lualine = require("lualine")
                local overseer = require("overseer")

                lualine.setup({
                    options = {
                        theme = "tokyonight",
                    },
                    sections = {
                        lualine_x = {
                            "overseer",
                        },
                    },
                    extensions = {
                        "overseer",
                    },
                })
            end,
        },

        -- debugger
        {
            "mfussenegger/nvim-dap",
            opts = {},
            config = require("plugins.dap"),
        },

        -- tasks
        {
            "stevearc/overseer.nvim",
            opts = {},
            dependencies = {
                "mfussenegger/nvim-dap",
            },
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "tokyonight" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
