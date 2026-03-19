return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local keymap = vim.keymap

		-- Diagnostic signs
		local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "I " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Keymaps on attach (replaces on_attach callback)
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspKeymaps", { clear = true }),
			callback = function(event)
				local opts = { noremap = true, silent = true, buffer = event.buf }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", vim.lsp.buf.references, opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				keymap.set("n", "gr", require("telescope.builtin").lsp_references, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "<leader>k", vim.lsp.buf.hover, opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>g", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				keymap.set("n", "<leader>dl", vim.diagnostic.setqflist, opts)
			end,
		})

		-- Capabilities for autocompletion
		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Configure all servers using new vim.lsp.config API
		vim.lsp.config("html", {
			capabilities = capabilities,
			filetypes = { "py", "html" },
		})

		-- configure typescript server
		vim.lsp.config("ts_ls", {
			capabilities = capabilities,
			filetypes = { "javascript" },
		})

		vim.lsp.config("cssls", {
			capabilities = capabilities,
		})

		vim.lsp.config("tailwindcss", {
			capabilities = capabilities,
		})

		vim.lsp.config("emmet_ls", {
			capabilities = capabilities,
			filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
		})

		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			filetypes = { "lua" },
		})

		-- configure clangd server for C++ development
		vim.lsp.config("clangd", {
			capabilities = capabilities,
			filetypes = { "c", "cpp", "objc", "objcpp" },
			root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
		})

		-- configure dart language server for Dart and Flutter
		vim.lsp.config("dartls", {
			capabilities = capabilities,
			filetypes = { "dart" },
			init_options = {
				closingLabels = true,
				flutterOutline = true,
				onlyAnalyzeProjectsWithOpenFiles = true,
				outline = true,
				suggestFromUnimportedLibraries = true,
			},
			root_markers = { "pubspec.yaml" },
			settings = {
				dart = {
					completeFunctionCalls = true,
					showTodos = true,
				},
			},
		})

		-- configure PHP server
		vim.lsp.config("intelephense", {
			capabilities = capabilities,
			filetypes = { "php" },
			settings = {
				intelephense = {
					stubs = {
						"bcmath",
						"bz2",
						"calendar",
						"Core",
						"curl",
						"date",
						"dom",
						"fileinfo",
						"filter",
						"gd",
						"gettext",
						"hash",
						"iconv",
						"intl",
						"json",
						"libxml",
						"mbstring",
						"mcrypt",
						"mysql",
						"mysqli",
						"openssl",
						"pcntl",
						"pcre",
						"PDO",
						"pdo_mysql",
						"Phar",
						"readline",
						"regex",
						"session",
						"SimpleXML",
						"sodium",
						"SPL",
						"standard",
						"tokenizer",
						"xml",
						"xmlreader",
						"xmlwriter",
						"zip",
						"zlib",
						"laravel",
						"wordpress",
					},
					environment = {
						phpVersion = "8.5.0",
					},
				},
			},
		})

		-- Enable all configured servers
		vim.lsp.enable({
			"html",
			"ts_ls",
			"cssls",
			"tailwindcss",
			"emmet_ls",
			"lua_ls",
			"clangd",
			"dartls",
			"intelephense",
		})
	end,
}
