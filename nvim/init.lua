-- Use space as the global mapleader (set localleader when it becomes necessary)
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- English for notifications etc. (UTF-8 so Japanese can be handled without mojibake)
vim.cmd("language en_US.UTF-8")

-- install lazy.nvim if not present
-- vim.fn.stdpath("data") --> ~/.local/share/nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- path where its going to be installed

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

-- Add my utils to the runtimepath
-- The runtimepath can be printed with the following command --> :lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))
local nvim_config_location = vim.fn.stdpath("config") -- ~/.config/nvim
vim.cmd("set runtimepath^=~" .. nvim_config_location .. "/" .. "lua/utils.lua")

-- add lazy.nvim to the runtime path
vim.opt.rtp:prepend(lazypath)

-- install plugins
require("plugins")

-- Configure non-plugin options (mainly vim.opt)
require("option")

-- Configure autocommands
require("autocommand")

-- Configure color scheme
require("color")

-- Configure custom keymaps
require("keymap")

-- load any vimscript
vim.cmd("source " .. vim.fn.stdpath("config") .. "/lua/vimscript.vim")

-- TODO: Backup all dotfiles not only nvim
-- TODO: When moving to other page with ctrl-s, center view automatically when at bottom of buffer
--[[
-------------------- NVIM --------------------

---------- Lazy ----------

-- where to put plugin definition/settings
plugins can be potentially placed in multiple places.
1. $HOME/.config/nvim/init.lua
    write all in the following line
    require("lazy").setup(plugins_table_here, opts_here)
2. $HOME/.config/nvim/lua/plugins/init.lua
    return {plugins ...} from this files
    in nvim/init.lua use require("lazy").setup("plugin") to specify lua/plugin to be loaded
3. $HOME/.config/nvim/lua/plugins/plugin_name_here.lua
    same as 2, but split in multiple files
    can have 1 file for each plugin or multiple files for grouped plugins such as colorthemes, navigation plugins etc.

-- what fields can be used in the lazy table object
All possible plugin specs are described here ---> https://github.com/folke/lazy.nvim#-plugin-spec


---------- plugin spec implications ----------
- config  (function or bool)
    - emtpy: run require(MAIN).setup(opts) for each plugin where MAIN = plugin's main module
    - true: same as empty, but without opts
    - false: do not setup plugin automatically
- opt  (table or function that return table)
    - table is passed to Plugin.config()


---------- Neovim commands ----------

-- open lazy
:Lazy

-- show parsed syntac tree (TSPlayground)
:InpectTree


---------- Things to add ----------
- tmux-sessionizer
    - https://github.com/jrmoulton/tmux-sessionizer


--]]
