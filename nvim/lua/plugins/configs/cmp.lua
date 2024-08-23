-- tj explaining nvim-cmp on youtube ---> https://www.youtube.com/watch?v=_DnmphIwnjo

-- TODO: For command autocompletion, do not interfere with trying to go through history of commands

local cmp = require("cmp")
local lspkind = require("lspkind")
local luasnip = require("luasnip")
local cmp_action = require("lsp-zero").cmp_action()

---------------------------------------- LUASNIP ----------------------------------------

-- Add custom snippet to luasnip
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local function fn(args, parent, user_agent)
    return args[1][1] -- because lua is 1-indexed
end

-- Check current filetype(s) with
-- :lua print(vim.inspect(require("luasnip").get_snippet_filetypes()))

luasnip.add_snippets(nil, {
    typescriptreact = {
        s({ trig = "function", desc = "function without parameter placeholder" }, {
            t("function "),
            i(1, "name"),
            t("("),
            i(2, ""),
            t({
                ") {",
                "    ",
            }),
            i(3, ""),
            t({
                "",
                "}",
            }),
        }),

        s({ name = "lugen4ro", trig = "import", desc = "import module" }, {
            t("import "),
            i(1, ""),
            t(' from "'),
            i(2, ""),
            t('";'),
        }),

        s({ name = "lugen4ro interface", trig = "interface", desc = "Create props interface" }, {
            t({
                "interface Props {",
                "    ",
            }),
            i(1, ""),
            t({ "", "}" }),
        }),

        s({ name = "lugen4ro props destructure", trig = "prop", desc = "Destructure props" }, {
            t("{ "),
            i(1, ""),
            t(" } : Props"),
        }),
    },

    cpp = {
        -- s({trig = "MAIN", desc = "main() template)"}, {
        --     t({
        --         "// #",
        --         "",
        --         "int main() {",
        --         "    // --- Input ---",
        --         "    ",
        --     }),
        --     i(0, ""),
        --     t({
        --         "",
        --         "    ",
        --         "    // --- Process ---",
        --         "    ",
        --         "}"
        --     }),
        -- }),

        s({ trig = "REP", desc = "REP(i,N) -> 0 .. N-1" }, {
            t("REP("),
            i(1, "i"),
            t(", "),
            i(2, "N"),
            t(") "),
        }),

        s({ trig = "RREP", desc = "RREP(i,N) -> N-1 . 0)" }, {
            t("RREP("),
            i(1, "i"),
            t(", "),
            i(2, "N"),
            t(") "),
        }),

        s({ trig = "PRINT", desc = "PRINT(x, ...)" }, {
            t("PRINT("),
            i(1, "x"),
            t(");"),
        }),

        s({ trig = "DEBUG", desc = "DEBUG(x, ...)" }, {
            t("DEBUG("),
            i(1, "x"),
            t(");"),
        }),

        s({ trig = "V", desc = "Short for vector" }, {
            t("V<"),
            i(1, ""),
            t(">"),
        }),

        s({ trig = "ALL", desc = "ALL(v)" }, {
            t("ALL("),
            i(1, "v"),
            t(")"),
        }),

        s({ trig = "BC", desc = "BC(var, lower_inc, upper_exc)" }, {
            t("BC("),
            i(1, "var"),
            t(", "),
            i(2, "lower_inc"),
            t(", "),
            i(3, "upper_exc"),
            t(")"),
        }),

        s({ trig = "HAS", desc = "HAS(s, k) -> Set s has key k" }, {
            t("HAS("),
            i(1, "s"),
            t(", "),
            i(2, "k"),
            t(")"),
        }),

        s({ trig = "INT", desc = "INT(x, ...)" }, {
            t("INT("),
            i(1, "x"),
            t(");"),
        }),

        s({ trig = "LL", desc = "LL(x, ...)" }, {
            t("LL("),
            i(1, "x"),
            t(");"),
        }),

        s("ternary", {
            -- equivalent to "${1:cond} ? ${2:then} : ${3:else}"
            i(1, "cond"),
            t(" ? "),
            i(2, "then"),
            t(" : "),
            i(3, "else"),
        }),

        ---------- VECTOR ----------

        -- vector initialize
        s({ trig = "v1", name = "1D vector" }, {
            t("V<"),
            i(1, "int"),
            t("> "),
            i(2, "v"),
            t("("),
            i(3, "N"),
            t(");"),
        }),

        -- vector 2d initialize
        s({ trig = "v2", name = "2D vector" }, {
            t("V<V<"),
            i(1, "int"),
            t(">> "),
            i(2, "v"),
            t("("),
            i(3, "N"),
            t(", V<"),
            f(fn, { 1 }),
            t(">("),
            i(4, "N"),
            t("));"),
        }),

        -- vector 3d initialize
        s({ trig = "v3", name = "3D vector" }, {
            t("V<V<V<"),
            i(1, "int"),
            t(">>> "),
            i(2, "v"),
            t("("),
            i(3, "N"),
            t(", V<V<"),
            f(fn, { 1 }),
            t(">>("),
            i(4, "N"),
            t(", V<"),
            f(fn, { 1 }),
            t(">("),
            i(4, "N"),
            t(")));"),
        }),
    },
})

