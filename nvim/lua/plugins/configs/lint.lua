local lint = require("lint")

lint.linters_by_ft = {
	-- javascript = { "eslint_d" },
	-- typescript = { "eslint_d" },
	-- javascriptreact = { "eslint_d" },
	-- typescriptreact = { "eslint_d" },
	html = { "htmlhint" },
	css = { "stylelint" }, -- https://github.com/mfussenegger/nvim-lint/blob/2cf9ad095130755d7d87f1730bcf33c91ee822e4/lua/lint/linters/stylelint.lua#L8
	scss = { "stylelint" },
	-- python = { "pylint" },
	python = { "mypy", "ruff" },
	ruby = { "rubocop" },
}

local lint_progress = function()
	local linters = require("lint").get_running()
	if #linters == 0 then
		return "󰦕"
	end
	return "󱉶 " .. table.concat(linters, ", ")
end

-- Setup autocommand to load linter
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
	group = lint_augroup,
	callback = function()
		lint.try_lint()
		-- print(lint_progress())
	end,
})

-- Custom htmlhint linter
local severities = {
	error = vim.diagnostic.severity.ERROR,
	warning = vim.diagnostic.severity.WARN,
}

local parser_htmlhint = function(output, bufnr)
	if vim.trim(output) == "" then
		return {}
	end
	local decode_opts = { luanil = { object = true, array = true } }
	local ok, data = pcall(vim.json.decode, output, decode_opts)
	if not ok then
		return {
			{
				bufnr = bufnr,
				lnum = 0,
				col = 0,
				message = "Could not parse linter output due to: " .. data .. "\noutput: " .. output,
			},
		}
	end

	-- See https://github.com/htmlhint/HTMLHint/blob/master/test/cli/formatters/json.json
	local diagnostics = {}
	for _, result in ipairs(data or {}) do
		for _, msg in ipairs(result.messages or {}) do
			table.insert(diagnostics, {
				lnum = msg.line and (msg.line - 1) or 0,
				col = msg.col and (msg.col - 1) or 0,
				message = msg.message,
				code = msg.rule.id,
				severity = severities[msg.type],
				source = "htmlhint",
			})
		end
	end
	return diagnostics
end

lint.linters.htmlhint = {
	cmd = "htmlhint",
	stdin = true,
	args = { "stdin", "-f", "json" },
	stream = "stdout",
	ignore_exitcode = true,
	parser = parser_htmlhint,
}
