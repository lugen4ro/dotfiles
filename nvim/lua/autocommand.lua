-----------------------------------------------------------------------------
-- Auto-insert comment behaviour
-----------------------------------------------------------------------------

-- Prevent auto insert comment when using 'o' to create a new line.
-- Keep autocomment when pressing 'enter'
-- `:help fo-table` for details on options
-- just using vim.opt.formatoptions:remove({'r', 'c', 'o'}) didn't work because it was overwritten
-- you can see where the variable was last changed with `:verbose set formatoptions?`
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = "",
    command = "set fo-=r fo-=c fo-=o",
})

-----------------------------------------------------------------------------
-- Highlight on yan
-----------------------------------------------------------------------------
vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = "YankHighlight",
    callback = function()
        vim.highlight.on_yank({ higroup = "IncSearch", timeout = "400" })
    end,
})

-----------------------------------------------------------------------------
-- AtCoder specific (Competitive programming setup configuration)
-----------------------------------------------------------------------------

-- Auto save input file for AtCoder
vim.api.nvim_create_autocmd("BufLeave", {
    pattern = "/home/gen4ro/code/dsa/cpp/atcoder/input",
    command = "w",
})

-----------------------------------------------------------------------------
-- Quickfix
-----------------------------------------------------------------------------

-- Have set a custom keymapping for <CR> in normal mode which interferes with quickfix keys
-- So in quickfix window, disable the <CR> keymapping (<CR> is used to open location)
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "quickfix",
    command = "nnoremap <buffer> <CR> <CR>",
})

-----------------------------------------------------------------------------
-- Colorscheme (ovewrites)
-----------------------------------------------------------------------------

-- Overwrite color scheme
vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    desc = "prevent colorscheme clears self-defined DAP icon colors.",
    callback = function()
        ---------- Telescope ----------
        -- Color for matches that are found while typing in Telescope
        vim.api.nvim_set_hl(0, "TelescopeMatching", { ctermbg = 0, fg = "#fab387", bg = "" })

        -- Color for filenames in the results of telescope
        vim.api.nvim_set_hl(0, "TelescopeFileMatch", { ctermbg = 0, fg = "#89dceb", bg = "" })

        ---------- DAP ----------
        vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#f55151", bg = "#31353f" })
        vim.api.nvim_set_hl(0, "DapBreakpointCondition", { ctermbg = 0, fg = "#f79b4a", bg = "#31353f" })
        vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef", bg = "#31353f" })
        vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379", bg = "#31353f" })
    end,
})

-----------------------------------------------------------------------------
-- Colorscheme (ovewrites)
-----------------------------------------------------------------------------

-- Do not make a backup before overwriting a file, so that parcel can recognize file changes
vim.api.nvim_create_autocmd("BufEnter", {
    pattern = { "*.js", "*.css", "*.html" },
    desc = "Do not make a backup before overwriting a file, so that parcel can recognize file changes",
    callback = function()
        vim.opt_local.writebackup = false
    end,
})

-- In help files, jump to tag definition with gd insted of default ctrl-]
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "help" },
    callback = function(opts)
        vim.keymap.set("n", "gd", "<C-]>", { silent = true, buffer = opts.buf })
    end,
})

-- TODO: Keep original cursor position after block yank
-- !! The following does work, but it also moves cursor when deleting which is a intolerable side-effect...
-- After yanking a block, move the cursor to the original position
-- vim.keymap.set("n", "y", "myy")
-- vim.api.nvim_create_autocmd("TextYankPost", {
--     pattern = "*",
--     command = "'y",
-- })

--------- Auto change IME when leaving insert mode (have to set environamental variable zenhan in .zshrc to point to zenhan.exe)
-- Japanese
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    desc = "",
    command = "call system('${zenhan} 0')",
})
vim.api.nvim_create_autocmd("CmdlineLeave", {
    pattern = "*",
    desc = "",
    command = "call system('${zenhan} 0')",
})

-- -- [Conform] format on save, except for C++
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         -- Example args content
--         -- {
--         --   buf = 11,
--         --   event = "BufWritePre",
--         --   file = "lua/autocommand.lua",
--         --   id = 189,
--         --   match = "/home/gen4ro/dotfiles/neovim/.config/nvim/lua/autocommand.lua"
--         -- }
--
--         -- Split current buffer file path by . and get extension
--         local utils = require("utils")
--         local parts = utils.split(args.file, ".")
--         local extension = parts[#parts]
--
--         -- Do nothing for c++
--         if extension == "cpp" then
--             return
--         end
--
--         -- Format
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })
