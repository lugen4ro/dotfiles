-- https://github.com/stevearc/conform.nvim

-- TODO: have a ".avsc" file formatted with prettier as if it were a ".json"

local conform = require("conform")

conform.setup({
    formatters_by_ft = {
        vue = { "prettier" },
        lua = { "stylua" },            -- cofigure in .stylua.toml file in project root directory
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
        -- avsc = { "prettier" }
        go = { "prettier" },
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
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})



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
vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})
