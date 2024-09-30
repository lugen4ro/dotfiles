-- TODO: have a ".avsc" file formatted with prettier as if it were a ".json"

--------------------------------------------------------------------------------
-- Setup
--------------------------------------------------------------------------------

local conform = require("conform")

conform.setup({
	default_format_opts = {
		lsp_format = "never", -- Do not use LSP for formatting by default (prevent unintended formatting)
		stop_after_first = false, -- Only apply first formatter if multiple are available
		timeout_ms = 500, --  Time to block for formatting (milisec)
	},

	formatters_by_ft = {
		vue = { "prettier" },
		lua = { "stylua" }, -- cofigure in .stylua.toml file in project root directory
		-- python = { "isort", "black" },
		python = { "ruff_format" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		yaml = { "prettier" },
		json = { "prettier" },
		jsonc = { "prettier" }, -- tsconfig.json is actually jsonc
		markdown = { "prettier" },
		graphql = { "prettier" },
		cpp = { "clang_format" },
		-- avsc = { "prettier" }
		go = { "prettier" },
		terraform = { "terraform_fmt" },
		ruby = { "rubocop" },
		-- ruby = { "rubyfmt" },
		-- ruby = { "rufo" },
	},

	-- SET THIS WITH CUSTOM AUTOCOMMAND
	-- If this is set, Conform will run the formatter on save.
	-- It will pass the table to conform.format().
	-- This can also be a function that returns the table.
	-- format_on_save = {
	--     lsp_fallback = true, -- Yes. For example using prisma-lsp formatter for prisma
	--     async = false,
	--     timeout_ms = 500,
	-- },
	format_on_save = function(bufnr)
		-- Disable format on save when custom variable is set (global or buffer-local)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- return { timeout_ms = 500, lsp_format = "fallback" }
		-- return { timeout_ms = 500, lsp_format = "" }
		return {}
	end,
})

--------------------------------------------------------------------------------
-- Commands
--------------------------------------------------------------------------------

-- Command for formatting with confrom (Supports formatting only selection)
vim.api.nvim_create_user_command("Format", function(args)
	local range = nil
	if args.count ~= -1 then
		local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
		range = {
			start = { args.line1, 0 },
			["end"] = { args.line2, end_line:len() },
		}
	end
	conform.format({ async = true, range = range })
end, { range = true })

-- Show available formatters
vim.api.nvim_create_user_command("FormatShow", function(args)
	local bufnr = vim.api.nvim_get_current_buf()
	local formatters = conform.list_formatters_to_run(bufnr) -- returns table
	print("Formatters for this buffer (Only first one is applied)")
	print(vim.inspect(formatters))
end, {})

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------

-- Disable auto-formatting on save ("Format" command will still work)
-- Commands:
--     - FormatDisable -> Disable formatting globally
--     - FormatDisable! -> Disable formatting locally (current buffer)
vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})

-- Enable auto-formatting on save (By default enabled on startup)
-- Commands:
--     - FromatEnable -> Enable auto-formatting on save
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
})
