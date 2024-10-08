local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<A-a>", function()
	harpoon:list():add()
end)
vim.keymap.set("n", "<A-e>", function()
	harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<A-j>", function()
	harpoon:list():select(1)
end)
vim.keymap.set("n", "<A-k>", function()
	harpoon:list():select(2)
end)
vim.keymap.set("n", "<A-l>", function()
	harpoon:list():select(3)
end)
vim.keymap.set("n", "<A-m>", function()
	harpoon:list():select(4)
end)
vim.keymap.set("n", "<A-,>", function()
	harpoon:list():select(5)
end)
vim.keymap.set("n", "<A-.>", function()
	harpoon:list():select(6)
end)

-- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
-- vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
