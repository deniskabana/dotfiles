return {
	-- Oil file editor
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			win_options = {
				signcolumn = "yes:2",
			},
		},
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
		build = ":TSUpdate",
		branch = "master",
	},

	-- Oil git status
	{
		"refractalize/oil-git-status.nvim",

		dependencies = {
			"stevearc/oil.nvim",
		},

		config = true,
	},

	-- File tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"echasnovski/mini.icons",
			"MunifTanjim/nui.nvim",
			-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
		},
		lazy = false, -- neo-tree will lazily load itself
		---@module "neo-tree"
		---@type neotree.Config?
		opts = function(_, opts)
			local function on_move(data)
				Snacks.rename.on_rename_file(data.source, data.destination)
			end
			local events = require("neo-tree.events")
			opts.event_handlers = opts.event_handlers or {}
			vim.list_extend(opts.event_handlers, {
				{ event = events.FILE_MOVED, handler = on_move },
				{ event = events.FILE_RENAMED, handler = on_move },
			})

			return {
				close_if_last_window = true,
				window = {
					position = "right",
					width = 55,
				},
				filesystem = {
					filtered_items = {
						visible = true,
					},
				},
				follow_current_file = {
					enabled = true,
					leave_dirs_open = true,
				},
			}
		end,
	},
}
