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
        {
            "Shatur/neovim-ayu",
        },

        -- keymapping
        {
            "folke/which-key.nvim",
        },

        -- git
        {
            "tpope/vim-fugitive",
        },
    },

    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
})
