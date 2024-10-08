-----------------------------------------------------------------------------
-- Leader key
-----------------------------------------------------------------------------
vim.g.mapleader = " " -- Space is global mapleader
vim.g.maplocalleader = ","

-----------------------------------------------------------------------------
-- lazy.nvim
-----------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim" -- Ubuntu -> ~/.local/share/lazy/lazy.nvim
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
vim.opt.rtp:prepend(lazypath) -- add lazy.nvim to the runtime path

-----------------------------------------------------------------------------
-- Utils (Add to runtime path)
-----------------------------------------------------------------------------
local nvim_config_location = vim.fn.stdpath("config") -- ~/.config/nvim
vim.cmd("set runtimepath^=~" .. nvim_config_location .. "/" .. "lua/utils.lua")

-----------------------------------------------------------------------------
-- Plugins
-----------------------------------------------------------------------------
require("plugin")

-----------------------------------------------------------------------------
-- Neovim configuration (non-plugin)
-----------------------------------------------------------------------------
require("config")

-----------------------------------------------------------------------------
-- Autocommands (non-plugin)
-----------------------------------------------------------------------------
require("autocommand")

-----------------------------------------------------------------------------
-- Commands (non-plugin)
-----------------------------------------------------------------------------
require("command")

-----------------------------------------------------------------------------
-- Colorscheme
-----------------------------------------------------------------------------
require("color")

-----------------------------------------------------------------------------
-- Keymaps (non-plugin)
-----------------------------------------------------------------------------
require("keymap")

-- TODO: Incorporate tmux-sessionizer - https://github.com/jrmoulton/tmux-sessionizer
