require("config.options")

local has_lazy = pcall(function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      "https://github.com/folke/lazy.nvim.git", lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)
  require("lazy").setup("plugins", {
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
  })
end)

if not has_lazy then
  vim.notify("lazy.nvim unavailable (offline?) — rosewood loaded without plugins",
    vim.log.levels.WARN)
end

vim.cmd.colorscheme("rosewood")
