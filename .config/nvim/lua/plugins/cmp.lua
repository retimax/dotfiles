return {
  "hrsh7th/nvim-cmp",
  -- override the options table that is used in the `require("cmp").setup()` call
  opts = function(_, opts)
    -- opts parameter is the default options table
    -- the function is lazy loaded so cmp is able to be required
    local cmp = require "cmp"
    local lspkind = require "lspkind"

    cmp.setup {
      formatting = {
        expandable_indicator = true,
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local complettion_item = entry.completion_item()
          local highlights_info = require("colorful-menu").highlights(complettion_item, vim.bo.filetype)

          -- errors such as missing parser, fallback to use a raw label.
          if highlights_info == nil then
            vim_item.abbr = complettion_item.label
          else
            vim.item.abbr_hl_group = highlights_info.highlights
            vim.item.abbr = highlights_info.text
          end

          local kind = lspkind.cmp_format {
            mode = "symbol_text",
          }(entry, vim_item)
          local strings = vim.split(kind.kind, "%s", { trimempty = true })
          vim_item.kind = " " .. (strings[1] or "") .. " "

          return vim_item
        end,
      },
    }
    -- modify the mapping part of the table
    opts.mapping["<C-x>"] = cmp.mapping.select_next_item()
  end,
}
