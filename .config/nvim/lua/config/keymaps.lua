-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- No need to press shift when using colon commands
vim.keymap.set("n", ";", ":")

-- Exit insert mode with "jk" in case <Esc> is not ok (e.g. terminal with vi shortcyts)
vim.keymap.set("i", "jk", "<Esc>")

-- Map Y to yank to system clipboard
vim.keymap.set({ "n", "v" }, "Y", '"+y', { desc = "Yank to system clipboard" })

-- Delete buffers by repeatedly spammable button
vim.keymap.set("n", "X", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

-- Change buffer also with Tab / Shift-Tab
vim.keymap.set("n", "<Tab>", "<cmd>:bnext<cr>", { desc = "Next Buffer " })
vim.keymap.set("n", "<S-Tab>", "<cmd>:bprevious<cr>", { desc = "Previous Buffer " })

-- Allow quickly jumping in and out of terminal mode with familiar keys
function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
