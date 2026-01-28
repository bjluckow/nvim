-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "mason-org/mason.nvim", lazy = false, opts = {} },
  
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
      })

      -- Go
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            staticcheck = true,
          },
        },
      })

      vim.lsp.enable("pyright")
      vim.lsp.enable("gopls")
    end,
},

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
    require("nvim-tree").setup()
    vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  {
    "stevearc/conform.nvim",
    config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "black", "isort" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact   = { "prettier" },
      },
      format_on_save = true,
      })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
  },
  }
})


vim.opt.number = true
vim.opt.scrolloff = 999
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2 
vim.opt.softtabstop = 2

vim.opt.updatetime = 300
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = { lnum = vim.api.nvim_win_get_cursor(0)[1] - 1 }
    if #vim.diagnostic.get(0, opts) > 0 then
      vim.diagnostic.open_float(nil, { focus = false })
    end
  end,
})

-- tree
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function(data)
    local directory = vim.fn.isdirectory(data.file) == 1
    if directory then
      vim.cmd.cd(data.file)
      require("nvim-tree.api").tree.open()
    end
  end
})

-- telescope
require("telescope").setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git/",
      "dist",
      "build",
      ".next",
      "target",
    },
  },
})

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})

-- conform
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = {"*.js", "*.ts", "*.tsx", "*.jsx"},
  callback = function()
    require("conform").format({ async = false })
  end,
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format()
end, { desc = "Format buffer" })

-- cmp
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
