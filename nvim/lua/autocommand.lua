-------------------- autocmd --------------------

-- no auto insert comment when using 'o' to create a new line. keep autocomment when pressing 'enter'
-- `:help fo-table` for details on options
-- just using vim.opt.formatoptions:remove({'r', 'c', 'o'}) didn't work because it was overwritten
-- you can see where the variable was last changed with `:verbose set formatoptions?`
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "",
	command = "set fo-=r fo-=c fo-=o",
})

-- Highlight on yank
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	group = "YankHighlight",
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = "400" })
	end,
})

-- Auto save input file for AtCoder
vim.api.nvim_create_autocmd("BufLeave", {
	pattern = "/home/gen4ro/code/dsa/cpp/atcoder/input",
	command = "w",
})

-- In quickfix window, disable <CR> keymapping
-- You need <CR> original definition in quickfix window to open location
vim.api.nvim_create_autocmd("BufReadPost", {
	pattern = "quickfix",
	command = "nnoremap <buffer> <CR> <CR>",
})

-- Overwrite color scheme
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	desc = "prevent colorscheme clears self-defined DAP icon colors.",
	callback = function()
		---------- Telescope ----------
		-- Color for matches that are found while typing in Telescope
		vim.api.nvim_set_hl(0, "TelescopeMatching", { ctermbg = 0, fg = "#fab387", bg = "" })

		-- Color for filenames in the results of telescope
		vim.api.nvim_set_hl(0, "TelescopeFileMatch", { ctermbg = 0, fg = "#89dceb", bg = "" })

		---------- DAP ----------
		vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#f55151", bg = "#31353f" })
		vim.api.nvim_set_hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = "#f79b4a", bg = "#31353f" })
		vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
		vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
	end,
})

-- Do not make a backup before overwriting a file, so that parcel can recognize file changes
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.js", "*.css", "*.html" },
	desc = "Do not make a backup before overwriting a file, so that parcel can recognize file changes",
	callback = function()
		vim.opt_local.writebackup = false
	end,
})

-- In help files, jump to tag definition with gd insted of default ctrl-]
vim.api.nvim_create_autocmd({ "FileType" }, {
	pattern = { "help" },
	callback = function(opts)
		vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf })
	end,
})

-- TODO: Keep original cursor position after block yank
-- !! The following does work, but it also moves cursor when deleting which is a intolerable side-effect...
-- After yanking a block, move the cursor to the original position
-- vim.keymap.set("n", "y", "myy")
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     pattern = "*",
--     command = "'y",
-- })

-- Yank highlighted text and keep cursor at its position
vim.keymap.set("v", "y", "ygv<Esc>")

--------- Auto change IME when leaving insert mode (have to set environamental variable zenhan in .zshrc to point to zenhan.exe)
-- Japanese
vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	desc = "",
	command = "call system('${zenhan} 0')",
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
	pattern = "*",
	desc = "",
	command = "call system('${zenhan} 0')",
})

-- -- [Conform] format on save, except for C++
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         -- Example args content
--         -- {
--         --   buf = 11,
--         --   event = "BufWritePre",
--         --   file = "lua/autocommand.lua",
--         --   id = 189,
--         --   match = "/home/gen4ro/dotfiles/neovim/.config/nvim/lua/autocommand.lua"
--         -- }
--
--         -- Split current buffer file path by . and get extension
--         local utils = require("utils")
--         local parts = utils.split(args.file, ".")
--         local extension = parts[#parts]
--
--         -- Do nothing for c++
--         if extension == "cpp" then
--             return
--         end
--
--         -- Format
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })

-- -- Yank everything to windows system clipboard as well (!!! yanks also on delete to system clipboard...)
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     pattern = "*",
--     desc = "Yank to windows system clipboard",
--
--     command = "call system('/mnt/c/windows/system32/clip.exe ',@\")",
-- })

-------------------- Custom commands --------------------

-- Copy current file path
vim.api.nvim_create_user_command("CopyPath", "call setreg('+', expand('%:p'))", {})
vim.api.nvim_create_user_command("CopyRelPath", "call setreg('+', expand('%'))", {})

-- AtCoder - Save contest problem in appropriate folder with appropriate name
-- Ex) :Con BC321 A - Increasing Subsequence ----> contest/BC321_A_-_Increasing_Subsequence.cpp
vim.api.nvim_create_user_command("CON", function(args)
	-- args.args --> single string of all arguments
	-- args.fargs --> table of all arguments

	local utils = require("utils")

	-- Extract contest and problem from arguments
	local contest, problem = string.match(args.args, "([^ ]+) (.+)")

	-- Process problem string
	problem = string.gsub(problem, " ", "_")
	problem = string.gsub(problem, "/", "_")

	-- Create contest directory if it doesn't exist
	local dir_path = "/home/gen4ro/code/dsa/cpp/atcoder/contest/" .. contest
	if not utils.directory_exists(dir_path) then
		os.execute("mkdir " .. dir_path)
		print("Created directory -> " .. dir_path)
	end

	-- If file exists already, ask for confirmation
	local full_path = dir_path .. "/" .. problem .. ".cpp"
	if utils.file_exists(full_path) then
		local confirm = vim.fn.input("File already exists. Overwrite? (y/n) > ")
		if confirm ~= "y" then
			print("   ... Aborted")
			return
		end
	end

	-- Save file
	vim.cmd("silent write! " .. full_path)
	print("Saved --> " .. full_path)
end, {
	nargs = "*", -- By default doesn't accept any arguments. This changes that.
	desc = "Save current buffer in the contest folder with the right name",
})

-- Move cwd to current buffer's directory
vim.api.nvim_create_user_command("Cdb", "cd %:p:h", {
	desc = "Change directory to current buffer's directory",
})

-- Command for formatting with confrom
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	require("conform").format({ async = true, lsp_fallback = true, range = range })
end, { range = true })

-- Conceal level only for neorg buffer
-- vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--   pattern = {"*.norg"},
--   command = "set conceallevel=2"
-- })

-- vim.api.nvim_create_autocmd('BufEnter', {
--     pattern = '*',
--     callback = function ()
--         vim.opt.conceallevel = 2
--     end,
-- })

-- Prevent unindent at the first colon when typing "std::"
-- Using vim.opt did not work because it was overwritten
-- Tried ---> vim.opt.cindent = false
-- Overwritten ---> cindent Last set from ~/.local/share/nvim/nvim-linux64/share/nvim/runtime/indent/cpp.vim line 13
-- vim.api.nvim_create_autocmd('BufEnter', {
--   pattern = '',
--   command = 'set nocindent'
-- })

-- -- Start Startifu when Vim is started without file arguments.
-- vim.api.nvim_create_augroup('Startify', { clear = true })
-- vim.api.nvim_create_autocmd('StdinReadPre', {
--     group = "Startify",
--     pattern = '*',
--     callback = function() STARTIFY_STD_IN = 1 end,
-- })
--
-- vim.api.nvim_create_autocmd('VimEnter', {
--     group = "Startify",
--     pattern = '*',
--     callback = function()
--         print(vim.fn.argc())
--         if vim.fn.argc() == 0 and not STARTIFY_STD_IN then
--             vim.cmd("Startify")
--         end
--     end,
-- })

-- vim.api.nvim_create_autocmd('StdinReadPre', {
--     group = "Startify",
--     pattern = '*',
--     command = "let std_in=1"
-- })
-- vim.api.nvim_create_autocmd('VimEnter', {
--     group = "Startify",
--     pattern = '*',
--     --command = "Startify"
--     command = "if argc() == 0 && !exists('s:std_in') | Startify | endif"
-- })
