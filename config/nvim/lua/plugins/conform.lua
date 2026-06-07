--  i added this
return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      -- Add this line to your existing mappings:
      --markdown = { "prettier" },
      -- Also good for formatting code blocks *inside* Markdown files:
      markdown = { "prettier", "injected" },
    },
  },
}
