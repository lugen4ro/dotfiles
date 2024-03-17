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
        jsonc = { "prettier" }, -- tsconfig.json is actually jsonc
        markdown = { "prettier" },
        graphql = { "prettier" },
        cpp = { "clang_format" },
        -- prisma = { "prettier" },
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
})
