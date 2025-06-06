return {
  -- Custom Lualine separators + remove navic
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      -- Custom separators (half circles)
      opts.options = opts.options or {}
      opts.options.section_separators = { left = "", right = "" }
      opts.options.disabled_filetypes.winbar = { "dashboard", "lazy", "alpha" }

      -- remove navic from the statusline
      local navic = table.remove(opts.sections.lualine_c)
      opts.winbar = { lualine_b = { "filename" }, lualine_c = { navic } }
      opts.inactive_winbar = { lualine_b = { "filename" } }

      return opts
    end,
  },

  -- Bufferline customizations
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        separator_style = "slant",
        show_close_icon = false,
        show_buffer_close_icons = false,
        indicator = { style = "underline" },
      },
      highlights = {
        buffer_selected = { bg = "#2f3b54", fg = "#d7dce2", sp = "#ffd580" },
      },
    },
  },

  -- Snacks explorer (telescope and nvimtree replacement)
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            layout = { layout = { position = "right", width = 60 } },
            auto_close = true,
            matcher = { fuzzy = true },
            win = { list = { wo = { number = true, relativenumber = true } } },
          },
        },
      },
    },
  },
}
