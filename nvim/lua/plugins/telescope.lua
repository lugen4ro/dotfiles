local telescope = require("telescope")
--local entry_display = telescope.pickers.entry_display

-- TODO: ---> customize buffer display like this
-- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf

-- TODO: Make it possible to go up in workind directory to search below parent as well for file finder & live grep
-- file finder has a change directory functionality, but I don't quite know what it means or how to use it...

-- TODO: for picker help_tags customize the results so that they show the filename. Currently hard to distinguish if it is a plugin doc or not

local actions = require("telescope.actions")
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local action_state = require("telescope.actions.state")
local fb_actions = require("telescope").extensions.file_browser.actions

-------------------- Custom Color Picker --------------------

-- Customization is explained with example here
-- https://github.com/nvim-telescope/telescope.nvim/blob/6213322ab56eb27356fdc09a5078e41e3ea7f3bc/developers.md

-- our picker function: colors
local colors = function(opts)
	opts = opts or {}
	pickers
		.new(opts, {

			prompt_title = "colors",

			-- Finder of results
			finder = finders.new_table({
				results = {
					{ "red", "#ff0000" },
					{ "green", "#00ff00" },
					{ "blue", "#0000ff" },
				},

				-- entry_maker is a function that receives each entry in results, and returns the value, display string/function etc.
				entry_maker = function(entry)
					return {
						value = entry[2], -- hex representation as value
						display = entry[1],
						ordinal = entry[1],
					}
				end,
				-- In the source code it works something like this (many levels ...)
				-- entry_maker = make_entry(...) <-- use make_entry function to create the entry_maker function
				-- make_entry(... display = make_display ...) <-- define make_display function somewhere and pass that to display
				-- make_display() ... return displayer({...}) <--
				-- displayer = entry_display.create {...} <-- returns function to displayer that creates display
			}),

			-- Set generic sorter (if not set, no sorter available, so cannot sort)
			sorter = conf.generic_sorter(opts),

			-- select_default action will be mapped to pasting selected entry instead of opening new buffer
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					-- print(vim.inspect(selection.value))
					vim.api.nvim_put({ selection.value }, "", false, true)
				end)
				return true
			end,
		})
		:find()
end

-- to execute the function
-- colors()

-------------------- Custom make_entry function --------------------
local utils = require("telescope.utils")
local make_entry = require("telescope.make_entry")
local entry_display = require("telescope.pickers.entry_display")
local Path = require("plenary.path")

local function make_entry_file(picker)
	-- Seperated outside of make_display so that create() is not executed for every entry but only once
	local displayer = entry_display.create({

		-- Seperator string between the columns
		separator = "",

		-- Specify width for each column
		items = {
			{ width = 2 }, -- No fixed width
			{ remaining = true },
			{ remaining = true },
		},
	})

	-- entry here is what is passed to make_entry.set_default_entry_mt
	local make_display = function(entry)
		-- Get WebDev Icon for the file
		local icon, icon_highlight = utils.get_devicons(entry.relative_file_path, false)

		-- Usage --> {Display content, Highlight group}
		return displayer({
			{ icon, icon_highlight },
			{ entry.relative_dir_path, "" }, -- Default color
			{ entry.file_name, "TelescopeFileMatch" }, -- Highlight the file name with orange
		})
	end

	return function(entry)
		local file_path = entry
		local relative_file_path

		if picker == "oldfiles" then
			-- entry is absolute file path
			local cwd = vim.fn.expand(vim.loop.cwd())
			relative_file_path = entry:sub(cwd:len() + 2, -1)
		elseif picker == "find_files" then
			-- entry is relative file path (from workding directory)
			relative_file_path = entry
		end

		-- inspect content with this!
		-- print(vim.inspect(entry))

		-- Just the name --> ex) lspconfig.lua
		local file_name = require("telescope.utils").path_tail(relative_file_path)

		-- Relative directory paht --> ex) lua/plugin/config/
		local relative_dir_path = relative_file_path:sub(1, -file_name:len() - 1) -- ignore warning

		return make_entry.set_default_entry_mt({
			value = file_path,
			ordinal = file_path,
			display = make_display,
			relative_file_path = relative_file_path,
			relative_dir_path = relative_dir_path,
			file_name = file_name,
		})
	end
end

local function make_entry_string(picker)
	-- Seperated outside of make_display so that create() is not executed for every entry but only once
	local displayer = entry_display.create({

		-- Seperator string between the columns
		separator = "  ",

		-- Specify width for each column
		items = {
			-- { width = 2 }, -- No fixed width
			-- { remaining = true },
			{ width = 15 },
			-- { width = 4 },
			{ remaining = true },
		},
	})

	-- entry here is what is passed to make_entry.set_default_entry_mt
	local make_display = function(entry)
		-- Get WebDev Icon for the file
		-- local icon, icon_highlight = utils.get_devicons(entry.relative_file_path, false)

		-- Usage --> {Display content, Highlight group}
		return displayer({
			-- {entry.filename, "TelescopeResultsConstant"},
			{ entry.filename, "TelescopeFileMatch" },
			-- {entry.lnum, ""},
			{ entry.text, "" },
		})
	end

	local parse = function(entry)
		local _, _, filename, lnum, col, text = string.find(entry, [[(..-):(%d+):(%d+):(.*)]])
		local ok
		ok, lnum = pcall(tonumber, lnum)
		-- local ok
		-- ok, lnum = pcall(tostring, lnum)
		if not ok then
			lnum = nil
		end
		return filename, lnum, text
	end

	return function(entry)
		-- example entry string
		-- "lua/plugins/configs/debug.lua:342:21:vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })"

		local relative_file_path, lnum, text = parse(entry)
		local filename = require("telescope.utils").path_tail(relative_file_path)
		local file_path
		if Path:new(relative_file_path):is_absolute() then
			file_path = relative_file_path
		else
			local cwd = vim.fn.expand(vim.loop.cwd())
			file_path = Path:new({ cwd, relative_file_path }):absolute()
		end

		-- Remove whitespace at front from text
		text = text:gsub("^%s+", "")

		-- add parenthesis to line number
		-- lnum = "(" .. lnum .. ")"

		return make_entry.set_default_entry_mt({
			path = file_path,
			value = relative_file_path,
			-- ordinal = file_path,
			ordinal = text,
			display = make_display,

			relative_file_path = relative_file_path,
			filename = filename,
			text = text,
			lnum = lnum,
		})
	end
