-- https://github.com/stevearc/conform.nvim

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        lua = { "stylua" }, -- cofigure in .stylua.toml file in project root directory
        python = { "isort", "black" }, -- Conform will run multiple formatters sequentially
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        svelte = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        yaml = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        cpp = { "clang_format" },
    },

    -- If this is set, Conform will run the formatter on save.
    -- It will pass the table to conform.format().
    -- This can also be a function that returns the table.
    format_on_save = {
        lsp_fallback = false, -- We only want the above formatters so false
        async = false,
        timeout_ms = 500,
    },
})
