-----------------------------------------------------------------------------
-- Copilot
-----------------------------------------------------------------------------

-- Start Chat session
vim.keymap.set("n", "<leader>cc", function()
    vim.cmd("CopilotChat")
    vim.cmd("startinsert")
end, { desc = "[Copilot] Start chat with copilot" })

vim.keymap.set("v", "<leader>cc", function()
    vim.cmd("CopilotChat")
    vim.cmd("startinsert")
end, { desc = "[Copilot] Start chat with copilot" })

-- Explain selected text
vim.keymap.set("v", "<leader>ce", function()
    vim.cmd("CopilotChatExplain")
end, { desc = "[Copilot] Explain selected code" })

-- Quick chat with whole buffer
vim.keymap.set("n", "<leader>cq", function()
    local input = vim.fn.input("Quick Chat: ")
    if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
    end
end, { desc = "CopilotChat - Quick chat" })

-- Trigger Telescope for Copilot
vim.keymap.set("v", "<leader>ct", function()
    -- vim.cmd("CopilotChatExplain")
    local actions = require("CopilotChat.actions")
    require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
end, { desc = "[Copilot] Explain selected code" })

-----------------------------------------------------------------------------
-- Insert mode
-----------------------------------------------------------------------------

-- exit insert mode
vim.keymap.set("i", "kj", "<Esc>", { desc = "[Basic] Exit insert mode" })
vim.keymap.set("i", "ｋｊ", function()
    vim.api.nvim_input("<Esc>")
    vim.cmd("call system('osascript ~/.dotfiles/nvim/utils/set_input_source.scpt en')") -- Switch to english from japanese
end, { desc = "[Basic] Exit insert mode while IME on" }) -- Japanese
-- When exiting Japanese language mode, also exit insert mode
-- vim.keymap.set("i", "<Esc>", "<F14><Esc>", { silent = true })

-----------------------------------------------------------------------------
-- Saving
-----------------------------------------------------------------------------

-- Save Buffer
-- vim.keymap.set("n", "<leader>w", ":update<CR>", { silent = true, desc = "[Basic] Save buffer" })
vim.keymap.set("n", "<C-x>", ":update<CR>", { silent = true, desc = "[Basic] Save buffer" })
vim.keymap.set("i", "<C-x>", "<Esc>:update<CR>", { silent = true, desc = "[Basic] Save buffer" })

-- insert empty line below
vim.keymap.set("n", "<CR>", "o<Esc>", { desc = "[Basic] Insert empty line below" })

-- On moving to last location (or moving forward) center the line as well
vim.keymap.set("n", "<C-o>", "<C-o>zz", { desc = "[Basic] Move to last location and center" })
vim.keymap.set("n", "<C-i>", "<C-i>zz", { desc = "[Basic] Move to future location and center" })

-- Insert semicolon at end of line (probably should make this buffer type specific for c++ files)
vim.keymap.set("n", "<leader>:", "m`A;<Esc>``", { desc = "[Basic] Insert Semicolon at end of line" })

-- unhighlight search results with Esc
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { desc = "[Basic] Unhilight search results with Esc" })

-- move selected rows up or down. Also, automatically indent correctly
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "[Basic] Move selected rows" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "[Basic] Move selected rows" })

-- J by default moves cursor to point of concatenation. overwrite to keep at original position
vim.keymap.set("n", "J", "mzJ`z", { desc = "[Basic] Move below line to end of current line" })

-- Close current buffer (goes with barbar tabline plugin to delete "tab" i.e. buffer)
vim.keymap.set("n", "<A-w>", ":bd<CR>", { desc = "[Basic] Delete (close) current buffer" })

-- makes ctrl-d and ctrl-u keep cursor in the middle of the screen
--vim.keymap.set("n", "<C-d>", "<C-d>zz", {desc=""})
--vim.keymap.set("n", "<C-u>", "<C-u>zz", {desc=""})

