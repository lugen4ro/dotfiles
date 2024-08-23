-- TODO: Make it possible to disable only warning / info virtual text and keep errors with a keymap

-- TODO: Show most severe icon in sign column. Right now, if there are a hint and error on the same line, it shows the info icon...
-- This might be a reference?: https://www.reddit.com/r/neovim/comments/mvhfw7/can_built_in_lsp_diagnostics_be_limited_to_show_a/

-- relation between mason, mason-lspconfig, nvim-lspconfig
-- mason --> Install language servers easily
-- lsp-config --> LSP configuration
-- mason-lspconfig --> interop between mason.nvim and nvim-lspconfig
--   (adjusts the LSP configurations in nvim-lspconfig to use the langauge servers installed by mason.nvim)
--local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")
local neodev = require("neodev")
local lsp_zero = require("lsp-zero")

-- Only define keymaps when attaching to a buffer that has a LSP server available
lsp_zero.on_attach(function(_, bufnr)
    -- set lsp_status defaults
    -- see :help lsp-zero-keybindings to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr, preserve_mappings = true }) -- make lspzero not overwrite existing keymaps

    -- Displays hover information about the symbol under the cursor in a floating window
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, { buffer = bufnr, remap = false, desc = "[LSP] Hover" })

    -- Jumps to the definition of the symbol under the cursor
    vim.keymap.set("n", "gd", function()
        vim.lsp.buf.definition()
    end, { buffer = bufnr, remap = false, desc = "[LSP] goto definition" })

    -- Jumps to the declaration of the symbol under the cursor. Some servers don't implement this feature.
    vim.keymap.set("n", "gD", function()
        vim.lsp.buf.declaration()
    end, { buffer = bufnr, remap = false, desc = "[LSP] goto declaration" })

    -- Lists all the implementations for the symbol under the cursor in the quickfix window
    vim.keymap.set("n", "gi", function()
        vim.lsp.buf.implementation()
    end, { buffer = bufnr, remap = false, desc = "[LSP] get all implementations for symbol" })

    -- Jumps to the definition of the type of the symbol under the cursor
    vim.keymap.set("n", "go", function()
        vim.lsp.buf.type_definition()
    end, { buffer = bufnr, remap = false, desc = "[LSP] goto definition of type of symbol" })

    -- Lists all the references to the symbol under the cursor in the quickfix window
    vim.keymap.set("n", "gr", function()
        vim.lsp.buf.references()
    end, { buffer = bufnr, remap = false, desc = "[LSP] get all references of symbol" })

    -- Displays signature information about the symbol under the cursor in a floating window
    -- Difference from hover()
    -- Cursor on function parameter --> THIS will highlight the parameter under cursor in the floating window showing function details
    -- Cursor on function parameter --> hover() will show the floating variable for the variable (not the function)
    vim.keymap.set("n", "gs", function()
        vim.lsp.buf.signature_help()
    end, { buffer = bufnr, remap = false, desc = "[LSP] get signature help" })

    -- Renames all references to the symbol under the cursor
    vim.keymap.set("n", "<leader>lr", function()
        vim.lsp.buf.rename()
    end, { buffer = bufnr, remap = false, desc = "[LSP] Renames all references to the symbol under the cursor" })

    -- Format code in the current buffer
    vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format()
    end, { buffer = bufnr, remap = false, desc = "[LSP] format current buffer" })

    -- Selects a code action available at the current cursor position
    vim.keymap.set("n", "<leader>lc", function()
        vim.lsp.buf.code_action()
    end, { buffer = bufnr, remap = false, desc = "[LSP] code action at current line" })

    -- Show diagnostics in a floating window
    vim.keymap.set("n", "<leader>ld", function()
        vim.diagnostic.open_float()
    end, { buffer = bufnr, remap = false, desc = "[LSP] show current line diagnostics" })

    -- jump to next diagnostic (warning/error) in file
    vim.keymap.set("n", "[[", function()
        vim.diagnostic.goto_prev()
    end, { buffer = bufnr, remap = false, desc = "[LSP] jump to next diagnostic" })

    -- jump to previous diagnostic (warning/error) in file
    vim.keymap.set("n", "]]", function()
        vim.diagnostic.goto_next()
    end, { buffer = bufnr, remap = false, desc = "[LSP] jump to previous diagnostic" })

    -- symbol explanation ---> https://inspirnathan.com/posts/135-symbols-in-vscode
    -- symbols are class, function, variable names
    -- TODO: with typescript lsp, seems to act like a normal grep, not extracting actual sybols...
    vim.keymap.set("n", "<leader>lw", function()
        vim.lsp.buf.workspace_symbol()
    end, {
        buffer = bufnr,
        remap = false,
        desc = "[LSP] Lists all symbols in the current workspace in the quickfix window.",
    })
