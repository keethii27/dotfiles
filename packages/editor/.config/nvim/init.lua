-- Plugin installation via vim.pack
local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-telescope/telescope.nvim'),
  gh('nvim-lualine/lualine.nvim'),
  gh('hrsh7th/nvim-cmp'),
  gh('hrsh7th/cmp-nvim-lsp'),
  gh('nvim-treesitter/nvim-treesitter'),
  gh('tpope/vim-fugitive'),
  gh('windwp/nvim-autopairs'),
  gh('windwp/nvim-ts-autotag'),
  gh('folke/tokyonight.nvim'),
})

-- Options
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = true
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.belloff = 'all'
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.wildmenu = true
vim.opt.helplang = 'ja'
vim.opt.showmode = false
vim.opt.laststatus = 2
vim.opt.list = true
vim.opt.listchars = { tab = '>>-', trail = '-', extends = '>', precedes = '<', nbsp = '%' }
vim.opt.clipboard:append('unnamed')
vim.opt.mouse = 'a'
vim.opt.inccommand = 'split'
vim.opt.termguicolors = true
vim.opt.completeopt = { 'menuone', 'noinsert', 'noselect' }

-- Persistent undo
local undo_path = vim.fn.expand('~/.config/nvim/undo')
if vim.fn.isdirectory(undo_path) == 0 then
  vim.fn.mkdir(undo_path, 'p')
end
vim.opt.undodir = undo_path
vim.opt.undofile = true

-- Netrw
vim.g.netrw_liststyle = 1
vim.g.netrw_banner = 0
vim.g.netrw_sizestyle = 'H'
vim.g.netrw_timefmt = '%Y/%m/%d(%a) %H:%M:%S'
vim.g.netrw_preview = 1

-- Colorscheme
local ok, _ = pcall(vim.cmd.colorscheme, 'tokyonight')
if not ok then
  vim.cmd.colorscheme('default')
end

-- Keymaps
vim.g.mapleader = ';'

local text_obj_maps = {
  ['8'] = '(', ['2'] = '"', ['7'] = "'", ['@'] = '`', ['['] = '[', ['{'] = '{',
}
for key, char in pairs(text_obj_maps) do
  vim.keymap.set('o', key, 'i' .. char)
  vim.keymap.set('o', 'a' .. key, 'a' .. char)
  vim.keymap.set('n', 'v' .. key, 'vi' .. char)
  vim.keymap.set('n', 'va' .. key, 'va' .. char)
end

vim.keymap.set('n', '<C-l>', 'gt')
vim.keymap.set('n', 'gw[', 'cw``<Esc>P', { silent = true })
vim.keymap.set('v', 'gw[', 'c``<Esc>P', { silent = true })
vim.keymap.set('c', '<C-b>', '<Left>')
vim.keymap.set('c', '<C-f>', '<Right>')
vim.keymap.set('c', '<C-a>', '<Home>')

-- Restore cursor position
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight yanked region
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end,
})

-- Lualine
require('lualine').setup({
  options = {
    theme = 'tokyonight',
    section_separators = '',
    component_separators = '',
  },
})

-- Treesitter
local ts = require('nvim-treesitter')
ts.setup()

local ts_parsers = { 'typescript', 'tsx', 'javascript', 'go', 'lua', 'json', 'html', 'css', 'yaml', 'ruby' }
local installed = ts.get_installed()
for _, lang in ipairs(ts_parsers) do
  if not vim.tbl_contains(installed, lang) then
    ts.install(lang)
  end
end

-- Autopairs
require('nvim-autopairs').setup()

-- Autotag (JSX/HTML)
require('nvim-ts-autotag').setup()

-- Telescope
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files)
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep)
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers)

-- nvim-cmp
local cmp = require('cmp')
cmp.setup({
  sources = {
    { name = 'nvim_lsp' },
  },
  mapping = cmp.mapping.preset.insert({
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})

-- LSP (Neovim built-in)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  root_markers = { 'tsconfig.json', 'package.json', '.git' },
  capabilities = capabilities,
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.mod', '.git' },
  capabilities = capabilities,
})

vim.lsp.enable({ 'ts_ls', 'gopls' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<C-k>', function() vim.diagnostic.jump({ count = -1 }) end, opts)
    vim.keymap.set('n', '<C-j>', function() vim.diagnostic.jump({ count = 1 }) end, opts)
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat_' .. ev.buf, { clear = true }),
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})