-- Setup plugin snippets after my personal snippets such that their snippet ids ar higher
-- Then, prioritize snippets with lower snippet ids in the comparator of nvim-cmp

-- Use existing VS Code style snippets from a plugin
require("luasnip.loaders.from_vscode").lazy_load()
-- Load custom VSCode style snippets from path/of/your/nvim/config/<path>
--require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./lua/plugins/configs/snippets_cpp.json" }})

---------------------------------------- CMP ----------------------------------------

local lsp_types = require("cmp.types").lsp

lspkind.init({
    symbol_map = {
        Copilot = "",
    }
})

-- Set copilot source color
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#F7F200" })

Counter = 0 -- global


-- Unlike other completion sources, copilot can use other lines above or below an empty line to provide a completion.
-- This can cause problematic for individuals that select menu entries with <TAB>.
-- This behavior is configurable via cmp's config and the following code will make it so that the menu still appears normally,
-- but tab will fallback to indenting unless a non-whitespace character has actually been typed.
local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

-- Setup autocomplete
cmp.setup({

    mapping = cmp.mapping.preset.insert({

        -- Tab key to confirm completion
        ["<Tab>"] = cmp.mapping.confirm({ select = false }),
        -- ["<Tab>"] = vim.schedule_wrap(function(fallback)
        --     if cmp.visible() and has_words_before() then
        --         cmp.confirm()
        --     else
        --         fallback()
        --     end
        -- end),

        -- Ctrl+Space to trigger completion menu
        ["<C-Space>"] = cmp.mapping.complete(),
        -- ["<C-s>"] = cmp.mapping.complete(), -- suggestions
        ["<C-s>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.close()
            else
                cmp.complete()
            end
        end, { "i", "c" }),

        -- Navigate between snippet placeholder
        ["<C-f>"] = cmp_action.luasnip_jump_forward(),
        ["<C-b>"] = cmp_action.luasnip_jump_backward(),

        -- Scroll up and down in the completion documentation
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
    }),

    sources = cmp.config.sources(
    -- cmp.config.sources allows specifying groups
    -- if a group has no match, only then could a source of the next group be possibly shown
    -- within the group, the suggestions are in the same order os the sources

    -- keyword_length --> how many characters to input before autocompletion kicks in
    -- priority --> priority of loading. overwrites the written order priority
    -- max_item_count --> max item count from 1 source

    -- [From cmp docs]
    -- Each item's original priority (given by its corresponding source) will be
    -- increased by `#sources - (source_index - 1)` and multiplied by `priority_weight`.
    -- That is, the final priority is calculated by the following formula:
    -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)

        {
            -- Copilot
            { name = "copilot",  group_index = 1 },

            -- Prioritize snippets
            { name = "luasnip",  group_index = 1 },

            -- Uses LSP to provide auto-completions for
            -- variable_names, function_names etc. below the root directory (not only current file)
            { name = "nvim_lsp", group_index = 1, max_item_count = 20 },

            -- Auto-complete any path (you don't have to exit vi or use command to check path)
            { name = "path",     group_index = 1 },

            -- Auto-complete any existing word in the open buffers (not only current buffer)
            {
                name = "buffer",
                keyword_length = 3,
                max_item_count = 10,
                group_index = 2,

                -- Get suggestions from all open buffers
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            },
        }
    ),

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    formatting = {
        -- [buf] etc. are source markers that are shown with the suggestions so we know where it comes from
        format = lspkind.cmp_format({
            -- mode = "symbol_text",
            mode = "symbol",
            with_text = true,
            ellipsis_char = "…",
            menu = {
                luasnip  = "[SNIP]", -- snippets from luasnip
                nvim_lsp = "[LSP]",  -- from each lsp
                path     = "[PATH]", -- for file path
                buffer   = "[BUF]",  -- buffer words
                copilot  = "[GHCP]", -- GitHub Copilot
            },
        }),
    },

    ---------- Sorting ----------
    -- Sorting the order candidates are shown

    --[[
    -- Example of 'entry.completion_item' passed to comparator function from cmp_luasnip --> this is a luasnip item. Other source items have completely different contents.
    -- In vscode style, label and word here are both equal to prefix in json, and json label is first value in documentation.value
    {
        data = {
            auto = false,
            filetype = "cpp",
            show_condition = <function 1>,
            snip_id = 60
        },
        documentation = {
            kind = "markdown",
            value = "REP_LABEL _ `[cpp]`\n---\n[gen4ro] REP(i, N)\n\n```cpp\nREP(${1:i}, ${2:N}) {\n\t$0\n}\n```"
        },
        kind = 15,
        label = "REP_PREFIX",
        word = "REP_PREFIX"
    }
    ]]

    -- All builtin comparators
    -- https://github.com/hrsh7th/nvim-cmp/blob/538e37ba87284942c1d76ed38dd497e54e65b891/lua/cmp/config/compare.lua
    -- Earlier ones are prioritized. If same priority, look at next comparator.
    -- In essence, is a funciton that retruns true if first of 2 is prioritiezed, false if second is, nil if no equal
    -- A custom comparator is just the function you have to pass to the lua library table.sort(mytable, myfunction)
    -- The function takes two args, and has to return true if the left should come earlier.
    -- It seems to also try reverse order so --> arg1, arg2 then arg2, arg1
    -- Therefore, this function has to have consisten behaviour meaning if returning true for arg1,arg2, it must return false (not nil) for arg2,arg1
    -- sorting = {
    --     priority_weight = 2,
    --     comparators = {
    --
    --         cmp.config.compare.offset, -- Index of where the matching starts to begin ex) myhello < "hello" offset is 2
    --
    --         -- TODO: Insead of limiting inside the comparator to only apply for c++, create autocommands to change the settings depending on the buffer type
    --         -- -- For C++, Prioritize Snippets (Don't want to change above global settings for all languges...)
    --         -- function(entry1, entry2)
    --         --     -- Only apply this comparator for cpp files
    --         --     local d1 = entry1.completion_item.data
    --         --     local d2 = entry2.completion_item.data
    --         --     if not ((d1 ~= nil and d1.filetype == "cpp") or (d2 ~= nil and d2.filetype == "cpp")) then
    --         --         return nil
    --         --     end
    --         --
    --         --     local s1 = entry1.source.name
    --         --     local s2 = entry2.source.name
    --         --
    --         --     if s1 == "luasnip" and s2 ~= "luasnip" then
    --         --         return true
    --         --     elseif s1 ~= "luasnip" and s2 == "luasnip" then
    --         --         return false
    --         --     end
    --         --     return nil
    --         -- end,
    --         --
    --         -- -- For snippets, prioritize lower ids --> my own custom snippets over plugin snippets
    --         -- -- Within my custom snippets, earlier appearing snippets will also be prioritied
    --         -- -- !! Snippet id for custom snippets in vscode style json file is not in order of definition and changes every time causing unpredictable behaviour...
    --         -- -- !! But, snippets defined here in lua are in snippet_id order of definition so use that property
    --         -- function(entry1, entry2)
    --         --     -- Only apply this comparator for cpp files
    --         --     local d1 = entry1.completion_item.data
    --         --     local d2 = entry2.completion_item.data
    --         --     if d1 == nil or d2 == nil or d1.filetype ~= "cpp" or d2.filetype ~= "cpp" then
    --         --         return nil
    --         --     end
    --         --
    --         --     -- Only apply on snippets
    --         --     if entry1.source.name ~= "luasnip" or entry2.source.name ~= "luasnip" then
    --         --         return nil
    --         --     end
    --         --
    --         --     local id1 = entry1.completion_item.data.snip_id
    --         --     local id2 = entry2.completion_item.data.snip_id
    --         --
    --         --     -- Prioritize lower snip id
    --         --     if id1 ~= id2 then
    --         --         return id1 < id2
    --         --     end
    --         --     return nil
    --         -- end,
    --
    --         -- Entries with higher score will be ranked higher
    --         -- diff = entry2.score - entry1.score
    --         -- This probably is using the the following score calculated from priority value/weight set for each source and sorting
    --         -- final_score = orig_score + ((#sources - (source_index - 1)) * sorting.priority_weight)
    --         cmp.config.compare.score,
    --
    --         -- exact to the capitalization --> input = all --> prioritize "all" over "ALL"
    --         cmp.config.compare.exact,
    --
    --         cmp.config.compare.recently_used,
    --         cmp.config.compare.locality,
    --         cmp.config.compare.kind,
    --         cmp.config.compare.sort_text,
    --         cmp.config.compare.length,
    --         cmp.config.compare.order,
    --     },
    -- },
    sorting = {
        priority_weight = 2,
        comparators = {
            require("copilot_cmp.comparators").prioritize,

            -- Below is the default comparitor list and order for nvim-cmp
            cmp.config.compare.offset,
            -- cmp.config.compare.scopes, --this is commented in nvim-cmp too
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },


    experimental = {
        -- use new menu
        native_menu = false,
    },

    completion = {
        preselect = "item",
        -- select first item by default
        completeopt = "menu,menuone,noinsert",
    },
})

-- cmd.setup() is for insert mode. For command mode set here
local cmdline_mapping = {
    ["<Down>"] = {
        c = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end,
    },
    ["<Up>"] = {
        c = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end,
    },
    ["<C-s>"] = { c = cmp.mapping.complete() }, -- suggestions
    ["<C-c>"] = { c = cmp.mapping.abort() },
    ["<tab>"] = { c = cmp.mapping.confirm({ select = false }) },
}

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
    mapping = cmdline_mapping,
    sources = {
        { name = "buffer" },
    },
})

-- `?` cmdline setup.
cmp.setup.cmdline("?", {
    mapping = cmdline_mapping,
    sources = {
        { name = "buffer" },
    },
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
        { name = "path" },
    }, {
        { name = "cmdline" },
    }),
})


-- Neogen for adding annotations
require("neogen").setup({ snippet_engine = "luasnip" })