end)

-- Set sign icons for gutter
lsp_zero.set_sign_icons({
    error = "",
    warn = "",
    info = "",
    hint = "",
})

-- Neodev must come before lsp
-- Overrides lua_ls settings, but only for neovim config files
-- Was not working when I had a .luarc.json file in my root dir!! (was altering some settings)
neodev.setup({
    library = {
        enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
        -- these settings will be used for your Neovim config directory
        runtime = true, -- runtime path
        types = true,   -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others

        -- This makes it very slow
        plugins = true, -- installed opt or start plugins in packpath
        -- you can also specify the list of plugins to make available as a workspace library
        -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
    },
    setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files

    -- for your Neovim config directory, the config.library settings will be used as is
    -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
    -- for any other directory, config.library.enabled will be set to false
    override = function(root_dir, options) end,

    -- With lspconfig, Neodev will automatically setup your lua-language-server
    -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
    -- in your lsp start options
    lspconfig = true,

    -- much faster, but needs a recent built of lua-language-server
    -- needs lua-language-server >= 3.6.0
    pathStrict = true, -- Allows goto definition for plugins. false doesn't
})

-- Use default configuration from mason-lspconfig for those not listed here
-- Dynamic server setup, so we don't have to explicitly list every single server
-- and can just list the ones we want to override configration for.
-- See :help mason-lspconfig-dynamic-server-setup


mason_lspconfig.setup({

    handlers = {

        -- defaults
        lsp_zero.default_setup,

        -- Lua
        lua_ls = function()
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },

                        -- Disable specifix diagnostics (These were just wrong in my usecase)
                        diagnostics = {
                            -- https://luals.github.io/wiki/diagnostics/#unbalanced
                            disable = { "missing-fields", "missing-parameter" },
                        },
                    },
                },
            })
        end,

        -- C++
        clangd = function()
            lspconfig.clangd.setup({

                -- Do not automatically insert header for library used
                cmd = {
                    "clangd",
                    "--header-insertion=never", --disable automatic header insertion
                    -- "--enable-config", -- enable usage of .clangd config file (this file must be placed in project root dir)
                },
            })
        end,

        -- html = function()
        --     lspconfig.html.setup({
        --         filetypes = {
        --             "html",
        --             "css",
        --         },
        --         init_options = {
        --             configurationSection = { "html", "css", "javascript" },
        --             embeddedLanguages = {
        --                 css = true,
        --                 javascript = true,
        --             },
        --             provideFormatter = true,
        --         },
        --     })
        -- end,
        --

        -- Ignore "Unkown at rules" warning for @tailwind
        cssls = function()
            lspconfig.cssls.setup({
                settings = {
                    css = { validate = true, lint = { unknownAtRules = "ignore" } },
                    scss = { validate = true, lint = { unknownAtRules = "ignore" } },
                    less = { validate = true, lint = { unknownAtRules = "ignore" } },
                },
            })
        end,

        -- How to use volar is written here
        -- https://github.com/vuejs/language-tools
        -- Under section -> "How to configure vue language server with neovim and lsp?"
        tsserver = function()
            local vue_language_server_path = require('mason-registry').get_package('vue-language-server')
                :get_install_path() ..
                '/node_modules/@vue/language-server'
            lspconfig.tsserver.setup {
                init_options = {
                    plugins = {
                        {
                            name = '@vue/typescript-plugin',
                            location = vue_language_server_path,
                            languages = { 'vue' },
                        },
                    },
                },
                filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
            }
        end,

        volar = function()
            lspconfig.volar.setup({
                hybridMode = true
            })
        end,

    },
})
