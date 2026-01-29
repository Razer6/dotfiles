-- --- 1. Basic Settings ---
vim.g.mapleader = " "           -- Set Space as your leader key
vim.opt.number = true           -- Show line numbers
vim.opt.relativenumber = true   -- Relative line numbers (great for jumping)
vim.opt.mouse = 'a'             -- Enable mouse support
vim.opt.ignorecase = true       -- Case-insensitive searching
vim.opt.smartcase = true        -- ...until you use a capital letter
vim.opt.shiftwidth = 4          -- Size of an indent
vim.opt.tabstop = 4             -- Number of spaces tabs count for
vim.opt.expandtab = true        -- Convert tabs to spaces
vim.opt.termguicolors = true    -- True color support

-- --- 2. Bootstrap Lazy.nvim ---
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- --- 3. Load Plugins ---
require("lazy").setup({
  -- UI / Theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- Treesitter (Better Syntax Highlighting)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Try to load the module safely
      local status, configs = pcall(require, "nvim-treesitter.configs")
      if not status then 
          return -- Exit early if plugin isn't actually on disk yet
      end

      local function load_ts_langs()
        local langs = { "lua", "vim", "vimdoc", "query" }
        local path = vim.fn.stdpath("config") .. "/treesitter.txt"
        local f = io.open(path, "r")
        if f then
          for line in f:lines() do
            local l = line:gsub("%s+", "")
            if l ~= "" and not l:find("^#") then table.insert(langs, l) end
          end
          f:close()
        end
        return langs
      end
  
      configs.setup({
        ensure_installed = load_ts_langs(),
        highlight = { enable = true },
        indent = { enable = true },
      })
    end
  },

  -- Telescope (Fuzzy Finder)
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },

  -- File Explorer
  { "nvim-tree/nvim-web-devicons" },
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- LSP Support
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    dependencies = {
      --- Managed LSP servers
      {'williamboman/mason.nvim'},
      {'williamboman/mason-lspconfig.nvim'},

      --- LSP Support
      {'neovim/nvim-lspconfig'},
      --- Autocompletion
      {'hrsh7th/nvim-cmp'},
      {'hrsh7th/cmp-nvim-lsp'},
      {'L3MON4D3/LuaSnip'},
    }
  },
  { "folke/which-key.nvim", lazy = true },

  -- Format on save
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        bazel = { "buildifier" },
        -- rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
})

-- --- 4. Post-Plugin Config ---
vim.cmd.colorscheme "catppuccin"
require('lualine').setup()

-- --- 5. Keybindings ---
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {}) -- Find files
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})  -- Search inside files
vim.keymap.set('n', '<leader>e', ':Ex<CR>', {})           -- Open File Explorer

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- Standard keybindings for LSP
  -- 'K' opens documentation in a hover window
  -- 'gd' goes to definition
  lsp_zero.default_keymaps({buffer = bufnr})
end)

-- Function to read languages from a file
local function load_languages()
  local languages = {}
  -- Get the path to the config directory
  local config_path = vim.fn.stdpath("config")
  local file_path = config_path .. "/lsp-languages.txt"

  local f = io.open(file_path, "r")
  if f then
      for line in f:lines() do
      -- Strip whitespace and ignore empty lines/comments
      local lang = line:gsub("%s+", "")
      if lang ~= "" and not lang:find("^#") then
          table.insert(languages, lang)
      end
      end
      f:close()
  end
  return languages
end

-- Setup Mason with the dynamic list
require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = load_languages(),
  handlers = {
    lsp_zero.default_setup,
  },
})

-- Recognize Bazel files
vim.filetype.add({
  extension = {
    bzl = 'bazel',
  },
  filename = {
    ['BUILD'] = 'bazel',
    ['WORKSPACE'] = 'bazel',
    ['BUILD.bazel'] = 'bazel',
    ['WORKSPACE.bazel'] = 'bazel',
  },
})
