return {
	{
		"saghen/blink.cmp",
		lazy = false, -- lazy loading handled internally
		dependencies = {
			{ "onsails/lspkind.nvim" },
		},
		version = "1.*",
		opts = {
			keymap = {
				preset = "enter",
			},

			sources = {
				default = { "lsp", "path", "snippets", "buffer", "copilot" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-cmp-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			completion = {
				ghost_text = {
					enabled = true,
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				menu = {
					draw = {
						padding = { 0, 1 }, -- padding only on right side
						components = {
							kind_icon = {
								text = function(ctx)
									if ctx.kind == "Copilot" then
										return " " -- Copilot icon
									end
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									if ctx.kind == "Copilot" then
										return "WarningMsg" -- Copilot color
									end
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
			},

			signature = { enabled = true },
		},
	},
}
