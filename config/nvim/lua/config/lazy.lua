local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- add LazyVim and import its plugins
    {
      "LazyVim/LazyVim",
      import = "lazyvim.plugins",
      opts = {
        -- enable extras
        extras = {
          "lazyvim.plugins.extras.coding.copilot",
          "lazyvim.plugins.extras.lang.python", -- <-- ADDed THIS LINE
          "lazyvim.plugins.extras.lang.go",
          "lazyvim.plugins.extras.formatting.prettier",
          "lazyvim.plugins.extras.lang.flutter",
          --important: via Mason, install black, ruff and pyright

          -- you can add other extras here too, for example:
          "lazyvim.plugins.extras.test.core", -- <-- ADD THIS
          -- "lazyvim.plugins.extras.lang.typescript",
        },
      },
    },
    -- import/override with your plugins
    { import = "plugins" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  install = { colorscheme = { "tokyonight", "habamax" } },
  checker = {
    enabled = true, -- check for plugin updates periodically
    notify = false, -- notify on update
  }, -- automatically check for plugin updates
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

--****************************************************************************************
--this is added by me for zoom in nvide
-- local function adjust_neovide_scale(delta)
--   -- Ensure the global variable exists, default to 1.0 if not
--   if vim.g.neovide_scale_factor == nil then
--     vim.g.neovide_scale_factor = 1.5
--   end
--   -- Adjust the scale factor, preventing it from going below a small value
--   vim.g.neovide_scale_factor = math.max(0.5, vim.g.neovide_scale_factor + delta)
-- end
--
-- -- Define keymaps for zooming in, zooming out, and resetting zoom
-- vim.keymap.set("n", "<C-=>", function()
--   adjust_neovide_scale(0.1)
-- end, { desc = "Neovide Zoom In" })
-- vim.keymap.set("n", "<C-->", function()
--   adjust_neovide_scale(-0.1)
-- end, { desc = "Neovide Zoom Out" })
-- vim.keymap.set("n", "<leader>zr", function()
--   vim.g.neovide_scale_factor = 1.0
-- end, { desc = "Neovide Reset Zoom" })
--
-- -- Optional: Add mappings for Visual mode as well
-- vim.keymap.set("v", "<C-=>", function()
--   adjust_neovide_scale(0.1)
-- end, { desc = "Neovide Zoom In" })
-- vim.keymap.set("v", "<C-->", function()
--   adjust_neovide_scale(-0.1)
-- end, { desc = "Neovide Zoom Out" })
-- --the zoom config ends here
--*****************************************************************************
