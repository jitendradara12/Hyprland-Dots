return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {},
        hyprls = {},
        pyright = {},
        ts_ls = {},
        lua_ls = {},
        zls = {},
        marksman = {
          cmd = { "env", "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1", "marksman", "server" },
        },
        clangd = {},
      },
    },
  },
}
