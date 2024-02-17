-- For it to work with C++ you have to compile with debug symbols!!!
-- g++ -O0 -g ...
-- clang++-17 -O0 -g ...

-------------------- Install DAPs --------------------

-- We have to setup mason before mason-nvim-dap
require("mason").setup()

-- Only automatically install DAP with mason-nvim-dap, no configuration
require("mason-nvim-dap").setup({

    -- full list is here
    -- Pay attention to the name specified in ensure_installed which are different from the dap name
    -- The Keys can be found here
    -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/source.lua
    ensure_installed = {
        "codelldb", -- codelldb for C++, Rust
        "python", -- debugpy for Python
    },

    -- Do not use mason-nvim-dap configurations
    -- handlers = {}, <--- this would set up dap with mason-nvim-dap defaults
    handlers = nil,
})

-------------------- Configure DAP --------------------
local dap = require("dap")

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        -- for me, vim.fn.stdpath = "/home/gen4ro/.local/share/nvim"
        command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
        args = { "--port", "${port}" },
    },
}

dap.adapters.debugpy = {
    type = "executable",
    command = vim.fn.exepath("debugpy-adapter"),
}

----- Utility functions

local function filename_path_wihtout_extension(file_path)
    -- -- get current file name
    -- local cur_file = vim.fn.expand("%:t")

    -- find dot location if it exists
    local dot_location = -1
    for i = string.len(file_path), 1, -1 do
        if file_path:sub(i, i) == "." then
            -- found the dot!
            dot_location = i
            break
        elseif file_path:sub(i, i) == "/" then
            -- no dot in filename
            break
        end
    end

    -- Return file name without extension (original if no dot exists)
    if dot_location ~= -1 then
        return file_path:sub(0, dot_location - 1)
    else
        return -1
    end
end

-- Check if a file with same filename but wihout extension exists
local function noext_filname_exists()
    -- get current file name
    local cur_file = vim.fn.expand("%:t")

    -- find dot location if it exists
    local dot_location = -1
    for i = string.len(cur_file), 1, -1 do
        if cur_file:sub(i, i) == "." then
            dot_location = i
            break
        end
    end

    -- Return file name without extension (original if no dot exists)
    if dot_location ~= -1 then
        local file_path = vim.fn.expand("%:p:h") .. "/" .. cur_file:sub(0, dot_location - 1)

        -- check if file exists
        local f = io.open(file_path, "r")
        if f ~= nil then
            io.close(f)
            return file_path
        end
    end
    return ""
end

local function compile()
    -- Get current file path
    local file_path = vim.fn.expand("%:p") -- :p:h (current directory abs path) :t (current file name)

    -- Get file path without extension (output file of compilation)
    local output_file_path = filename_path_wihtout_extension(file_path)

    -- Compile
    vim.cmd("silent !g++ -O0 -g " .. file_path .. " -o " .. output_file_path)
    -- vim.cmd("silent !clang++-17 -O0 -g " .. file_path .. " -o " .. output_file_path)

    return output_file_path
end

