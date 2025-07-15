return function()
    local lspconfig = require("lspconfig")
    local remap = require("config.remap")

    local function on_lsp_attach(client, buf)
        remap.on_lsp_attach(client, buf)

        -- nano has other stuff. uh...
    end

    vim.lsp.config("*", {
        on_attach = on_lsp_attach,
    })

    lspconfig.lua_ls.setup({
        on_attach = function(client, buf)
            runtime_path = vim.split(package.path, ";")
            table.insert(runtime_path, "lua/?.lua")
            table.insert(runtime_path, "lua/?/init.lua")

            on_lsp_attach(client, buf)
        end,
        cmd = { "lua-language-server" },
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = runtime_path,
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })
end
