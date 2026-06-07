return {
  -- The classic Git wrapper
  {
    "tpope/vim-fugitive",
  },

  -- A better diff view
  {
    "sindrets/diffview.nvim",
    -- Optional: Configuration for keymaps
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", desc = "Diffview Open" },
      { "<leader>gc", "<cmd>DiffviewClose<CR>", desc = "Diffview Close" },
      { "<leader>gf", "<cmd>DiffviewToggleFiles<CR>", desc = "Diffview Toggle Files" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", desc = "Diffview File History" },
    },
    -- Tells lazy.nvim to only load the plugin when one of these commands is run
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFileHistory" },
  },
}
