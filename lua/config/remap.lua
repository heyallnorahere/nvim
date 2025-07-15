-- stealing both nano's and primeagen's keybinds. sorry
-- https://github.com/goolord/nvim - nano's config

export = {}

export.cmp = {
    preset = "default",

    ["<Tab>"] = { "select_next", "fallback" },
    ["<C-n>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<C-p>"] = { "select_prev", "fallback" },

    -- disable
    ["<Up>"] = {},
    ["<Down>"] = {},
}

function export.on_lsp_attach(client, buf)
    local wk = require("which-key")

    -- https://github.com/goolord/nvim/blob/main/lua/modules/lsp.lua
    wk.add {
        { noremap = true, silent = true, buffer = buf },
        { "<C-d>", function() vim.diagnostic.open_float(0, { scope = "line" }) end, desc = "Show diagnostics" },
        { "K", vim.lsp.buf.hover, desc = "Hover" },
        { "g[", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
        { "g]", vim.diagnostic.goto_next, desc = "Next diagnostic" },
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Go to symbol definition" },
        { "<leader>fs", function() Snacks.picker.lsp_workspace_symbols() end, desc = "List workspace symbols" },
        { "<leader>l", name = "+LSP" },
        { "<leader>lk", vim.lsp.buf.signature_help, desc = "Signature help" },
        { "<leader>lR", vim.lsp.buf.rename, desc = "Rename" },
        { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "Implementation" },
        { "<leader>li", function() Snacks.picker.lsp_references() end, desc = "References" },
        { "<leader>lt", function() Snacks.picker.lsp_type_definitions() end, desc = "Type definition" },
        { "<leader>lf", function() vim.lsp.buf.format({ async = true }) end, desc = "Format document" },
        { "<C-]>", vim.lsp.buf.definition, desc = "Go to definition" }
    }
end

function export.map_keys()
    local wk = require("which-key")
    local mason_lspconfig = require("mason-lspconfig")

    -- vim
    wk.add{{
        { "<leader>pv", vim.cmd.Ex },
        { "<leader>gs", vim.cmd.Git },
    }}

    -- harpoon
    local mark = require("harpoon.mark")
    local ui = require("harpoon.ui")

    wk.add({
        { "<leader>a", mark.add_file },
        { "<C-e>", ui.toggle_quick_menu },

        { "<C-h>", function() ui.nav_file(1) end },
        { "<C-t>", function() ui.nav_file(2) end },
        { "<C-n>", function() ui.nav_file(3) end },
        { "<C-s>", function() ui.nav_file(4) end },
    })

    -- telescope
    local ts = require("telescope.builtin")

    wk.add({
        { "<leader>pf", ts.find_files, },
        { "<C-p>", ts.git_files, },
        { "<leader>ps", function()
            ts.grep_string({ search = vim.fn.input("Grep > ") })
        end },
    })

    -- lsp
end

return export
