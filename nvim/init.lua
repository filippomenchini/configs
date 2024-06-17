local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
local uv = vim.uv or vim.loop

-- Auto-install lazy.nvim if not present
if not uv.fs_stat(lazypath) then
	print('Installing lazy.nvim....')
	vim.fn.system({
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	})
	print('Done.')
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	-- Mason for LSPs
	{ 'williamboman/mason.nvim' },
	{ 'williamboman/mason-lspconfig.nvim' },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
	},
	-- LSP Support
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{ 'hrsh7th/cmp-nvim-lsp' },
		}
	},
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{ 'L3MON4D3/LuaSnip' }
		},
	},
	-- Telescope
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	-- Autoclose
	{ 'm4xshen/autoclose.nvim' },
	-- Trouble
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	-- Catpuccin
	{ "catppuccin/nvim",       name = "catppuccin", priority = 1000 },
	-- Oil
	{
		'stevearc/oil.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
})

-- Set line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Share system clipboard
vim.opt.clipboard = 'unnamedplus'

-- Set space as leader key
vim.g.mapleader = " "

-- Set gutter color
vim.cmd [[highlight SignColumn ctermbg=black]]

-- Set column color
vim.cmd [[set colorcolumn=80]]
vim.cmd [[highlight ColorColumn ctermbg=59]]

---
-- LSP setup
---
local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
	lsp_zero.buffer_autoformat()
end)

---
-- Dart LSP Setup
---
require('lspconfig').dartls.setup({
	cmd = { "/usr/bin/dart", 'language-server', '--protocol=lsp' },
})

require('mason').setup({})
require('mason-lspconfig').setup({
	handlers = {
		lsp_zero.default_setup,
	}
})

---
-- Autocompletion config
---
local cmp = require('cmp')
local cmp_action = lsp_zero.cmp_action()

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		-- `Enter` key to confirm completion
		['<CR>'] = cmp.mapping.confirm({ select = true }),

		-- Ctrl+Space to trigger completion menu
		['<C-Space>'] = cmp.mapping.complete(),

		-- Navigate between snippet placeholder
		['<C-f>'] = cmp_action.luasnip_jump_forward(),
		['<C-b>'] = cmp_action.luasnip_jump_backward(),

		-- Scroll up and down in the completion documentation
		['<C-u>'] = cmp.mapping.scroll_docs(-4),
		['<C-d>'] = cmp.mapping.scroll_docs(4),
	})
})

---
-- Telescope config
---
local telescope = require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fc', builtin.commands, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

---
-- Tabs config
---
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', {})
vim.keymap.set('n', '<leader>tc', ':tabc<CR>', {})
vim.keymap.set('n', '<leader>tl', ':tabn<CR>', {})
vim.keymap.set('n', '<leader>th', ':tabp<CR>', {})

---
-- Terminal
---
vim.keymap.set('n', '<leader>sh', ':terminal<CR>', {})

---
-- Setup autoclose
---
require("autoclose").setup()

---
-- Setup trouble
---
vim.keymap.set("n", "<leader>tt", function() require("trouble").toggle() end)

---
-- Setup catppuccin
---
require("catppuccin").setup({
	flavour = "mocha",
	transparent_background = true,
})
vim.cmd([[colorscheme catppuccin]])

---
-- Setup oil
---
require("oil").setup()
vim.keymap.set('n', '<leader>oo', ':Oil<CR>', {})
