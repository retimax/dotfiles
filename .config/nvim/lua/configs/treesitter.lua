local options = {
  ensure_installed = {
    "vim",
    "lua",
    "vimdoc",
    "html",
    "css",
    "c",
    "cmake",
    "cpp",
    "make",
    "go",
    "gomod",
    "gosum",
    "gowork",
    "gotmpl",
    "python",
    "bash",
    "markdown",
    "markdown_inline",
    "nim",
    "asm",
    "javascript",
    "typescript",
    "tsx",
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
