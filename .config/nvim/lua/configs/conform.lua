local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c_cpp = { "clang-format" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    go = { "gofumpt", "goimports-reviser", "golines" },
    python = { "isort", "black" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    jsx = { "prettier" },
  },

  formatters = {
    -- Go
    ["goimports-reviser"] = {
      prepend_args = { "-rm-unused" },
    },
    golines = {
      prepend_args = { "--max-len=80" },
    },
    -- Python
    black = {
      prepend_args = {
        "--fast",
        "--line-length",
        "80",
      },
    },
    isort = {
      prepend_args = {
        "--profile",
        "black",
      },
    },
    -- C / C++
    clang_format = {
      prepend_args = {
        "-style={ \
        IndentWidth: 2, \
        TabWidth: 2, \
        UseTab: Never, \
        AccessModifierOffset: 0, \
        IndentAccessModifiers: true, \
        PackConstructorInitializers: Never \
        }",
      },
    },
  },

  format_on_save = {
    --   -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
