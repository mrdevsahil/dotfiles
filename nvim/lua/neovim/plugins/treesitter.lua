return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	enabled = true,
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function()
		-- Register templ parser
		local parsers = require("nvim-treesitter.parsers")
		parsers.templ = {
			install_info = {
				url = "https://github.com/vrischmann/tree-sitter-templ.git",
				files = { "src/parser.c", "src/scanner.c" },
				branch = "master",
			},
		}
		vim.treesitter.language.register("templ", "templ")

		-- Install parsers
		require("nvim-treesitter").setup({
			auto_install = true,
		})

		-- Enable treesitter highlighting natively per filetype
		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})

		-- Textobjects (select + move)
		require("nvim-treesitter-textobjects").setup({
			select = {
				lookahead = true,
				keymaps = {
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
					["ii"] = "@conditional.inner",
					["ai"] = "@conditional.outer",
					["il"] = "@loop.inner",
					["al"] = "@loop.outer",
					["at"] = "@comment.outer",
				},
			},
			move = {
				set_jumps = true,
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_next_end = {
					["]M"] = "@function.outer",
					["]["] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
				goto_previous_end = {
					["[M"] = "@function.outer",
					["[]"] = "@class.outer",
				},
			},
		})

		-- Swap textobjects (manual keymaps since no setup API)
		local swap = require("nvim-treesitter-textobjects.swap")
		vim.keymap.set("n", "<leader>pa", function()
			swap.swap_next({ "@parameter.inner" })
		end, { desc = "Swap with next parameter" })
		vim.keymap.set("n", "<leader>pA", function()
			swap.swap_previous({ "@parameter.inner" })
		end, { desc = "Swap with previous parameter" })
	end,
}