-- when searching, and going through each occurance with n/N, keep curosr in middle of screen
vim.keymap.set(
    "n",
    "n",
    "nzzzv",
    { desc = "[Basic] Keep cursor in middle of screen when going through search results" }
)
vim.keymap.set(
    "n",
    "N",
    "Nzzzv",
    { desc = "[Basic] Keep cursor in middle of screen when going through search results" }
)

-- when pasting over something in visual mode, keep the current paste value
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "[Basic] Paste over text while keeping current paste value" })

-- paste from register "0 (last yanked ,not overwritten by delete)
vim.keymap.set("n", "<leader>p", '"0p', { desc = "[Basic] Paste last yanked" })

-- Insert space in normal mode
vim.keymap.set("n", "<leader><CR>", "a <Esc>", { desc = "[Basic] Insert space while in normal mode" })

-----------------------------------------------------------------------------
-- Yank
-----------------------------------------------------------------------------

-- Yank path to current file from git project root formatted with backticks
vim.keymap.set(
    "n",
    "<leader>yf",
    ":CopyPath<Enter>",
    { desc = "[yank file path] Copy relative File path from git root (including git root)" }
)

-- Yank all text in crrent buffer
vim.keymap.set("n", "<leader>ya", 'gg<S-v>G"+y<C-o>', { desc = "[yank] yank all text" })

-- Yank GitHub file path to current file
vim.keymap.set("n", "<leader>ygf", function()
    vim.cmd("OpenInGHFile +")
end, { desc = "[yank] yank github file path" })

-- Yank GitHub permalink to current line
vim.keymap.set("n", "<leader>ygl", function()
    vim.cmd("OpenInGHFileLines +")
end, { desc = "[yank] yank github permalink to current line" })

-- Yank GitHub permalink to current lines
vim.keymap.set("v", "<leader>ygl", function()
    vim.cmd("'<,'>OpenInGHFileLines +")
end, { desc = "[yank] yank github permalink to selected lines" })

-- Yank highlighted text and keep cursor at its position
vim.keymap.set("v", "y", "ygv<Esc>")

-----------------------------------------------------------------------------
-- Delete
-----------------------------------------------------------------------------

-- delete without copying
vim.keymap.set("n", "<leader>d", '"_d', { desc = "" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "" })

-- ctrl-c is almost same as <Esc> but there are some slight differences, so map to Escape
vim.keymap.set("n", "<C-c>", "<Esc>", { remap = true, desc = "[Basic] Ctrl-c -> Esc" }) -- so that <Esc> gets remapped in to disable highlight
vim.keymap.set("i", "<C-c>", "<Esc>", { remap = true, desc = "[Basic] Ctrl-c -> Esc" })
vim.keymap.set("v", "<C-c>", "<Esc>", { remap = true, desc = "[Basic] Ctrl-c -> Esc" })
vim.keymap.set("x", "<C-c>", "<Esc>", { remap = true, desc = "[Basic] Ctrl-c -> Esc" })

-- quickly create new tmux session from vim. cannot be used yet without tmux-sessionizer
-- look at primagen video to implement later
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>", {desc="[Basic] "})