end

-------------------- Setup Telescope --------------------
telescope.setup({
	defaults = {
		sorting_strategy = "ascending",
		layout_strategy = "horizontal",
		layout_config = {
			prompt_position = "top",
			width = 0.9,
			horizontal = {
				preview_width = 0.65,
			},
		},
		file_ignore_patterns = {
			"lazy%-lock.json",
			"%.git/*",
		},
		scroll_strategy = "limit", -- "cycle"

		-- rg configuration for live_grep and grep_string
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			-- "--hidden", -- Search for hidden files
			"--follow", -- Follow symlinks
		},

		-- for any picker, open file in vertical split with CTRL-s
		mappings = {
			n = {
				-- Telescope
				["<C-l>"] = "select_vertical",
				["<C-k>"] = "select_horizontal",
				["<C-u>"] = "results_scrolling_up",
				["<C-d>"] = "results_scrolling_down",
				["<C-b>"] = "preview_scrolling_up",
				["<C-f>"] = "preview_scrolling_down",

				-- Telescope file browser
				["<C-n>"] = fb_actions.change_cwd,
				["<C-s>"] = fb_actions.toggle_browser,
				["<C-p>"] = fb_actions.toggle_all,
			},
			i = {
				-- Telescope
				["<C-l>"] = "select_vertical",
				["<C-k>"] = "select_horizontal",
				-- ["<C-t>"] = "which_key", --> use default normal ? and insert Ctrl-/
				["<C-u>"] = "results_scrolling_up",
				["<C-d>"] = "results_scrolling_down",
				["<C-b>"] = "preview_scrolling_up",
				["<C-f>"] = "preview_scrolling_down",

				-- Telescope file browser
				["<C-n>"] = fb_actions.change_cwd,
				["<C-s>"] = fb_actions.toggle_browser,
				["<C-p>"] = fb_actions.toggle_all,
			},
		},
	},
	pickers = {
		help_tags = {

			-- for help_tags picker, open buffer in vertical split by default
			mappings = {
				n = {
					-- from finder, open page in vertical mode
					["<CR>"] = "select_vertical",
				},
				i = {
					-- from finder, open page in vertical mode
					["<CR>"] = "select_vertical",
				},
			},
		},

		find_files = {
			entry_maker = make_entry_file("find_files"),
			mappings = {
				n = {
					["cd"] = function(prompt_bufnr)
						local selection = require("telescope.actions.state").get_selected_entry()
						local dir = vim.fn.fnamemodify(selection.path, ":p:h")
						require("telescope.actions").close(prompt_bufnr)
						-- Depending on what you want put `cd`, `lcd`, `tcd`
						vim.cmd(string.format("silent lcd %s", dir))
					end,
				},
			},
			follow = true, -- follow symlinks
		},

		-- buffer picker has entries sorted by last used
		-- https://github.com/nvim-telescope/telescope.nvim/issues/791
		buffers = {
			sort_lastused = true,
			-- https://github.com/nvim-telescope/telescope.nvim/issues/791#issuecomment-882101144
			sort_mru = true,
		},

		oldfiles = {
			only_cwd = true, -- show only files in the cwd
			entry_maker = make_entry_file("oldfiles"),
		},

		-- live search for string
		live_grep = {
			layout_config = {
				horizontal = {
					preview_width = 0.4,
				},
			},
			entry_maker = make_entry_string("live_grep"),
		},

		-- make preview wider for grep_sting since line-matches are longer than file-paths
		grep_string = {
			layout_config = {
				horizontal = {
					preview_width = 0.4,
				},
			},
			entry_maker = make_entry_string("live_grep"),
		},
	},

	extensions = {
		file_browser = {
			use_fd = true, -- use fd instead of plenary.scandir
			follow_symlinks = true, -- show symlinks with fd
			hijack_netrw = true,
			respect_gitignore = true,
			layout_config = {
				horizontal = {
					preview_width = 0.4,
				},
			},
		},
	},
})

-- Extensions (Must come after telescope setup function)
require("telescope").load_extension("dap")
require("telescope").load_extension("session-lens")
require("telescope").load_extension("file_browser")
require("telescope").load_extension("notify")
require("telescope").load_extension("noice")

-- Harpoon2 setup related to telescope

-- require("telescope").load_extension('harpoon')
--
-- local harpoon = require('harpoon')
-- harpoon:setup({})
--
-- -- basic telescope configuration
-- local conf = require("telescope.config").values
-- local function toggle_telescope(harpoon_files)
--     local file_paths = {}
--     for _, item in ipairs(harpoon_files.items) do
--         table.insert(file_paths, item.value)
--     end
--
--     require("telescope.pickers").new({}, {
--         prompt_title = "Harpoon",
--         finder = require("telescope.finders").new_table({
--             results = file_paths,
--         }),
--         previewer = conf.file_previewer({}),
--         sorter = conf.generic_sorter({}),
--     }):find()
-- end
--
-- -- Only do on mac os for now
-- if vim.loop.os_uname().sysname == "Darwin" then
--     vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
--         { desc = "Open harpoon window" })
-- end
