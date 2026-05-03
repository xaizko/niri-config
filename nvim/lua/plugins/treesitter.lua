return {
    'nvim-treesitter/nvim-treesitter',
    build = ":TSUpdate",
    config = function()
	local configs = require("nvim-treesitter.configs")
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
