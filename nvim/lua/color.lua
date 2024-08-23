-- local color = "tokyonight"
-- local color = "catppuccin-frappe"
local color = "catppuccin-mocha"

-- Set overall colorscheme
require("catppuccin").setup({
    integrations = {
        telescope = true,
        treesitter = true,
        which_key = true,
        cmp = true,
        notify = true,
        -- noice = true, -- Icon for command bar gets distorted?
        dap = true, -- test comment
        dap_ui = true,

        native_lsp = { -- lsp-config
            enabled = true,
            virtual_text = {
                errors = { "italic" },
                hints = { "italic" },
                warnings = { "italic" },
                information = { "italic" },
            },
            underlines = {
                errors = { "underline" },
                hints = { "underline" },
                warnings = { "underline" },
                information = { "underline" },
            },
            inlay_hints = {
                background = true,
            },
        },
    },
})
vim.cmd.colorscheme(color)

-- Customize highligh groups
local function set_highlight(hl_table)
    for hl_group_name, hl_config in pairs(hl_table) do
        vim.api.nvim_set_hl(0, hl_group_name, hl_config)
    end
end
local hl_table = {

    -- Customize color for git diff
    DiffAdd = { bg = "#1c4428" },
    DiffDelete = { bg = "#542426" },
    DiffChange = { bg = "#45493e" },
    DiffText = { fg = "#f0ff4e", bg = "#75775a" },
}
set_highlight(hl_table)

-- set highlight group
-- 'Normal' is the base highlight group
-- Any highlight group that doesn't define a field inherits this
-- do ":highlight" to see all settings
-- ref: https://neovim.io/doc/user/api.html#nvim_set_hl()
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
