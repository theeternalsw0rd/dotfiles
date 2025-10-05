return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },

    -- Mason + mason-lspconfig + tool installer
    { "williamboman/mason.nvim", config = true },
    {
      "williamboman/mason-lspconfig.nvim",
      opts = {
        ensure_installed = {
          "ts_ls",                -- was "tsserver"
          "html",
          "cssls",
          "graphql",
          "lemminx",
          "lua_ls",
          "nginx_language_server",
          "phpactor",
          "basedpyright",
          "powershell_es",
          "somesass_ls",
          "sqlls",
        },
        -- We'll use `handlers` to enable servers via the new API.
        automatic_installation = true,
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
    -- Capabilities (nicer completion with nvim-cmp)
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    pcall(function()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
    end)

    --------------------------------------------------------------------------
    -- Per-server configs (new in 0.11): vim.lsp.config("<server>", { ... })
    --------------------------------------------------------------------------

    -- Lua
    vim.lsp.config("lua_ls", {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          completion = { callSnippet = "Replace" },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- GraphQL
    vim.lsp.config("graphql", {
      capabilities = capabilities,
      filetypes = { "graphql", "gql", "typescriptreact", "javascriptreact" },
    })

    -- Python (basedpyright)
    vim.lsp.config("basedpyright", {
      capabilities = capabilities,
      flags = { debounce_text_changes = 300 },
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

    -- PowerShell
    local home = os.getenv("HOME") or os.getenv("USERPROFILE")
    vim.lsp.config("powershell_es", {
      bundle_path = home .. "/.pwsh-es",
      settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
      on_attach = function(_, bufnr)
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
      end,
    })

    -- Lightweight defaults for the rest (install via Mason; enabled below)
    vim.lsp.config("ts_ls",                { capabilities = capabilities })
    vim.lsp.config("html",                 { capabilities = capabilities })
    vim.lsp.config("cssls",                { capabilities = capabilities })
    vim.lsp.config("lemminx",              { capabilities = capabilities })
    vim.lsp.config("nginx_language_server",{ capabilities = capabilities })
    vim.lsp.config("phpactor",             { capabilities = capabilities })
    vim.lsp.config("somesass_ls",          { capabilities = capabilities })
    vim.lsp.config("sqlls",                { capabilities = capabilities })

    --------------------------------------------------------------------------
    -- Enable servers (new in 0.11): vim.lsp.enable({ ... })
    --------------------------------------------------------------------------
    -- If you rely on mason-lspconfig, let it call vim.lsp.enable(server)
    -- for each installed server. You can still explicitly enable a list too.
    local has_mlc, mlc = pcall(require, "mason-lspconfig")
    if has_mlc then
    -- Add a default handler through `setup({ handlers = { ... } })`
    mlc.setup({
      handlers = {
      function(server)
        -- Uses your vim.lsp.config("<server>", { .. }) blocks above
        vim.lsp.enable(server)
      end,
      },
    })
    else
      -- Fallback if mason-lspconfig isn't present:
      vim.lsp.enable({
        "lua_ls",
        "graphql",
        "basedpyright",
        "powershell_es",
        "ts_ls",
        "html",
        "cssls",
        "lemminx",
        "nginx_language_server",
        "phpactor",
        "somesass_ls",
        "sqlls",
      })
    end

    --------------------------------------------------------------------------
    -- UI: diagnostics, signs, and keymaps (unchanged from your setup)
    --------------------------------------------------------------------------
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      update_in_insert = false,
    })

    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
    end

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