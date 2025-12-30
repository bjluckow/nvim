-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "mason-org/mason.nvim", lazy = false, opts = {} },
  { "neovim/nvim-lspconfig",
    config = function()
    vim.lsp.enable("pyright")
    end
  },
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
