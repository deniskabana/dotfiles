return {
  -- add my own theme
  -- { "deniskabana/halender.nvim" },
  {
    dir = "/Users/denis/projects/open-source/halender.nvim/editors/nvim", -- use this instead
    name = "halender.nvim",
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "halender-light",
      colorscheme = "halender",
    },
  },
}
