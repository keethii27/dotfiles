-- リーダーキーは <leader> を使うキー割り当てより前に設定する必要がある
vim.g.mapleader = ' '

-- オプション
vim.opt.number = true
vim.opt.cursorline = true
-- Git やエラーの印の表示で本文がずれないよう、印の列を常に表示する
vim.opt.signcolumn = 'yes'
vim.opt.list = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.termguicolors = true
vim.opt.undofile = true
-- Git の変更の印などを、既定の 4 秒より早く更新する
vim.opt.updatetime = 250
-- モードは lualine に表示されるため非表示にする
vim.opt.showmode = false

-- これらの言語で書かれたプラグインは使っていないため、連携を無効にする
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- gopls は Go テンプレートも扱うが、Neovim は標準ではこのファイル種別を知らないため登録する
vim.filetype.add({ extension = { gotmpl = 'gotmpl' } })

-- 前回のカーソル位置を復元する
vim.api.nvim_create_autocmd('BufReadPost', {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- コピーした範囲をハイライトする
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank({ timeout = 200 })
  end,
})

-- プラグイン（vim.pack でインストール）
local gh = function(x) return 'https://github.com/' .. x end

vim.pack.add({
  -- 配色
  gh('folke/tokyonight.nvim'),
  -- 画面表示
  gh('nvim-lualine/lualine.nvim'),
  gh('folke/which-key.nvim'),
  gh('lewis6991/gitsigns.nvim'),
  gh('nvim-tree/nvim-web-devicons'),
  gh('MunifTanjim/nui.nvim'),
  { src = gh('nvim-neo-tree/neo-tree.nvim'), version = vim.version.range('3.*') },
  -- 編集
  gh('nvim-treesitter/nvim-treesitter'),
  gh('windwp/nvim-autopairs'),
  gh('windwp/nvim-ts-autotag'),
  -- 検索
  gh('nvim-lua/plenary.nvim'),
  gh('nvim-telescope/telescope.nvim'),
  -- 入力補完と LSP
  { src = gh('saghen/blink.cmp'),            version = vim.version.range('1.*') },
  gh('neovim/nvim-lspconfig'),
})

-- 配色
vim.cmd.colorscheme('tokyonight')

-- lualine（ステータスライン）
require('lualine').setup()

-- which-key（キーを押し始めると、続けて押せるキーを表示）
require('which-key').setup()

-- gitsigns（Git の変更を行番号の横に表示）
require('gitsigns').setup()

-- neo-tree（ファイルツリー）
-- VS Code に合わせ、隠しファイルと .gitignore の対象は薄い色で表示し、.git と .DS_Store は表示しない
require('neo-tree').setup({
  filesystem = {
    filtered_items = {
      visible = true,
      never_show = { '.git', '.DS_Store' },
    },
  },
})
vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>', { desc = 'Toggle file tree' })

-- treesitter（構文解析）
local ts = require('nvim-treesitter')
ts.setup()

local ts_parsers = { 'typescript', 'tsx', 'javascript', 'go', 'lua', 'json', 'html', 'css', 'yaml', 'ruby', 'bash' }
local installed = ts.get_installed()
for _, lang in ipairs(ts_parsers) do
  if not vim.tbl_contains(installed, lang) then
    ts.install(lang)
  end
end

-- nvim-treesitter は自動で色分けを有効にしないため有効にする。解析器がないファイル種別は pcall でスキップする
vim.api.nvim_create_autocmd('FileType', {
  callback = function() pcall(vim.treesitter.start) end,
})

-- autopairs（括弧を自動で閉じる）
require('nvim-autopairs').setup()

-- autotag（JSX / HTML のタグを自動で閉じる）
require('nvim-ts-autotag').setup()

-- telescope（ファイル・文字列検索）
-- VS Code に合わせ、隠しファイルは検索し、.gitignore の対象と .git、.DS_Store は検索しない
require('telescope').setup({
  defaults = {
    -- %.git/ は入れ子のリポジトリ（サブモジュールなど）の .git にも一致する。.github/ には一致しない
    file_ignore_patterns = { '%.git/', '%.DS_Store$' },
  },
  pickers = {
    find_files = { hidden = true },
    live_grep = { additional_args = { '--hidden', '--glob', '!.git/' } },
  },
})
local telescope_builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>fb', telescope_builtin.buffers, { desc = 'Buffers' })

-- 入力補完
require('blink.cmp').setup()

-- LSP
-- サーバーの設定は nvim-lspconfig のものを使う。キー割り当ては Neovim 標準（K、grn、gra、grr、[d、]d など）をそのまま使う
vim.lsp.config('*', { capabilities = require('blink.cmp').get_lsp_capabilities() })
-- この設定ファイルの編集で Neovim の API を補完できるよう、lua_ls に Neovim の実行環境を読み込ませる
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      workspace = { library = { vim.env.VIMRUNTIME } },
    },
  },
})
vim.lsp.enable({ 'ts_ls', 'gopls', 'ruby_lsp', 'lua_ls' })

-- エラーの内容を行末に表示する（Neovim 0.11 から標準では表示されない）
vim.diagnostic.config({ virtual_text = true })

-- LSP の接続時に、gd で定義へ移動できるようにし、保存時に自動整形する
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf })

    -- 整形に対応していない LSP では、保存のたびに警告が出ないよう登録しない
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not (client and client:supports_method('textDocument/formatting')) then
      return
    end

    vim.api.nvim_create_autocmd('BufWritePre', {
      group = vim.api.nvim_create_augroup('LspFormat_' .. ev.buf, { clear = true }),
      buffer = ev.buf,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end,
})
