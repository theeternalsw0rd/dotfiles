return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "folke/neodev.nvim", opts = {} },
        { "antosha417/nvim-lsp-file-operations", config = true },
        {
            "williamboman/mason.nvim",
            config = true,
        },
        {
            "williamboman/mason-lspconfig.nvim",
            opts = {
                ensure_installed = {
                    "tsserver",
                    "html",
                    "cssls",
                    "graphql",
                    "lemminx",
                    "lua_ls",
                    "nginx_language_server",
                    "phpactor",
                    "basedpyright",
                    "powershell_es",
                    "some_sass_ls",
                    "sqlls",
                },
                automatic_enable = true,
            },
        },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "prettier",
                    "stylua",
                    "isort",
                    "black",
                    "pylint",
                    "eslint_d",
                },
            },
        },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local capabilities = cmp_nvim_lsp.default_capabilities()

        -- Customize only servers that need it
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = {
                        globals = { "vim" },
                    },
                    completion = {
                        callSnippet = "Replace",
                    },
                },
            },
        })

        lspconfig.graphql.setup({
            capabilities = capabilities,
            filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
        })

        lspconfig.basedpyright.setup({
            capabilities = capabilities,
            flags = {
                debounce_text_changes = 300,
            },
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                        diagnosticMode = "openFilesOnly",
                        reportUnusedImport = false,
                        reportUnusedVariable = false,
                    },
                },
            },
        })

        local home = os.getenv("HOME") or os.getenv("USERPROFILE")
        lspconfig.powershell_es.setup({
            bundle_path = home .. "/.pwsh-es",
            on_attach = function(_, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end,
            settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
        })

        -- General LSP UI config
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            update_in_insert = false,
        })

        -- Gutter signs
        local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
        end

        -- LSP keymaps (on attach)
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = function(ev)
                local opts = { buffer = ev.buf, silent = true }
                local keymap = vim.keymap

                keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
                keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
                keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
                keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
                keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
                keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
                keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
                keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)
                keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
                keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
                keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
                keymap.set("n", "K", vim.lsp.buf.hover, opts)
                keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
            end,
        })
    end,
}