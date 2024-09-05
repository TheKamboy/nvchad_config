require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- new terminals
map("n", "<leader>h", function()
  require("nvchad.term").new { pos = "sp" }
end, { desc = "terminal new horizontal term" })

map("n", "<leader>v", function()
  require("nvchad.term").new { pos = "vsp" }
end, { desc = "terminal new vertical window" })

vim.keymap.del("n", "<leader>n")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "q:", ":", { desc = "got rid of command history" }) -- its a common mistake for me and its annoying

-- move lines
map("n", "<A-Down>", "<cmd>m .+1<CR>==") -- move line up(n)
map("n", "<A-Up>", "<cmd>m .-2<CR>==") -- move line down(n)
map("v", "<A-Down>", "<cmd>m '>+1<CR>gv=gv") -- move line up(v)
map("v", "<A-Up>", "<cmd>m '<-2<CR>gv=gv") -- move line down(v)

-- move lines (neorg)
vim.keymap.set("n", "<C-Up>", "<Plug>(neorg.text-objects.item-up)", {})
vim.keymap.set("n", "<C-Down>", "<Plug>(neorg.text-objects.item-down)", {})
vim.keymap.set({ "o", "x" }, "iH", "<Plug>(neorg.text-objects.textobject.heading.inner)", {})
vim.keymap.set({ "o", "x" }, "aH", "<Plug>(neorg.text-objects.textobject.heading.outer)", {})

-- neorg file search
vim.keymap.set("n", "<leader>fn", "<Plug>(neorg.telescope.find_norg_files)", { desc = "telescope find neorg files" })
