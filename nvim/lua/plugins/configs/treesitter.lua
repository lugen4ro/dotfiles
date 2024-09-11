require("nvim-treesitter.configs").setup({
	-- language parsers for treesitter
	-- vim --> vimscript
	-- vimdoc --> vim help
	-- cpp --> c++
	ensure_installed = {
		"lua",
		"vimdoc",
		"vim",
		"regex",
		"bash",
		"markdown",
		"markdown_inline",
		"python",
		"javascript",
		"typescript",
		"html",
		"css",
		"cpp",
		"terraform",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	--sync_install = false,
	sync_install = true,

	-- Automatically install missing parsers when entering buffer
	auto_install = true,

	highlight = {
		enable = true,
		-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
		-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
		-- Using this option may slow down your editor, and you may see some duplicate highlights.
		-- Instead of true it can also be a list of languages
		additional_vim_regex_highlighting = false,
	},

	-- To get indentation when editing html tags in jsx
	indent = {
		enable = true,
	},
})
