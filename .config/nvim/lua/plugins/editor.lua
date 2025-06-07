return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
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

	-- Highlight and search TODOs
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {},
	},

	-- Smooth scroll
	{ "psliwka/vim-smoothie" },

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

			-- Window-Specific Minimap Controls
			{ "<leader>nwt", "<cmd>Neominimap WinToggle<cr>", desc = "Toggle minimap for current window" },
			{ "<leader>nwr", "<cmd>Neominimap WinRefresh<cr>", desc = "Refresh minimap for current window" },
			{ "<leader>nwo", "<cmd>Neominimap WinEnable<cr>", desc = "Enable minimap for current window" },
			{ "<leader>nwc", "<cmd>Neominimap WinDisable<cr>", desc = "Disable minimap for current window" },

			-- Tab-Specific Minimap Controls
			{ "<leader>ntt", "<cmd>Neominimap TabToggle<cr>", desc = "Toggle minimap for current tab" },
			{ "<leader>ntr", "<cmd>Neominimap TabRefresh<cr>", desc = "Refresh minimap for current tab" },
			{ "<leader>nto", "<cmd>Neominimap TabEnable<cr>", desc = "Enable minimap for current tab" },
			{ "<leader>ntc", "<cmd>Neominimap TabDisable<cr>", desc = "Disable minimap for current tab" },

			-- Buffer-Specific Minimap Controls
			{ "<leader>nbt", "<cmd>Neominimap BufToggle<cr>", desc = "Toggle minimap for current buffer" },
			{ "<leader>nbr", "<cmd>Neominimap BufRefresh<cr>", desc = "Refresh minimap for current buffer" },
			{ "<leader>nbo", "<cmd>Neominimap BufEnable<cr>", desc = "Enable minimap for current buffer" },
			{ "<leader>nbc", "<cmd>Neominimap BufDisable<cr>", desc = "Disable minimap for current buffer" },

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
