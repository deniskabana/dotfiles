require("config.lazy")
require("config.options")
require("config.keymaps")

vim.cmd("colorscheme halender")

-- Differentiate clipboards (separate system and vim registers)
vim.opt.clipboard = ""
