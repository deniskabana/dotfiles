return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        json = { "eslint_d" },
      },
      formatters = {
        eslint_d = {
          args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        },
      },
    },
  },

  -- ESLint LSP for diagnostics
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },
}
