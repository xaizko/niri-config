require('config.options')
require('config.keybinds')
require('config.lazy')
--vim.cmd.cd(vim.fn.expand("~/coding"))
vim.cmd("NvimTreeOpen")
vim.o.autoindent = true
vim.o.smartindent = true
