return {
  -- Enhanced TypeScript support
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },

  -- Disable default tsserver to avoid conflicts
  {
    "neovim/nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        tsserver = false, -- Disabled in favor of typescript-tools
      },
    },
  },

  -- Sticky context of the current scope/function
  {
    "romgrk/nvim-treesitter-context",
    config = function()
      require("treesitter-context").setup({
        enable = true,
        throttle = true,
        max_lines = 5,
      })
    end,
  },

  -- Rainbow brackets for easy reading
  {
    "HiPhish/rainbow-delimiters.nvim",
    config = function()
      require("rainbow-delimiters.setup").setup({
        query = {
          [""] = "rainbow-parens",
          lua = "rainbow-delimiters",
        },
        highlight = {
          -- 'RainbowDelimiterCyan',
          -- "RainbowDelimiterOrange",
          "RainbowDelimiterBlue",
          "RainbowDelimiterViolet",
          "RainbowDelimiterYellow",
          -- "RainbowDelimiterGreen",
          -- "RainbowDelimiterRed",
        },
      })
    end,
  },

  -- Add <Tab> and <S-Tab> mappings for cmp completion
  {
    "hrsh7th/nvim-cmp",
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local cmp = require("cmp")

      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item()
          elseif vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
          else
            fallback()
          end
        end, { "i", "s" }),
      })
    end,
  },
}
