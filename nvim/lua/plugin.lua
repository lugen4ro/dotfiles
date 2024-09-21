-- TODO: Plugins to add
--       - diffview.nvim https://github.com/sindrets/diffview.nvim?tab=readme-ov-file
--       - rainbow-delimiters.nvim https://github.com/HiPhish/rainbow-delimiters.nvim
--      - vim-rails https://github.com/tpope/vim-rails
--      - oil.nvim https://github.com/stevearc/oil.nvim
-- TODO: Plugins to create
--      - Plugin to show filename on buffer change

local plugins = {

    -- Custom status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("plugins.lualine")
        end,
    },

    -- Preview colors
    -- {
    --     "RRethy/vim-hexokinase"
    -- },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = true,
    },
    {
        "folke/tokyonight.nvim",
        name = "tokyonight",
        lazy = true,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },

    -- Git functionality from within vim
    {
        "tpope/vim-fugitive",
        -- config = function()
        --     -- vim.api.nvim_set_hl(0, "DiffAdd", { ctermbg = 0, fg = "#FFFFFF", bg = "#FFFFFF" })
        --     -- vim.api.nvim_set_hl(0, "DiffAdd", { guibg = "#FFFFFF" })
        -- end,
    },

    -- GitHub Copilot
    -- {
    --     "github/copilot.vim"
    -- },
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestions = { enabled = false },
                panel = { enabled = false },
            })
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "canary",
        dependencies = {
            { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
            { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        opts = {
            debug = true, -- Enable debugging
            auto_follow_cursor = false,
            -- See Configuration section for rest
        },
        -- See Commands section for default commands if you want to lazy load on them
    },

    -- Execute code
    {
        "CRAG666/code_runner.nvim",
        opts = {
            focus = false, -- Do not focus on runner window

            filetype = {
                python = "python3 -u",

                -- Compile to executable with same name, execute
                cpp = {
                    -- compile options (need both to work!)
                    -- -O0 <--- disable most compiler optimization so debugging works & compile time is shorter
                    -- -g <--- Produce debugging information in the operating system's native format
                    "cd $dir &&",
                    -- "clang++-17 -O0 -g $fileName -o $fileNameWithoutExt &&",
                    "g++ -O0 -g $fileName -o $fileNameWithoutExt &&",
                    "$dir/$fileNameWithoutExt &&",
                    --rm $dir/$fileNameWithoutExt",
                },

                typescript = "deno run",
            },
        },
    },

    -- Move around quick
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.harpoon")
        end,
    },

    -- UI replacement
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        -- opts = {
        --     -- add any options here
        -- },
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("plugins.noice")
        end,
    },

    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            vim.opt.termguicolors = true
            require("colorizer").setup({
                "lua",
                "javascript",
                "typescript",
                css = { css = true }, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
                scss = { css = true }, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
            })
        end,
    },

    -- Highlight todo comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("plugins.todo")
        end,
    },

    -- Since default nvim matchparen functionality seems bugged when having only single brackets in strings
    {
        "monkoose/matchparen.nvim",
        opts = {
            debounce_time = 10, -- debounce time in milliseconds for rehighlighting of brackets.
            hl_group = "MatchParen", -- highlight group of the matched brackets
        },
    },

    -- Change / Delete between parenthesis/quotes/html tags
    {
        "tpope/vim-surround",
    },

    -- Show code action availability with ligh bulb in sign gutter
    {
        "kosayoda/nvim-lightbulb",
        config = function()
            require("nvim-lightbulb").setup({
                autocmd = { enabled = false },
                sign = { enabled = true },
                number = { enabled = true },
                -- sign = { enabled = true, text = "" }, // Because number only highlighted when sign is also enabled...
                -- number = { enabled = true },
            })

            -- Setup custom command to trigger this
            local function create_lightbulb_autocommand()
                vim.api.nvim_create_augroup("Lightbulb", { clear = true })
                vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                    pattern = "*",
                    group = "Lightbulb",
                    desc = "Show lightbulb in gutter when code action is available",
                    callback = require("nvim-lightbulb").update_lightbulb,
                })
            end
            local function delete_lightbulb_autocommand()
                vim.cmd("autocmd! Lightbulb") -- Deletes all autocommands in this augroup
                -- vim.api.nvim_del_autocmd(id) -- requires id returned fomr nvim_create_autocmd
            end
            vim.api.nvim_create_user_command("LightbulbEnable", create_lightbulb_autocommand, {
                desc = "Enable Lightbulb",
            })
            vim.api.nvim_create_user_command("LightbulbDisable", delete_lightbulb_autocommand, {
                desc = "Disable Lightbulb",
            })
        end,
    },

    -- Code action utility plugih
    {
        "aznhe21/actions-preview.nvim",
        config = function()
            require("actions-preview").setup({
                telescope = {
                    sorting_strategy = "ascending",
                    layout_strategy = "vertical",
                    layout_config = {
                        width = 0.8,
                        height = 0.9,
                        prompt_position = "top",
                        preview_cutoff = 20,
                        preview_height = function(_, _, max_lines)
                            return max_lines - 15
                        end,
                    },
                },
            })
            vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
        end,
    },

    -- HTML tag autocomplete
    { "windwp/nvim-ts-autotag", dependencies = "nvim-treesitter/nvim-treesitter", opts = {} },

    -- Quickfix plugin
    {
        "kevinhwang91/nvim-bqf",
    },

    -- Typescript workspace diagnostics
    {
        "dmmulroy/tsc.nvim",
        opts = {},
    },

    -- Typescript tools on top of tsserver LSP
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        config = function()
            require("plugins.typescript-tools")
        end,
    },

    -- Markdown preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
    },

    -- Annotation Toolkit
    {
        "danymat/neogen",
        config = true,
    },

    { "iuchim/zenhan" },

    -- -- Tabline plugin
    -- {
    --     'romgrk/barbar.nvim',
    --     dependencies = {
    --         'lewis6991/gitsigns.nvim',     -- OPTIONAL: for git status
    --         'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    --     },
    --     init = function() vim.g.barbar_auto_setup = false end,
    --     opts = {
    --         -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
    --         -- animation = true,
    --         -- insert_at_start = true,
    --         -- …etc.
    --     },
    --     config = function()
    --         require("plugins.barbar")
    --     end,
    --     version = '^1.0.0', -- optional: only update when a new 1.x version is released
    -- },

    -------------------- LSP --------------------
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "VonHeikemen/lsp-zero.nvim",
            "onsails/lspkind.nvim",
            "folke/neodev.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "nvim-lua/lsp-status.nvim", -- use lsp with status bar (show current function in status bar etc.)
            {
                "folke/trouble.nvim",
                dependencies = { "nvim-tree/nvim-web-devicons" },
                opts = {},
            },
        },
        config = function()
            require("plugins.lspconfig")
        end,
    },

    -- Use mason to install LSPs
    -- Installs to *$XDG_DATA_HOME* Nvim: stdpath("data")
    -- Linux: ~/.local/share/nvim/mason/ (binaries are under bin/)
    {
        "williamboman/mason.nvim",
        opts = {}, -- necesary for some reaon?? why doesn't it load without?
        --cmd = { "Mason", "MasonInstall", "MasonLog", "MasonUninstall", "MasonUninstallAll", "MasonUpdate" },
    },
    -- TODO: --> use mason-tool-installer to automate installing formatters and linters

    -- https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim

    -- Use mason-lspconfig to bridge between lspconfig and mason
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = "williamboman/mason.nvim",
        opts = {
            -- list of available lsp: https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
            ensure_installed = {
                -- "tsserver", -- TypeScript & JavaScript -- Using typescript-tools instead
                -- "eslint",  -- TypeScript & JavaScript -- Version 4.8.0 --> from 2017 too old. Newest is 9.0.0
                "lua_ls", -- Lua
                "pyright", -- Python (pytlint is not supported?!)
                "clangd", -- C & C++
                "bashls", -- Bash
                "jsonls", -- json
                "html", -- html
                "cssls", -- css
                "tailwindcss",
                "prismals",
                "gopls", -- go
                "yamlls",
                "eslint", -- ts, js
                "volar",
                "tsserver",
                -- "emmet_language_server", -- HTML CSS
                "terraformls", -- TODO: this seemingly takes over colofing, so in telescope it's treesitter, in-file it is this, so different syles...
            },

            automatic_installation = true,
        },
    },

    -- Not working as is. Incorporate when refactoring
    -- {
    --     "glepnir/lspsaga.nvim",
    --     config = function()
    --         local saga = require("lspsaga")
    --         saga.init_lsp_saga({
    --             server_filetype_map = {
    --                 typescript = "typescript",
    --             },
    --         })
    --
    --         local opts = { noremap = true, silent = true }
    --         vim.keymap.set("n", "<C-j>", "<Cmd>Lspsaga diagnostic_jump_next<CR>", opts)
    --         vim.keymap.set("n", "K", "<Cmd>Lspsaga hover_doc<CR>", opts)
    --         vim.keymap.set("n", "gd", "<Cmd>Lspsaga lsp_finder<CR>", opts)
    --         vim.keymap.set("i", "<C-k>", "<Cmd>Lspsaga signature_help<CR>", opts)
    --         vim.keymap.set("n", "gp", "<Cmd>Lspsaga preview_definition<CR>", opts)
    --         vim.keymap.set("n", "gr", "<Cmd>Lspsaga rename<CR>", opts)
    --     end,
    -- },

    -- Telescope: Fuzzy finder plugin and so much more
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            -- Required by telescope
            "nvim-lua/plenary.nvim",

            -- Install these manually into the system!!
            -- "BurntSushi/ripgrep",
            -- "sharkdp/fd",
        },
        config = function()
            require("plugins.telescope")
        end,
    },

    -- Telescope add-ons
    {
        -- Dap comptability (What does it actually provide?)
        "nvim-telescope/telescope-dap.nvim",

        -- Telescope filer browser
        "nvim-telescope/telescope-file-browser.nvim",

        -- Native telescope sorter to improve sorting performance
        "nvim-telescope/telescope-fzf-native.nvim",
    },

    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        keys = {
            { "<C-h>", "<cmd>TmuxNavigateLeft<cr>" },
            { "<C-j>", "<cmd>TmuxNavigateDown<cr>" },
            { "<C-k>", "<cmd>TmuxNavigateUp<cr>" },
            { "<C-l>", "<cmd>TmuxNavigateRight<cr>" },
            { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>" },
        },
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("plugins.treesitter")
        end,
    },

    -------------------- Autocompletion --------------------

    -- lazy lode when entering insert mode
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = {
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "VonHeikemen/lsp-zero.nvim" },
            { "folke/neodev.nvim" }, -- autocompletion for vim.api, vim.opt kind of stuff
            { "onsails/lspkind.nvim" }, -- adds small pictograms to use with lsp
            { "tjdevries/colorbuddy.nvim" },
            { "nvim-treesitter/nvim-treesitter" },
            { "saadparwaiz1/cmp_luasnip" },

            { -- snippet engine written in lua (not only for lua)
                "L3MON4D3/LuaSnip",
                version = "v2.2",
                build = "make install_jsregexp",
                dependencies = {
                    "rafamadriz/friendly-snippets",
                },
                opts = {},
                -- config = function ()
                --
                -- end,
                -- opts = {history = false},
            },

            -- autopairs , autocompletes ()[] etc
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup()

                    --  cmp integration
                    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                    local cmp = require("cmp")
                    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
                end,
            },
        },
        config = function()
            require("plugins.cmp")
        end,
    },

    -------------------- Linter / Formatter --------------------

    -- Linting
    {
        "mfussenegger/nvim-lint",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.lint")
        end,
    },

    -- Auto install nvim-lint linters with Mason
    {
        "rshkarin/mason-nvim-lint",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-lint",
        },
        opts = {},
    },

    -- Formatting
    {
        "stevearc/conform.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("plugins.format")
        end,
    },

    -- Auto-install conform formatters with mason (Those specified at formatters_by_ft)
    {
        "zapling/mason-conform.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "stevearc/conform.nvim",
        },
        opts = {
            -- ignore_install = { "prettier" }, -- List of formatters to ignore during install
        },
    },

    -------------------- Debug [DAP: Debug Adapter Protocol] --------------------

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "theHamsta/nvim-dap-virtual-text",
            "jay-babu/mason-nvim-dap.nvim",
        },
        config = function()
            require("plugins.debug")
        end,
    },

    -------------------- Other --------------------

    -- indent lines
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("ibl").setup()
        end,
    },

    -- comment plugin
    {
        "numToStr/Comment.nvim",
        dependencies = {
            -- Context dependend comments for files with multiple different comment styles based on section
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end,
    },

    -- show git diffs
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("gitsigns").setup()
        end,
    },

    -- file tree
    {
        "nvim-tree/nvim-tree.lua",
        cmd = { "NvimTreeToggle", "NvimTreeFocus" },
        config = function()
            require("nvim-tree").setup()
        end,
    },

    -- Show undo Tree to undo operations
    {
        "mbbill/undotree",
    },

    -- Smooth scrolling
    {
        "psliwka/vim-smoothie",
    },

    -- Show key-bindings
    {
        "folke/which-key.nvim",
        init = function()
            vim.opt.timeout = true
            vim.opt.timeoutlen = 500 -- how long to wait to show whichkey menu after key input
        end,
        -- opts = require("plugins.whichkey"),
        opts = {},
    },

    -- Show register content
    {
        "tversteeg/registers.nvim",
        cmd = "Registers",
        keys = {
            { '"', mode = { "n", "v" } },
            { "<C-R>", mode = "i" },
        },
        name = "registers",
        config = function()
            require("plugins.registers")
        end,
    },

    -- C++ manual in vim
    {
        "gauteh/vim-cppman",
    },

    -- File explorer
    {
        "preservim/nerdtree",
        dependencies = {
            -- Icons for nerdtree
            "ryanoasis/vim-devicons",
            "tiagofumo/vim-nerdtree-syntax-highlight",
        },
        config = function()
            require("plugins.nerdtree")
        end,
    },

    -- Manage sessions
    {
        "rmagatti/auto-session",
        config = function()
            require("auto-session").setup({

                -- Sets the log level of the plugin
                log_level = "error",

                -- Suppress session create/restore if in one of the list of dirs
                auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

                -- Use the git branch to differentiate the session name
                auto_session_use_git_branch = false,

                -- Loads the last loaded session if session for cwd does not exist
                auto_session_enable_last_session = false,

                --  Enables/disables the plugin's auto save and restore features
                auto_session_enabled = false,

                -- ⚠️ This will only work if Telescope.nvim is installed
                -- The following are already the default values, no need to provide them if these are already the settings you want.
                session_lens = {
                    -- If load_on_setup is set to false, one needs to eventually call `require("auto-session").setup_session_lens()` if they want to use session-lens.
                    buftypes_to_ignore = {}, -- list of buffer types what should not be deleted from current session
                    load_on_setup = true,
                    theme_conf = { border = true },
                    previewer = false,
                },
            })
        end,
    },

    -- icons, for UI related plugins
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup()
        end,
    },
}

require("lazy").setup(plugins, require("plugins.lazy"))

-- On hold
-- {
--     "Aasim-A/scrollEOF.nvim",
--     config = function()
--         require('scrollEOF').setup(
--     end,
-- },
-- {
--     "ianding1/leetcode.vim",
--     config = function ()
--         vim.g.leetcode_browser = "chrome"
--     end
-- },

-- -- buffer + tab line
-- {
--     "akinsho/bufferline.nvim",
--     event = "BufReadPre",
--     opts = {
--         options = {
--             themeable = true,
--             offsets = {
--                 {filetype = "NvimTree", highlight = "NvimTreeNormal"}
--             }
--         }
--     }
-- },

--     {
--     "jay-babu/mason-nvim-dap.nvim",
--     dependencies = {"williamboman/mason.nvim",
--                     "mfussenegger/nvim-dap",
--                     "rcarriga/nvim-dap-ui",
--                     "theHamsta/nvim-dap-virtual-text",
--     },
--     config = function ()
--         require("plugins.debug")
-- },
--     end,
