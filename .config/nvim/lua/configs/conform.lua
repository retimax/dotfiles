local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    go = { "gofumpt", "goimports-reviser", "golines" },
    -- Mantenemos ruff para ambas tareas
    python = { "ruff_organize_imports", "ruff_format" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    jsx = { "prettier" },
  },

  formatters = {
    -- --- Go ---
    ["goimports-reviser"] = {
      prepend_args = { "-rm-unused" },
    },
    golines = {
      prepend_args = { "--max-len=80" },
    },

    -- --- Python (Ruff) ---
    -- Definición manual para evitar errores de argumentos inesperados o duplicados
    ruff_format = {
      command = "ruff",
      args = { "format", "--line-length", "80", "--stdin-filename", "$FILENAME", "-" },
    },
    ruff_organize_imports = {
      command = "ruff",
      args = { "check", "--select", "I", "--fix", "--stdin-filename", "$FILENAME", "-" },
    },

    -- --- C / C++ ---
    clang_format = {
      prepend_args = {
        "-style={ \
        IndentWidth: 2, \
        TabWidth: 2, \
        UseTab: Never, \
        AccessModifierOffset: 0, \
        IndentAccessModifiers: true, \
        PackConstructorInitializers: Never, \
        ReflowComments: false, \
        }",
      },
    },
  },

  format_on_save = {
    timeout_ms = 1000,
    lsp_fallback = true,
  },
}

return options
