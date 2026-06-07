-- lua/plugins/core.lua
return {
  "LazyVim/LazyVim",
  opts = {
    diagnostics = {
      -- This is the setting you want!
      -- It disables the inline error messages in normal mode.
      virtual_text = false,

      -- Optional: This stops diagnostics from running as you type.
      update_in_insert = false,
    },
  },
}
