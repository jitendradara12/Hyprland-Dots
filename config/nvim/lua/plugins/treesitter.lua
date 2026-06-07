-- IN: /home/sastauser/.config/nvim/lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",

  -- This is the fix.
  -- `opts` will MERGE these settings with LazyVim's defaults.
  -- `config` (which you had before) REPLACES them, which is bad.
  opts = {
    ensure_installed = {
      "lua",
      "vim",
      "vimdoc",
      "javascript",
      "typescript",
      -- add any other languages you want here
    },
  },
}
