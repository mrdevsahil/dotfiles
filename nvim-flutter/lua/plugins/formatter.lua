return {
	"mhartington/formatter.nvim",
	config = function()
		local settings = {
			lua = {
				require("formatter.filetypes.lua").stylua,
			},
			typescriptreact = {
				require("formatter.filetypes.typescript").prettier,
			},
			typescript = {
				require("formatter.filetypes.typescript").prettier,
			},
			css = {
				require("formatter.filetypes.css").prettier,
			},
			dart = {
				require("formatter.filetypes.dart").dartformat,
			},
			graphql = {
				require("formatter.filetypes.graphql").prettier,
			},
			["*"] = {
				require("formatter.filetypes.any").remove_trailing_whitespace,
			},
		}

		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = settings,
		})

		-- Format on save
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = "*",
			callback = function()
				vim.cmd("FormatWrite")
			end,
		})

		-- Manual format
		vim.keymap.set("n", "<leader>jf", function()
			if settings[vim.bo.filetype] ~= nil then
				vim.cmd("Format")
			else
				vim.lsp.buf.format({
					filter = function(client)
						if vim.bo.filetype == "dart" and client.name == "dartls" then
							return false
						end
						return true
					end,
				})
			end
		end)
	end,
}
