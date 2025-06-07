return {
	-- Enhanced TypeScript support
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	},

	-- Sticky context of the current scope/function
	{
		"romgrk/nvim-treesitter-context",
		dependencies = { "nvim-treesitter/nvim-treesitter", "SmiteshP/nvim-navic" },
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
					"RainbowDelimiterBlue",
					"RainbowDelimiterViolet",
					"RainbowDelimiterYellow",
				},
			})
		end,
	},

	-- Autopair
	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function()
			require("mini.pairs").setup()
		end,
	},

	-- Autocomments
	{
		"folke/ts-comments.nvim",
		opts = {},
		event = "VeryLazy",
		enabled = vim.fn.has("nvim-0.10.0") == 1,
	},

	-- Flash search tool
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
	},
}
