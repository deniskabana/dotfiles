return {
	{
		"rmagatti/auto-session",
		lazy = false,

		---enables autocomplete for opts
		---@module "auto-session"
		---@type AutoSession.Config
		opts = {
			suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		},
	},

	-- Bufferline (active buffers - tab-like)
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		event = "VeryLazy",
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
		config = function(_, opts)
			require("bufferline").setup(opts)
			-- Fix bufferline when restoring a session
			vim.api.nvim_create_autocmd({ "BufAdd", "BufDelete" }, {
				callback = function()
					vim.schedule(function()
						pcall(nvim_bufferline)
					end)
				end,
			})
		end,
	},

	-- Lualine (statusbar)
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		init = function()
			vim.g.lualine_laststatus = vim.o.laststatus
			if vim.fn.argc(-1) > 0 then
				-- set an empty statusline till lualine loads
				vim.o.statusline = " "
			else
				-- hide the statusline on the starter page
				vim.o.laststatus = 0
			end
		end,
		opts = function()
			-- PERF: we don't need this lualine require madness 🤷
			local lualine_require = require("lualine_require")
			lualine_require.require = require

			vim.o.laststatus = vim.g.lualine_laststatus

			local opts = {
				options = {
					theme = "auto",
					globalstatus = vim.o.laststatus == 2,
					disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "filename" },
					lualine_b = { "branch" },
					lualine_c = {
						"diagnostics",
						{
							function()
								return require("gitblame").get_current_blame_text()
							end,
							cond = function()
								return require("gitblame").is_blame_text_available()
							end,
							color = { link = "Comment" },
						},
					},
					lualine_x = {
						Snacks.profiler.status(),
            -- stylua: ignore
            {
              function() return require("noice").api.status.command.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
              color = function() return { fg = Snacks.util.color("Statement") } end,
            },
            -- stylua: ignore
            {
              function() return require("noice").api.status.mode.get() end,
              cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
              color = function() return { fg = Snacks.util.color("Constant") } end,
            },
            -- stylua: ignore
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = function() return { fg = Snacks.util.color("Debug") } end,
            },
            -- stylua: ignore
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = function() return { fg = Snacks.util.color("Special") } end,
            },
						{
							"diff",
							source = function()
								local gitsigns = vim.b.gitsigns_status_dict
								if gitsigns then
									return {
										added = gitsigns.added,
										modified = gitsigns.changed,
										removed = gitsigns.removed,
									}
								end
							end,
						},
						{ "copilot" },
					},
					lualine_y = {
						{ "progress", separator = " ", padding = { left = 1, right = 0 } },
						{ "location", padding = { left = 0, right = 1 } },
					},
					lualine_z = {
						function()
							return "  " .. os.date("%R")
						end,
					},
				},
				extensions = { "neo-tree", "lazy", "fzf" },
			}

			opts.winbar = {
				lualine_a = {},
				lualine_b = {
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					"filename",
				},
				lualine_c = { "navic" },
			}
			opts.inactive_winbar = {
				lualine_a = {},
				lualine_b = {
					{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
					"filename",
				},
				lualine_c = {},
			}

			return opts
		end,
	},

	-- Navic
	{
		"SmiteshP/nvim-navic",
		lazy = true,
		opts = function()
			return {
				separator = " ",
				highlight = true,
				depth_limit = 5,
				lazy_update_context = true,
				lsp = {
					auto_attach = true,
				},
			}
		end,
	},

	-- icons
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {
			file = {
				[".keep"] = { glyph = "󰊢", hl = "MiniIconsGrey" },
				["devcontainer.json"] = { glyph = "", hl = "MiniIconsAzure" },
			},
			filetype = {
				dotenv = { glyph = "", hl = "MiniIconsYellow" },
			},
		},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	-- Copilot Lualine integration
	{ "AndreM222/copilot-lualine" },

	-- ui components
	{ "MunifTanjim/nui.nvim", lazy = true },
}
