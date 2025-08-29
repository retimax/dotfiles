local on_attach = require("nvchad.configs.lspconfig").on_attach
local on_init = require("nvchad.configs.lspconfig").on_init
local capabilities = require("nvchad.configs.lspconfig").capabilities

local lspconfig = require "lspconfig"

-- list of all servers configured.
lspconfig.servers = {
  "lua_ls",
  "clangd",
  "nim_langserver",
  "ts_ls",
  "tailwindcss",
  "eslint",
  "gopls",
}

-- list of servers configured with default config.
local default_servers = {
  "pyright",
}

-- Golang setup
lspconfig.gopls.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      completeUnimported = true,
      usePlaceholders = true,
      staticcheck = true,
    },
  },
}

-- Clangd setup
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  on_init = on_init,
  capabilities = capabilities,
  cmd = { "clangd" },
  root_dir = lspconfig.util.root_pattern("compile_flags.txt", ".git"),
}

-- Nimlsp
lspconfig.nim_langserver.setup {
  on_attach = on_attach,
  on_init = on_init, -- Agregar esta línea
  capabilities = capabilities,
  cmd = { "nimlsp" },
  filetypes = { "nim" },
  root_dir = function(fname)
    return lspconfig.util.find_git_ancestor(fname)
      or lspconfig.util.root_pattern("*.nimble", ".git")(fname)
      or lspconfig.util.path.dirname(fname)
  end,
  single_file_support = true,
  settings = {
    nim = {
      -- Configuraciones específicas de nimlsp si las necesitas
    },
  },
}

-- Nextjs setup
local nextjs_servers = { "ts_ls", "tailwindcss", "eslint" }

for _, lsp in ipairs(nextjs_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

-- Typescript setup
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

-- Tailwindcss
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,
}

require("render-markdown").setup {
  completions = { lsp = { enable = true } },
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    on_init = on_init,
    capabilities = capabilities,
  }
end

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  on_init = on_init,
  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = {
        enable = false, -- Disable all diagnostics from lua_ls
        -- globals = { "vim" },
      },
      workspace = {
        library = {
          vim.fn.expand "$VIMRUNTIME/lua",
          vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
          vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/love2d/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
    },
  },
}
