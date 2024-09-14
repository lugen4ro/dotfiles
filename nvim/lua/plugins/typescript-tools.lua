-- Get path to tsserver installed with mason
-- local mason_registry = require('mason-registry')
-- local tsserver_path = mason_registry.get_package('typescript-language-server'):get_install_path()
-- print(tsserver_path)

local tst = require("typescript-tools").setup({
	on_attach = function()
		vim.keymap.set(
			"n",
			"<leader>to",
			":TSToolsOrganizeImports<CR>",
			{ desc = "[TST] Organize imports (Sort & remove unused)" }
		)
		vim.keymap.set("n", "<leader>tm", ":TSToolsAddMissingImports<CR>", { desc = "[TST] Add missing imports" })
		vim.keymap.set("n", "<leader>ta", ":TSToolsFixAll<CR>", { desc = "[TST] Fix all fixable errors" })
		vim.keymap.set(
			"n",
			"<leader>tr",
			":TSToolsRenameFile<CR>",
			{ desc = "[TST] Rename current file and apply changes to connected files" }
		)
		vim.keymap.set(
			"n",
			"<leader>tf",
			":TSToolsFileReferences<CR>",
			{ desc = "[TST] Find references to current file" }
		)
	end,
	settings = {
		-- Specify the tsserver installed with mason
		-- tsserver_path = tsserver_path .. '/node_modules/typescript/lib/tsserver.js',

		tsserver_plugins = {
			-- for TypeScript v4.9+
			"@styled/typescript-styled-plugin",
			"@vue/language-server",
			"@vue/typescript-plugin",

			-- or for older TypeScript versions
			-- "typescript-styled-plugin",
		},

		tsserver_file_preferences = function(ft)
			-- Some "ifology" using `ft` of opened file
			return {

				-- Full list here
				-- https://github.com/microsoft/TypeScript/blob/3b45f4db12bbae97d10f62ec0e2d94858252c5ab/src/server/protocol.ts#L3439

				-- [Defaults]
				-- quotePreference = "auto",
				-- importModuleSpecifierEnding = "auto",
				-- jsxAttributeCompletionStyle = "auto",
				-- allowTextChangesInNewFiles = true,
				-- providePrefixAndSuffixTextForRename = true,
				-- allowRenameOfImportPath = true,
				-- includeAutomaticOptionalChainCompletions = true,
				-- provideRefactorNotApplicableReason = true,
				-- generateReturnInDocTemplate = true,
				-- includeCompletionsForImportStatements = true,
				-- includeCompletionsWithSnippetText = true,
				-- includeCompletionsWithClassMemberSnippets = true,
				-- includeCompletionsWithObjectLiteralMethodSnippets = true,
				-- useLabelDetailsInCompletionEntries = true,
				-- allowIncompleteCompletions = true,
				-- displayPartsForJSDoc = true,
				-- disableLineTextInReferences = true,
				-- includeInlayParameterNameHints = "none",
				-- includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				-- includeInlayFunctionParameterTypeHints = false,
				-- includeInlayVariableTypeHints = false,
				-- includeInlayVariableTypeHintsWhenTypeMatchesName = false,
				-- includeInlayPropertyDeclarationTypeHints = false,
				-- includeInlayFunctionLikeReturnTypeHints = false,
				-- includeInlayEnumMemberValueHints = false,

				includeInlayParameterNameHints = "all",
				includeCompletionsForModuleExports = true,
			}
		end,
		tsserver_format_options = function(ft)
			-- Some "ifology" using `ft` of opened file
			return {

				-- [Defaults]
				-- insertSpaceAfterCommaDelimiter = true,
				-- insertSpaceAfterConstructor = false,
				-- insertSpaceAfterSemicolonInForStatements = true,
				-- insertSpaceBeforeAndAfterBinaryOperators = true,
				-- insertSpaceAfterKeywordsInControlFlowStatements = true,
				-- insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
				-- insertSpaceBeforeFunctionParenthesis = false,
				-- insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
				-- insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
				-- insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
				-- insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
				-- insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
				-- insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
				-- insertSpaceAfterTypeAssertion = false,
				-- placeOpenBraceOnNewLineForFunctions = false,
				-- placeOpenBraceOnNewLineForControlBlocks = false,
				-- semicolons = "ignore",
				-- indentSwitchCase = true,
			}
		end,
	},
})
