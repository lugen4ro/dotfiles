-----------------------------------------------------------------------------
-- Appearance
-----------------------------------------------------------------------------

-- show relative line numbers
vim.opt.relativenumber = true

-- show the current line number as absolute value
vim.opt.number = true

-- set highligh on search
vim.opt.hlsearch = true

-- cursor stays thick even when in insert mode
vim.opt.guicursor = ""

-- no line wrap
vim.opt.wrap = false

-- have at least 8 lines between cursor and  top or bottom of screen
vim.opt.scrolloff = 15

-- When and how to draw the signcolumn. 'yes' stands for always
vim.opt.signcolumn = "yes"

-- when splitting window vertically, open on right side
vim.opt.splitright = true

-- when closing window, do not resize all windows
vim.opt.equalalways = false

-- Maximum number of items to show in the popup menu (for nvim-cmp)
vim.opt.pumheight = 10

-- 24-bit colour
vim.opt.termguicolors = true

-- Set colorcolumn to 120 characters (default is 80, which is too few with tabsize=4)
vim.opt.colorcolumn = "120"

-----------------------------------------------------------------------------
-- Undo
-----------------------------------------------------------------------------

-- no temporary swapfiles are created (gonna use undo tree instead)
vim.opt.swapfile = false

-- no backup file
vim.opt.backup = false

-- retain undo history in file
vim.opt.undofile = true

-- file storing undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-----------------------------------------------------------------------------
-- Tab / Indenting
-----------------------------------------------------------------------------

-- A TAB character is 4 spaces wide
vim.opt.tabstop = 4

-- Number of spaces inserted at once (becomes tab when reaches tabstop)
vim.opt.softtabstop = 4

-- tabs will be expanded into spaces
vim.opt.expandtab = true

-- indent witdth in spaces
vim.opt.shiftwidth = 4

-- apply indentation of current line to next
-- (when pressing enter in insert mode)
vim.opt.autoindent = true

-- makes autoindent react to the style/syntax of the code
vim.opt.smartindent = true

-----------------------------------------------------------------------------
-- Search
-----------------------------------------------------------------------------

-- make searches case insensitive for lower case letters
vim.opt.ignorecase = true

-- make searches case sensitive for upper case letters
vim.opt.smartcase = true

-- do not keep highlighted
vim.opt.hlsearch = true

-- highlight while typing
vim.opt.incsearch = true

-- after end of file continue searching from top of file
vim.opt.wrapscan = true

-----------------------------------------------------------------------------
-- Language / Codec
-----------------------------------------------------------------------------

-- English for notifications etc. (UTF-8 so Japanese can be handled without mojibake)
vim.cmd("language en_US.UTF-8")

-- encoding
vim.opt.encoding = "utf-8"

-----------------------------------------------------------------------------
-- Diagnostics
-----------------------------------------------------------------------------

vim.diagnostic.config({
	virtual_text = {
		source = true, -- Show source (e.g. Pyright etc.)
		format = function(diagnostic)
			if diagnostic.user_data and diagnostic.user_data.code then
				return string.format("%s %s", diagnostic.user_data.code, diagnostic.message)
			else
				return diagnostic.message
			end
		end,
	},
	signs = true,
	float = {
		header = "Diagnostics",
		source = true,
		border = "rounded",
	},
})

-----------------------------------------------------------------------------
-- Other
-----------------------------------------------------------------------------

-- Yank to the clipboard by default (use normal yank paste workflow between nvim in different tmux windows!)
vim.opt.clipboard = "unnamed"

-- Make neovim recognize files that have '@' in the filename
-- source: https://vi.stackexchange.com/questions/22423/in-file-names-and-gf-go-to-file
vim.opt.isfname:append("@-@")

-- Fast update time
vim.opt.updatetime = 50

-- recognize python3_host_prog to pass checkhealth
vim.g.python3_host_prog = "/usr/bin/python3"

-----------------------------------------------------------------------------
-- WSL Ubuntu specific
-----------------------------------------------------------------------------

-- Copy yank content to the system clipboard (but not deletes)
local clip = "/mnt/c/Windows/System32/clip.exe"
if vim.fn.executable(clip) == 1 then
	vim.api.nvim_create_augroup("WSLYank", { clear = true })
	vim.api.nvim_create_autocmd("TextYankPost", {
		group = "WSLYank",
		pattern = "*",
		callback = function()
			if vim.v.event.operator == "y" then
				vim.fn.system(clip, vim.fn.getreg("0"))
			end
		end,
	})
end
