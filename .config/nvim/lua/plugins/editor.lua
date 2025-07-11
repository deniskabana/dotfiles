return {
	-- Color picker
	{
		"uga-rosa/ccc.nvim",
		config = function()
			require("ccc").setup({
				bar_len = 50,
				point_char = "◯", -- Character used to represent the color point
				point_color = "#ffffff",
				bar_char = "▬",
				highlighter = {
					enabled = false,
					auto_enable = false, -- Enable highlighter automatically
					lsp = false, -- Enable LSP highlighter
				},
				picker = {
					win_opts = {
						border = "rounded", -- Border style for the color picker window
					},
				},
			})
		end,
	},

	-- Color highlighter
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			vim.opt.termguicolors = true -- True color support
			require("colorizer").setup()
		end,
	},

	-- Whick-key - help with key bindings
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "helix",
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = true })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	-- Git signs in signcolumn, also commands like Gitsigns blame (bind with which_key later)
	{ "lewis6991/gitsigns.nvim" },

	-- Blame line
	{
		"f-person/git-blame.nvim",
		event = "VeryLazy",
		opts = {
			enabled = true, -- if you want to enable the plugin
			message_template = "<date> • <author> • <summary>",
			date_format = "%d.%m.%Y",
			-- virtual_text_column = 1,
			display_virtual_text = false,
		},
	},

	-- Highlight and search TODOs
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Smooth scroll
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		opts = {},
	},

	---@module "neominimap.config.meta"
	{
		"Isrothy/neominimap.nvim",
		version = "v3.x.x",
		lazy = false,
		keys = {
			-- Global Minimap Controls
			{ "<leader>nm", "<cmd>Neominimap Toggle<cr>", desc = "Toggle global minimap" },
			{ "<leader>no", "<cmd>Neominimap Enable<cr>", desc = "Enable global minimap" },
			{ "<leader>nc", "<cmd>Neominimap Disable<cr>", desc = "Disable global minimap" },
			{ "<leader>nr", "<cmd>Neominimap Refresh<cr>", desc = "Refresh global minimap" },

			---Focus Controls
			{ "<leader>nf", "<cmd>Neominimap Focus<cr>", desc = "Focus on minimap" },
			{ "<leader>nu", "<cmd>Neominimap Unfocus<cr>", desc = "Unfocus minimap" },
			{ "<leader>ns", "<cmd>Neominimap ToggleFocus<cr>", desc = "Switch focus on minimap" },
		},
		init = function()
			-- The following options are recommended when layout == "float"
			vim.opt.wrap = false
			vim.opt.sidescrolloff = 36 -- Set a large value

			-- Refresh all windows in current tab when focus switched
			vim.api.nvim_create_autocmd("WinEnter", {
				group = vim.api.nvim_create_augroup("minimap", { clear = true }),
				pattern = "*",
				callback = function()
					require("neominimap.api").tab.refresh()
				end,
			})

			---@type Neominimap.UserConfig
			vim.g.neominimap = {
				auto_enable = true,
				float = {
					minimap_width = 11,
				},
				layout = "float",
				win_filter = function(winid)
					return winid == vim.api.nvim_get_current_win()
				end,
			}
		end,
	},
}
