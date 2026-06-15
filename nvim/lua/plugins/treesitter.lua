return {
    'nvim-treesitter/nvim-treesitter', tag = "v0.10.0",
    build = ":TSUpdate",
    config = function()
	local configs = require("nvim-treesitter")
	configs.setup({
	    highlight = {
		enable = true,
	    },
	    indent = { enable = true },
	    autotag = { enable = true },
	    ensured_installed = {
		"lua",
		"c",
		"rust",
		"cpp",
		"python",
		"java",
		"typescript",
		"typescriptreact",
	    },
	    auto_install = false,
	})
    end
}