local function create_summary_string(type, max_shown_elements)
    local s = [[type summary add --summary-string "\[{${var[0]}}]]
    for i = 1, max_shown_elements - 1 do
        s = s .. [[{, ${var[]] .. i .. [[]}}]]
    end
    -- need to check var[max_shown_elements] to check if sth. exists so we can add ...
    -- %v for showing nothing didn't work, so let's just show the type
    s = s .. [[{ ... (${var[]] .. max_shown_elements .. [[%T})}\]" -x "std::]] .. type .. [[<"]]
    return s
end

-- Order Matters!!! Inner level items should come first
local function get_init_commands()
    local initCommands = {}

    -- point (my custom type)
    table.insert(initCommands, [[type summary add --summary-string "{(${var.x}, ${var.y})}" "point"]])

    -- pair
    table.insert(initCommands, [[type summary add --summary-string "{(${var.first}, ${var.second})}" -x "std::pair<"]])

    -- vector
    table.insert(initCommands, create_summary_string("vector", 20))

    -- set
    table.insert(initCommands, create_summary_string("set", 20))

    -- unordered set
    -- table.insert(initCommands, create_summary_string("unordered_set", 20))

    -- deque
    table.insert(initCommands, create_summary_string("deque", 20))

    -- tuple
    table.insert(initCommands, create_summary_string("tuple", 20))

    -- bitset
    table.insert(initCommands, create_summary_string("bitset", 20))

    -- queue (made up of deque)
    table.insert(initCommands, [[type summary add --summary-string "{${var.c}}" -x "std::queue<"]])

    -- stack (made up of deque)
    table.insert(initCommands, [[type summary add --summary-string "{${var.c}}" -x "std::stack<"]])

    -- priority_queue (made up of vector)
    table.insert(initCommands, [[type summary add --summary-string "{${var.c}}" -x "std::priority_queue<"]])

    return initCommands
end

dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",

        -- compile program and pass that
        program = compile,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,

        -- Input from file
        -- You specify [input, output, error]
        -- If less than 3, populates the remainder with the last value
        stdio = { "input", nil, nil },
        args = {},
        -- showDisassembly = "never", -- doesnt work
        initCommands = get_init_commands(),
    },
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = "debugpy",
        request = "launch",
        name = "Python: Launch file",
        program = "${file}", -- run current file
    },
}

-------------------- Other --------------------

-- gen4ro comments
-- highlight_new_as_changed and highlight_changed_variables works for Python, but not for C++
-- For C++, it does not detect change, and every variable is highlighted at highlight_new_as_changed
-- For C++, all_frame = false, still shows variables on all frames
-- C++ constructors using variables as args like vector<int> v(n); will be seen as function definitions by treesitter-cpp and as such, won't show virtual text...
-- Appearently it's a tressitter issue, but cannot be fixed without semantics, which are not handled by treesitter... so bad luck

-- Show virtual text in-line that shows variable values etc.
require("nvim-dap-virtual-text").setup({
    enabled = true, -- enable this plugin (the default)
    enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed = true, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason = true, -- show stop reason when stopped for exceptions
    commented = false, -- prefix virtual text with comment string
    only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
    all_references = true, -- show virtual text on all all references of the variable (not only definitions)
    clear_on_continue = false, -- clear virtual text on "continue" (might cause flickering when stepping)

    --- A callback that determines how a variable is displayed or whether it should be omitted
    --- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
    --- @param buf number
    --- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
    --- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
    --- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
    --- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
    display_callback = function(variable, buf, stackframe, node, options)
        if options.virt_text_pos == "inline" then
            return " = " .. variable.value
        else
            return " " .. variable.name .. " = " .. variable.value
        end
    end,
    -- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
    virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",

    -- experimental features:
    all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
    virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
    --virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
    virt_text_win_col = 80, -- position the virtual text at a fixed window column (starting from the first text column) ,
    -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
})

-- Change Virtual Text Color (highlightgroup)

-- Set directly
--vim.cmd("highlight NvimDapVirtualTextChanged guibg=#322800")

-- Link to existing group to inherit style
--vim.cmd("highlight link NvimDapVirtualTextChanged @character")

-- dapui for nicer ui
-- setting up listeners so dapui gets automatically started/terminated
local dapui = require("dapui")
dapui.setup({
    expand_lines = true,
    icons = { expanded = "", collapsed = "" },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.7 },
                { id = "watches", size = 0.3 },
            },
            size = 0.25,
            position = "bottom",
        },
        -- {
        --     elements = {
        --         --{ id = "watches", size = 0.20 },
        --         { id = "scopes", size = 0.40 },
        --         --{ id = "stacks", size = 0.20 }, -- Displays the running threads and their stack frames.
        --         --{ id = "breakpoints", size = 0.20 }, -- List all breakpoints currently set.
        --     },
        --     size = 0.25,
        --     position = "left",
        -- },
        -- {
        --     elements = {
        --         "repl",
        --         "console",
        --     },
        --     size = 0.10,
        --     position = "bottom",
        -- },
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

vim.fn.sign_define(
    "DapBreakpoint",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapBreakpointCondition",
    { text = "", texthl = "DapBreakpointCondition", linehl = "DapBreakpointCondition", numhl = "DapBreakpointCondition" }
)
vim.fn.sign_define(
    "DapBreakpointRejected",
    { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
)
vim.fn.sign_define(
    "DapLogPoint",
    { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
)
vim.fn.sign_define("DapStopped", { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" })
