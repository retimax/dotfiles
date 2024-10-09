-- Customize Treesitter

---@type LazySpec
return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    ensure_installed = {
      "lua",
      "luadoc",
      "vim",
      "python",
      "bash",
      "html",
      "css",
      "javascript",
      "markdown",
      "markdown_inline",
      "latex",
      -- add more arguments for adding more treesitter parsers
    },
    highlight = {
      enable = true,
    },
  },
}
