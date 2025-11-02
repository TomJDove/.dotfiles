require("config.lazy")

-- File with key remaps
require("config.remap")

-- File with sets
require("config.set")

vim.o.expandtab = true -- Use spaces instead of tabs

vim.api.nvim_create_autocmd("FileType", {
	pattern = "typescript",
	command = "setlocal shiftwidth=2 tabstop=2",
})

vim.api.nvim_set_option("clipboard", "unnamed")

vim.opt.rtp:append(vim.fn.stdpath("config") .. "/lua/custom/")
