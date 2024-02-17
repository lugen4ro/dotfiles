local settings = {

    -- Loads all default modules
    ["core.defaults"] = {},

    -- Conceals underlying text with replacement
    ["core.concealer"] = {},

    -- Manages Neorg workspaces
    ["core.dirman"] = {
        config = {
            workspaces = {
                notes = "~/notes",
            },
            default_workspace = "notes",
        },
    },

    ["core.autocommands"] = {},
    ["core.integrations.treesitter"] = {},
    ["core.completion"] = { config = { engine = "nvim-cmp" } },
}

require("neorg").setup({ load = settings })

-- Concealed text is completely hidden unless it has a custom replacement character defined
-- vim.g.conceallevel = 2

-- vim.wo.foldlevel = 99
-- vim.wo.conceallevel = 2 -- set elsewhere