-- substitute all occurances of word currently under cursor
-- change current
-- for [[]] lookup help with "luaref-literal"
-- https://www.reddit.com/r/neovim/comments/ya71vf/what_do_or_do_in_lua_nvim_config/
-- In command mode <C-r><C-w> gets you the word under the cursor
-- \<\> is probably so that we can execute the ctrl key presses instead of having literal text
vim.keymap.set(
    "n",
    "<leader>ra",
    [[:.,$s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
    { desc = "[Basic] Replace word under cursor globally (no check)" }
)
vim.keymap.set(
    "n",
    "<leader>rc",
    [[:.,$s/\<<C-r><C-w>\>//gc<Left><Left><Left>]],
    { desc = "[Basic] Substitute word under cursor globally (with check)" }
)
vim.keymap.set("v", "<C-r>", [["hy:%s/<C-r>h//gc<left><left><left>]], { desc = "[Basic] Substitute selected text" })

--vim.keymap.set("n", "<leader>cw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {desc=""})

-- Go into insert mode at line below with correct indentation
-- (Becuase snippets create empty lines when creating functions...)
vim.keymap.set("n", "dl", "jddko", { desc = "[Basic] Go into insert mode at correct indentation in line below" })

-- primaen other stuff. do later
--vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, {desc=""})
--
--vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz", {desc=""})
--vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz", {desc=""})
--vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz", {desc=""})
--vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz", {desc=""})
--
--vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, {desc=""})
--
--vim.keymap.set("n", "<leader>vpp", "<cmd>e ~/.dotfiles/nvim/.config/nvim/lua/theprimeagen/packer.lua<CR>");
--vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");
--
--vim.keymap.set("n", "<leader><leader>", function(, {desc=""})
--    vim.cmd("so")
--end)

-- Command line completion keymaps (seems to be called wildmenu or pum?)
-- vim.api.nvim_set_keymap(
--     "c",
--     "<Up>",
--     "wildmenumode() ? '<Left>' : '<Up>'",
--     { expr = true, noremap = true, desc = "[Basic] Command line completion with up/down/left/right" }
-- )
-- vim.api.nvim_set_keymap(
--     "c",
--     "<Down>",
--     "wildmenumode() ? '<Right>' : '<Down>'",
--     { expr = true, noremap = true, desc = "[Basic] Command line completion with up/down/left/right" }
-- )
-- vim.api.nvim_set_keymap(
--     "c",
--     "<Left>",
--     "wildmenumode() ? '<Up>' : '<Left>'",
--     { expr = true, noremap = true, desc = "[Basic] Command line completion with up/down/left/right" }
-- )
-- vim.api.nvim_set_keymap(
--     "c",
--     "<Right>",
--     "wildmenumode() ? '<Down>' : '<Right>'",
--     { expr = true, noremap = true, desc = "[Basic] Command line completion with up/down/left/right" }
-- )

-- Open web links from vim with gx, from inside WSL2 (map gx to gx so i can see this entry in telescope keymaps)
-- Open URL with gx
vim.g.netrw_browsex_viewer = "cmd.exe /C start" -- Stopped working with Noice. Seems noice uses vim.ui.open instead of netrw
-- The following works with noice by overriding vim.ui.open
-- This is for WSL2
local open_url_wsl2 = function(url)
    -- print("silent !cmd.exe /C start " .. url)
    -- print("Opening --> " .. url)
    -- Replace # with \# because this command replace # with the current file for some unkown reason
    url = string.gsub(url, "#", "\\#")
    vim.cmd("silent !cmd.exe /C start " .. url)
end
vim.ui.open = open_url_wsl2

---- Copy vim messages to unnamed register "
vim.keymap.set(
    "n",
    "<leader>ml",
    [[:let @"=execute("1messages")<CR>]],
    { desc = '[VIM] Copy last message to the unnamed register "' }
)
vim.keymap.set(
    "n",
    "<leader>ma",
    [[:let @"=execute("messages")<CR>]],
    { desc = '[VIM] Copy all messages to the unnamed register "' }
)

-- Quickfix navigation
vim.keymap.set("n", "<Home>", ":cprev<Enter>zz", { silent = true })
vim.keymap.set("n", "<End>", ":cnext<Enter>zz", { silent = true })

------------------- AtCoder --------------------

-- Copy Buffer
-- Copy whole buffer into system clipboard and return to original cursor location
-- a for AtCoder

-- vim.keymap.set("n", "<leader>a", 'gg<S-v>G"+y<C-o>', { desc = "[AtCoder] Copy whole buffer to system clipboard" })

-- Run AtCoder
-- Run on inputs for AtCoder (only do for wsl2 ubuntu not mac os)
if vim.loop.os_uname().sysname ~= "Darwin" then
    vim.keymap.set("n", "<C-e>", function()
        local cur_file = vim.fn.expand("%:p")
        if cur_file == "/home/gen4ro/code/atcoder/answer.py" then
            vim.cmd("w")
            vim.cmd("silent !/home/gen4ro/code/atcoder/.io/run.sh")
        else
            print("Current file is NOT /home/gen4ro/code/atcoder/answer.py")
        end
    end, { desc = "[AtCoder] Run answer for AtCoder on inputs (Python)" })
end

-----------------------------------------------------------------------------------------------
---------------------------------------- Plugin Keymaps ---------------------------------------
-----------------------------------------------------------------------------------------------

-------------------- Run code --------------------
vim.keymap.set("n", "<leader>e", ":RunCode<CR>", { desc = "[CodeRunner] Run code" })

-------------------- Comment --------------------
-- Copy line and comment out
vim.keymap.set("n", "gcy", function()
    -- gcc probably is noremap so ordinary keymap didn't work
    -- there is a thing called nvim_feedkeys, but it didn't work like I expected so I just resorted to this vim solution
    -- also mark current location in line and stay there
    vim.cmd([[:execute "normal mzyygccjP`zj"]])
end, { desc = "[Comment] Yank and comment out" })

-- Copy visual select and comment out
vim.keymap.set("v", "gy", function()
    -- gcc probably is noremap so ordinary keymap didn't work
    -- there is a thing called nvim_feedkeys, but it didn't work like I expected so I just resorted to this vim solution
    -- also mark current location in line and stay there
    vim.cmd([[:execute "normal mzyygccjP`zj"]])
end, { desc = "[Comment] Yank and comment out" })

------------------- Trouble  -------------------
vim.keymap.set("n", "<leader>xx", function()
    require("trouble").toggle()
end, { desc = "[Trouble] Toggle Trouble window" })
vim.keymap.set("n", "<leader>xw", function()
    require("trouble").toggle("workspace_diagnostics")
end, { desc = "[Trouble] Show worksapce diagnostics" })
vim.keymap.set("n", "<leader>xd", function()
    require("trouble").toggle("document_diagnostics")
end, { desc = "[Trouble] Document diagnostics" })
vim.keymap.set("n", "<leader>xq", function()
    require("trouble").toggle("quickfix")
end, { desc = "[Trouble] Quickfix" })
vim.keymap.set("n", "<leader>xl", function()
    require("trouble").toggle("loclist")
end, { desc = "[Trouble] Loclist" })
-- vim.keymap.set("n", "gR", function() require("trouble").toggle("lsp_references") end, {desc=""})

-- Toggle diagnostics on and off
vim.g.diagnostics_active = false

local function toggle_diagnostics()
    if vim.g.diagnostics_active then
        vim.g.diagnostics_active = false
        vim.diagnostic.config({ virtual_text = false })
    else
        vim.g.diagnostics_active = true
        -- TODO: Same in options, so preferably put in 1 place
        vim.diagnostic.config({
            virtual_text = {
                source = true, -- Show source (e.g. Pyright etc.)
                format = function(diagnostic)
                    if diagnostic.user_data and diagnostic.user_data.code then
                        return string.format("%s %s", diagnostic.user_data.code, diagnostic.message)
                    else
                        return diagnostic.message
                    end
                end,
            },
            signs = true,
            float = {
                header = "Diagnostics",
                source = true,
                border = "rounded",
            },
        })
    end
end
vim.keymap.set("n", "<C-t>", toggle_diagnostics, { desc = "[Diagnostics] Toggle diagnostics on and off" })

-- Apply quickfix (Apply code action to current line)
local function quickfix()
    vim.lsp.buf.code_action({
        filter = function(a)
            return a.isPreferred
        end,
        apply = true,
    })
end
vim.keymap.set("n", "<leader>qf", quickfix, { desc = "[Diagnostics] Apply quickfix to current line (code action)" })

------------------ Telescope -------------------
local builtin = require("telescope.builtin")

-- search filee
vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[Telescope] Search files" })

-- search files including dot files (hidden)
vim.keymap.set("n", "<leader>sd", function()
    builtin.find_files({ hidden = true, no_ignore = true })
end, { desc = "[Telescope] Search files" })

-- `require("telescope.builtin").find_files({hidden=true, layout_config={prompt_position="top"}})`

-- search with grep
vim.keymap.set("n", "<leader>sg", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end, { desc = "[Telescope] Search with grep" })

-- search for string fuzzy style
vim.keymap.set("n", "<leader>sl", function()
    builtin.live_grep()
end, { desc = "[Telescope] Search string (live grep)" })

-- search git
-- vim.keymap.set('n', '<leader>sg', builtin.git_files,
-- {desc="[Telescope] Search file (git)"})

-- search previously opened files (history) in normal mode
vim.keymap.set("n", "<C-s>", function()
    builtin.oldfiles()
    -- vim.api.nvim_input("<Esc>")
end, { desc = "[Telescope] Search file (recently used)" })

-- search help
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[Telescope] Search help" })

-- open list of buffers in normal mode
vim.keymap.set("n", "<leader>sb", function()
    builtin.buffers()
    vim.api.nvim_input("<Esc>")
end, { desc = "[Telescope] Search buffers" })

-- builtin.builtin
-- Show all builtin pickers
vim.keymap.set("n", "<leader>st", function()
    builtin.builtin({ include_extensions = true })
end, { desc = "[Telescope] Search Telescope (open telescope options)" })

-- open file browser (extension for telescope)
-- vim.keymap.set(
--     "n",
--     "<leader>sv",
--     ":Telescope file_browser files=false<CR>",
--     { silent = true, desc = "[Telescope] Use Telescope file browser" }
-- )
vim.keymap.set("n", "<space>sv", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")


-- open file browser (extension for telescope) -- Starting at current directory
-- vim.keymap.set('n', '<leader>sv', ":Telescope file_browser path=%:p:h select_buffer=true<CR>",
-- {desc="[Telescope] Use Telescope file browser"})

-- Open auto-session sessions in telescope
vim.keymap.set(
    "n",
    "<leader>ss",
    require("auto-session.session-lens").search_session,
    { desc = "[Telescope] Search sessions (auto-session)" }
)

-- Search for file with word under cursor
vim.keymap.set("n", "<leader>sw", function()
    vim.cmd("normal! yiw") -- yank word under cursor
    local search_term = vim.fn.getreg('"') -- Get the yanked word from register "
    builtin.find_files({ default_text = search_term })
end, { desc = "[Telescope] Search for file with word under cursor" })

------------------- Harpoon -------------------
--local mark = require("harpoon.mark")
--local ui = require("harpoon.ui")

-- add file to harpoon
--vim.keymap.set("n", "<leader>e", mark.add_file, {desc=""})

-- open quick menu to see all added files and swtich
--vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, {desc=""})

-- hjkl to quickly change window
-- COMMENT OUT SINCE WE USE THESE FOR TMUX
--vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, {desc=""})
--vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, {desc=""})
--vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, {desc=""})
--vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, {desc=""})
--vim.keymap.set("n", "<C-n>", function() ui.nav_next() end, {desc=""})
--vim.keymap.set("n", "<C-p>", function() ui.nav_prev() end, {desc=""})

-------------------- NERDTree --------------------

--vim.keymap.set("n", "<leader>n", function () vim.cmd("NERDTreeFocus") end, {desc=""})
vim.keymap.set("n", "<C-n>", function()
    vim.cmd("NERDTreeToggle")
end, { desc = "[NERDTree] Toggle panel" })
-- vim.keymap.set("n", "<leader>n", function()
--     vim.cmd("NERDTreeFind")
-- end, { desc = "[NERDTree] Open panel with location of current file" })

-------------------- Noice  --------------------
vim.keymap.set("n", "<leader>nl", function()
    require("noice").cmd("last")
end, { desc = "[Nofity] Last message" })

vim.keymap.set("n", "<leader>nh", function()
    require("noice").cmd("history")
end, { desc = "[Nofity] History of messages" })

vim.keymap.set("n", "<leader>nd", function()
    require("notify").dismiss()
end, { desc = "[Nofity] Dismiss all notices" })

-------------------- Undotree --------------------
-- open undo tree
vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle, { desc = "[Undotree] Toggle panel" })

------------------- Fugitive --------------------
-- Show git status
vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "[Fugitive] Git Status" })

-- Add current file
vim.keymap.set("n", "<leader>ga", ":Git add %:p<CR>", { desc = "[Fugitive] Git add current file" })

-- Commit
-- -v shows the diff of what you're committing where you write the commit message
-- -q --> Suppress commit summary message
vim.keymap.set("n", "<leader>gc", ":Git commit -v -q<CR>", { desc = "[Fugitive] Commit" })

-- Push
vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "[Fugitive] Push" })

-- Diff
vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit<CR>", { desc = "[Fugitive] Diff" })

-- Blame
vim.keymap.set("n", "<leader>gb", ":Git blame<CR>", { desc = "[Fugitive] Blame" })

-------------------- LSP --------------------
-- Defined in lspconfig configuration

-------------------- Typescript-tools --------------------

-- Comment out in JSX --> Implemented with Comment.nvim functionality which existed as a branch...
-- vim.keymap.set("n", "<leader>tc", "mz_i{/* <Esc>A */}<Esc>`zlllll")
-- vim.keymap.set("v", "<leader>tc", "<Esc>`<i{/* <Esc>`>a*/}<Esc>")

-------------------- Conform --------------------
-- Format
vim.keymap.set({ "n", "v" }, "<leader>f", function()
    require("conform").format({
        lsp_fallback = "false",
        async = false,
        -- timeout_ms = 500,
    })
end, { desc = "Format code with conform" })

-------------------- Debugger [DAP] --------------------

-- Start or continue debugger
vim.keymap.set("n", "<F10>", vim.cmd.DapContinue, { desc = "[Debug] Continue debugger" })

-- Restart session
vim.keymap.set("n", "<F4>", ":lua require('dap').restart()<CR>", { desc = "[Debug] Restarts debug session" })

-- Terminate session & remove breakpoints
vim.keymap.set(
    "n",
    "<F5>",
    ":lua require('dap').terminate()<CR>:lua require('dap').clear_breakpoints()<CR>",
    { desc = "[Debug] Terimantes debug session" }
)

-- Set breakpoint
vim.keymap.set("n", "<F9>", vim.cmd.DapToggleBreakpoint, { desc = "[Debug] Set breakpoint" })

-- Set conditional breakpoint
-- expressions can be written as simple expression or native expression
-- here are the deets --> https://github.com/vadimcn/codelldb/blob/master/MANUAL.md#expressions
vim.keymap.set(
    "n",
    "<F8>",
    ":lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
    { desc = "[Debug] Set conditional breakpoint" }
)

-- Set log point?
vim.keymap.set(
    "n",
    "<F7>",
    ":lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
    { desc = "[Debug] Set log point" }
)

-- Clear Breakpoints
vim.keymap.set("n", "<F6>", ":lua require('dap').clear_breakpoints()<CR>", { desc = "[Debug] Clear breakpoint" })

-- Step
vim.keymap.set("n", "<F1>", vim.cmd.DapStepInto, { desc = "[Debug] Step into" })
vim.keymap.set("n", "<F2>", vim.cmd.DapStepOver, { desc = "[Debug] Step over" })
vim.keymap.set("n", "<F3>", vim.cmd.DapStepOut, { desc = "[Debug] Step out" })

-- Open Floating Element
-- vim.keymap.set("n", "<leader>df", require("dapui").float_element, { desc = "[Debug] Visual - Open float element" })

-- -- Evaluate Expression
-- vim.keymap.set("n", "<C-p>", require("dapui").eval, { desc = "[Debug] Visual - Evaluate expression" })
-- vim.keymap.set("v", "<C-p>", require("dapui").eval, { desc = "[Debug] Visual - Evaluate expression" })

--vim.keymap.set("n", "<leader>de", require("dapui").eval("v.size()"), {desc=""})

------------------- INFO -------------------
-- you can check each key notation (like Escape is <Esc>) with `:h key-notation`
