local noice = require("noice")

----------------------------------------
-- TODOs
----------------------------------------

-- TODO: signature seems to not show up for C++. Sometimes if you hurry after starting nvim it does, but the second time it disapperas.
-- Seems like it is overwritten. Fix that
-- TODO: enable completion when in search mode

----------------------------------------
-- Refrences
----------------------------------------
-- https://github.com/folke/noice.nvim

-- Samples setups for stuff like filtering messages etc.
-- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes

-- nvim log levels
-- vim.log.levels.TRACE 0
-- vim.log.levels.DEBUG 1
-- vim.log.levels.INFO 2
-- vim.log.levels.WARN 3
-- vim.log.levels.ERROR 4
-- vim.log.levels.OFF 5

----------------------------------------
-- Notify (Notifications part of Noice)
----------------------------------------

-- Notify
require("notify").setup({
	background_colour = "#000000", --  For stages that change opacity this is treated as the highlight behind the window
	fps = 60,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = "",
	},
	-- level = 2, -- minimum log level --> INFO
	-- TODO: Want INFO as well but not unnecessary ones such as "saved ~~" or "not found" on search so make it possible to filter out some
	level = 3, -- make Warn because too many notifications with Info level
	minimum_width = 50,
	max_width = 200, -- Max number of coluns for messages
	render = "default",
	stages = "fade_in_slide_out",
	time_formats = {
		notification = "%T",
		notification_history = "%FT%T",
	},
	timeout = 5000, -- Default timout for notification
	top_down = true, -- Position, true -> top-right, false -> bottom-right
})

local open_url_wsl2 = function(url)
	-- print("silent !cmd.exe /C start " .. url)
	-- print("Opening --> " .. url)
	-- Replace # with \# because this command replace # with the current file for some unkown reason
	url = string.gsub(url, "#", "\\#")
	vim.cmd("silent !cmd.exe /C start " .. url)
end

----------------------------------------
-- Noice
----------------------------------------

-- https://github.com/folke/noice.nvim#%EF%B8%8F-configuration
noice.setup({
	routes = {
		{
			filter = {
				event = "msg_show",
				kind = "",
				find = "written",
			},
			opts = { skip = true },
		},
		-- {
		-- 	filter = {
		-- 		event = "msg_show",
		-- 		kind = "search_count",
		-- 	},
		-- 	opts = { skip = true },
		-- },
	},

	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			-- override the default lsp markdown formatter with Noice
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			-- override the lsp markdown formatter with Noice
			["vim.lsp.util.stylize_markdown"] = true,
			-- override cmp documentation with Noice (needs the other options to work)
			["cmp.entry.get_documentation"] = true,
		},
	},

	markdown = {
		hover = {
			["|(%S-)|"] = vim.cmd.help, -- vim help links
			-- ["%[.-%]%((%S-)%)"] = require("noice.util").open, -- markdown links
			["%[.-%]%((%S-)%)"] = open_url_wsl2, -- For WSL builtin one doesn't work so use custom
		},
	},

	-- you can enable a preset for easier configuration
	presets = {
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = false, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = true, -- add a border to hover docs and signature help
		bottom_search = false, -- use a classic bottom cmdline for search
	},

	-- signature = {
	--     enabled = true,
	--     auto_open = {
	--         enabled = true,
	--         trigger = true, -- Automatically show signature help when typing a trigger character from the LSP
	--         luasnip = true, -- Will open signature help when jumping to Luasnip insert nodes
	--         throttle = 50, -- Debounce lsp signature help request by 50ms
	--     },
	--     view = nil, -- when nil, use defaults from documentation
	--     ---@type NoiceViewOptions
	--     opts = {}, -- merged with defaults from documentation
	-- },

	hover = {
		enabled = true,
		silent = false, -- set to true to not show a message if hover is not available
		view = nil, -- when nil, use defaults from documentation
		---@type NoiceViewOptions
		opts = {}, -- merged with defaults from documentation
	},

	commands = {
		history = {
			view = "split",
			opts = { enter = true, format = "details", size = "50%" },
		},
	},

	-- format = {
	--     -- default format
	--     default = { "{level} ", "{title} ", "{message}" },
	--     -- default format for vim.notify views
	--     notify = { "{message}" },
	--     -- default format for the history
	--     details = {
	--         -- "{level} ",
	--         -- "{date} ",
	--         -- "{event}",
	--         { "{kind}", before = { ".", hl_group = "NoiceFormatKind" } },
	--         " ",
	--         "{title} ",
	--         "{cmdline} ",
	--         "{message}",
	--     },
	-- },
})
