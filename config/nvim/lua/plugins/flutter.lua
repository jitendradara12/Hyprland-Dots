return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "stevearc/dressing.nvim", -- Optional: for better UI on selections and depricated now
    },
    config = function()
      require("flutter-tools").setup({
        -- This is where you can add your custom configuration
        -- For now, the defaults are excellent.
        ui = {
          border = "rounded",
        },
        dev_log = {
          enabled = true,
        },
        re_load_on_save = true,
        decorations = {
          statusline = {
            device = true,
            app_version = true,
          },
        },
        widget_guides = {
          enabled = true,
        },
        lsp = {
          -- color = {
          --   enabled = true,
          -- },
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
          },
        },
      })
    end,
  },
}
