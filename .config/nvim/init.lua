	-- Bootstrap lazy.nvim
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not (vim.uv or vim.loop).fs_stat(lazypath) then
	  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	end
	vim.opt.rtp:prepend(lazypath)

	require("lazy").setup({
	  { 
      "mason-org/mason.nvim", 
      lazy = false,
      config = function()
        require("mason").setup()
      end
    },


    {
      "williamboman/mason-lspconfig.nvim",
      dependencies = { "mason-org/mason.nvim" },
      config = function()
        require("mason-lspconfig").setup({
          ensure_installed = {
            "gopls",
            "pyright",
            "ts_ls",
            "lua_ls",
          },
          automatic_installation = true,
        })
      end,
    },

  -- color scheme
  {
    "sainnhe/everforest", -- https://dotfyle.com/plugins/sainnhe/everforest
    lazy = false,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { 
      "hrsh7th/cmp-nvim-lsp", 
      "williamboman/mason-lspconfig.nvim" 
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- default behavior
      local function setup(server)
        vim.lsp.config(server, {
          capabilities = capabilities
        })
      end

      -- basic servers
      setup("pyright")
      setup("ts_ls")

      -- Go overrides
      vim.lsp.config("gopls", {
        capabilities = capabilities,
        settings = {
          gopls = {
            completeUnimported = true,
            staticcheck = true,
          }
        }
      })
      vim.lsp.enable("gopls")

      -- Lua overrides
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enable = false },
          }
        }
      })
      vim.lsp.enable("lua_ls")
    end
  },

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")

      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            vim.cmd.cd(data.file)
            require("nvim-tree.api").tree.open()
          end
        end
      })

    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()    
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
      vim.keymap.set("n", "<leader>:", builtin.commands, {}) -- fzf commands
    end
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
          go = { "goimports" },
        },
        format_on_save = true,
        })


      vim.api.nvim_create_autocmd("InsertLeave", {
        pattern = {"*.js", "*.ts", "*.tsx", "*.jsx", "*.go"},
        callback = function()
          require("conform").format({ async = false })
        end,
      })

      vim.keymap.set("n", "<leader>f", 
        function()
          require("conform").format()
        end, { desc = "Format buffer" }
      )

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
    config = function()
      local cmp = require("cmp")

      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
          }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),

        sources = {
          { name = "nvim_lsp" }, -- member access, struct fields, methods
          { name = "buffer" },   -- words in file
          { name = "path" },     -- filesystem
        },
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})

      -- integrate with cmp
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = {
          "go",
          "lua",
          "python",
          "javascript",
          "typescript",
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  {
    "numToStr/Comment.nvim",
    opts = {}, 
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

vim.cmd("syntax enable")
vim.cmd("syntax on")

vim.cmd.colorscheme("everforest") -- https://dotfyle.com/neovim/colorscheme/top
