--------- CORE Settings ----------

---------- Looks ----------

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

---------- Undo ----------

-- no temporary swapfiles are created (gonna use undo tree instead)
vim.opt.swapfile = false

-- no backup file
vim.opt.backup = false

-- retain undo history in file
vim.opt.undofile = true

-- file storing undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

---------- Tab / Indenting ----------

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

---------- Search ----------
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

---------- Other  ----------

-- Yank to the clipboard by default (use normal yank paste workflow between nvim in different tmux windows!)
vim.opt.clipboard = "unnamed"

-- to recognaize files that have @ in the filename
-- https://vi.stackexchange.com/questions/22423/in-file-names-and-gf-go-to-file
vim.opt.isfname:append("@-@")

-- fast update time
vim.opt.updatetime = 50

-- default colorcolumn to 80 chars
-- https://www.reddit.com/r/neovim/comments/t8hwsy/why_do_people_use_colorcolumn
-- in some style guides 80 chars is the maximum (80 is ok)
-- line will be the 80th column, so being on the line is ok, exceeding is ng
-- 80 is too few... especially with tabsize=4 sot use 100 or 120
vim.opt.colorcolumn = "100"

-- encoding
vim.opt.encoding = "utf-8"

-- recognize python3_host_prog to pass checkhealth
vim.g.python3_host_prog = "/usr/bin/python3"

-- Diagnostics
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

-- Japanese
-- local shell = "/usr/bin/zsh --login"
-- let &shell='/usr/bin/bash --login'
-- autocmd InsertLeave * :call system('${zenhan} 0')
-- autocmd CmdlineLeave * :call system('${zenhan} 0')

-------------------- Custom Command (To use manually in command mode) --------------------

-- vim.api.nvim_create_user_command(
--     "VH",
--     function ()
--         local keyword = vim.fn.input("File: ")
--         vim.cmd("vert help " .. keyword)
--     end,
--     {nargs = 1}
-- )

-- temporary deindent when typing "std::"
--vim.o.

---------- Other  ----------
-- https://vonheikemen.github.io/devlog/tools/configuring-neovim-using-lua/
-- vim.opt for setting config values
-- vim.g for mapleader and plugin variables
-- vim.bo for buffer local variables
-- vim.env for env variables
-- use [:help vim.opt] etc. to get info
-- :set option+=val --> vim.opt.option:append(val))
-- other ones can be seen in the above help
-- vim.opt seems to do the same and more and vim.o so use vim.opt
