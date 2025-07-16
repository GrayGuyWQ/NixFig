-- Global Neovim Settings
vim.opt.nu = true                 -- Line numbers
vim.opt.relativenumber = true     -- Relative line numbers
vim.opt.tabstop = 2               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 2            -- Size of an indent
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.smartindent = true        -- Smart indentation
vim.opt.hlsearch = true           -- Highlight search results
vim.opt.incsearch = true          -- Incremental search
vim.opt.undofile = true           -- Persistent undo
vim.opt.updatetime = 300          -- Faster completion (ms)
vim.opt.timeoutlen = 500          -- Time to wait for mapped sequence to complete
vim.opt.termguicolors = true      -- Enable true colors
vim.opt.scrolloff = 8             -- Lines of context above/below cursor
vim.opt.isfname:append("@-@")     -- Allow '-' in filenames
vim.opt.signcolumn = "yes"        -- Always show sign column for LSP/diagnostics
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Filetype specific settings (example)
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "nix" },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
  end,
})

-- Colorscheme (make sure you enabled 'dracula-nvim' in home.nix plugins)
vim.cmd("colorscheme dracula")

-- --- Plugin Configuration ---

-- nvim-tree (file explorer)
require("nvim-tree").setup {
  sort_by = "case_sensitive",
  hijack_netrw = true,
  view = {
    width = 30,
    relativenumber = true,
  },
  renderer = {
    group_empty = true,
    icons = {
      glyphs = {
        default = "",
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "✓",
          untracked = "",
          deleted = "",
          renamed = "➜",
          unmerged = "",
          ignored = "",
        },
      },
    },
  },
  filters = {
    dotfiles = true,
    custom = { ".git" },
  },
}
-- Keybinding for nvim-tree: Ctrl+n to toggle
vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- lualine (status line)
require("lualine").setup {
  options = {
    icons_enabled = true,
    theme = "auto", -- or 'dracula', 'tokyonight'
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "NvimTree", "lazy" },
    always_last_status = 2,
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = { "nvim-tree" },
}

-- nvim-cmp (autocompletion)
local cmp = require("cmp")
local luasnip = require("luasnip")
local cmp_nvim_lsp = require("cmp_nvim_lsp")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    -- { name = "buffer" }, -- optional: autocompletion from buffer words
    -- { name = "path" },   -- optional: autocompletion for file paths
  }),
})

-- nvim-lspconfig (Language Server Protocol)
local lspconfig = require("lspconfig")

-- Global mappings for LSP actions
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to Declaration" })
vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to Implementation" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Find References" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })

-- Helper function to attach LSP capabilities to buffer
local on_attach = function(client, bufnr)
  -- Enable completion (from nvim-cmp)
  require("cmp.setup.buffer").on_attach(client, bufnr)

  -- Enable format on save (if formatter is available)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("Format", { clear = true }),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
    })
  end
end

-- Setup individual LSP servers
-- You'll need to have the LSP server installed (via home.packages)
lspconfig.ts_ls.setup({ -- TypeScript/JavaScript
  on_attach = on_attach,
  capabilities = cmp_nvim_lsp.default_capabilities(),
})

lspconfig.pyright.setup({ -- Python
  on_attach = on_attach,
  capabilities = cmp.nvim_lsp.default_capabilities(),
})

lspconfig.nil_ls.setup({ -- Nix Language Server
  on_attach = on_attach,
  capabilities = cmp.nvim_lsp.default_capabilities(),
})

lspconfig.lua_ls.setup({ -- Lua
  on_attach = on_attach,
  capabilities = cmp.nvim_lsp.default_capabilities(),
})

lspconfig.rust_analyzer.setup({ -- Rust
  on_attach = on_attach,
  capabilities = cmp.nvim_lsp.default_capabilities(),
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
    },
  },
})

-- Add other LSP servers here following the same pattern
-- lspconfig.gopls.setup({})
-- lspconfig.clangd.setup({})
-- lspconfig.marksman.setup({})


-- nvim-treesitter (Syntax highlighting and more)
require("nvim-treesitter.configs").setup {
  -- A list of parser names, or "all" (the five listed parsers should always be installed)
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "bash", "json", "nix", "python", "typescript", "javascript", "html", "css", "markdown", "rust", "go" },

  -- Install parsers synchronously (only for first time install)
  sync_install = false,

  -- Automatically install missing parsers when entering a buffer
  auto_install = true,

  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, },
  -- textobjects = { enable = true, }, -- Uncomment if you install nvim-treesitter-textobjects
}

-- For vim-fugitive (Git plugin), no specific Lua config often needed, it just works.
-- For nvim-web-devicons, it integrates with plugins like nvim-tree and lualine automatically.

-- --- Example Keybindings (beyond LSP) ---
vim.api.nvim_set_keymap("n", "<leader>pv", ":NvimTreeToggle<CR>", { noremap = true, silent = true, desc = "Toggle NvimTree" })
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true, desc = "Find files" })
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true, desc = "Live Grep" })

-- Add a leader key (default is \)
vim.g.mapleader = " " -- Use space as leader key

-- Set diagnostic signs (icons next to line numbers)
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = false,
  severity_sort = true,
})
