return {

	{ "tweekmonster/django-plus.vim" },
	{ "folke/neodev.nvim" },
	{ "tpope/vim-fugitive" },
	{ "sphamba/smear-cursor.nvim", opts = {} },
	{
		"terryma/vim-multiple-cursors",
		-- "mg979/vim-visual-multi",
	},
	-- { "RRethy/vim-illuminate" },
	-- { "dominikduda/vim_current_word" },
	--Code fold
	-- vim registers
	{
		"tversteeg/registers.nvim",
		cmd = "Registers",
		config = true,
		keys = {
			{ '"', mode = { "n", "v" } },
			{ "<C-R>", mode = "i" },
		},
		name = "registers",
	},

	--- see keys
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},

	{ "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

	-- tsserver-helper
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},

	-- for auto tags
	{
		"windwp/nvim-ts-autotag",
		lazy = false,
		config = {},
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
		},
	},

	--for undu tre
	{
		"mbbill/undotree",
		config = function()
			vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
		end,
	},

	--for comment
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},

	--for smooth scrolling
	{
		"karb94/neoscroll.nvim",
		config = function()
			local neoscroll = require("neoscroll")

			neoscroll.setup({
				-- easing = "sine",
				-- hide_cursor = true,
				-- stop_eof = true,
				-- respect_scrolloff = false,
				-- cursor_scrolls_alone = true,
				-- performance_mode = false,
			})

			-- Define custom key mappings
			local keymap = {
				["<S-n>"] = function()
					neoscroll.scroll(-vim.wo.scroll, { move_cursor = true, duration = 350, easing = "sine" })
				end,
				["<S-m>"] = function()
					neoscroll.scroll(vim.wo.scroll, { move_cursor = true, duration = 350, easing = "sine" })
				end,
			}

			-- Apply the key mappings to normal, visual, and select modes
			local modes = { "n", "v", "s" }
			for key, func in pairs(keymap) do
				vim.keymap.set(modes, key, func, { silent = true })
			end
		end,
	},

	--for autopars
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {},
	},

	{
		"stevearc/dressing.nvim",
		opts = true,
		config = function()
			local dressing = require("dressing")
			dressing.setup({
				-- Options will go here
			})
		end,
	},

	--nice command prompt --
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		config = function()
			require("noice").setup({
				presets = {
					bottom_search = false, -- use a classic bottom cmdline for search
					command_palette = false, --set true to top
					long_message_to_split = false, -- long messages will be sent to a split
					inc_rename = false, -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = true, -- add a border to hover docs and signature help
				},
				lsp = {
					progress = {
						enabled = false, --disable  lsp message when first load
					},
				},
				messages = {
					enabled = false,
				},
			})
		end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
	},
	{
		"ya2s/nvim-cursorline",
		config = function()
			require("nvim-cursorline").setup({
				cursorline = {
					enable = true,
					timeout = 1000,
					number = false,
				},
				cursorword = {
					enable = true,
					min_length = 3,
					hl = { underline = true },
				},
			})
		end,
	},

	--for hiding env data
	-- {
	-- 	"laytan/cloak.nvim",
	-- 	config = function()
	-- 		require("cloak").setup({
	-- 			enabled = true,
	-- 			cloak_character = "*",
	-- 			highlight_group = "Comment",
	-- 			patterns = {
	-- 				{
	-- 					file_pattern = {
	-- 						".env*",
	-- 						"wrangler.toml",
	-- 						".dev.vars",
	-- 					},
	-- 					cloak_pattern = "=.+",
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
				-- surr*ound_words             ysiw)           (surround_words)
				--     *make strings               ys$"            "make strings"
				--     [delete ar*ound me!]        ds]             delete around me!
				--     remove <b>HTML t*ags</b>    dst             remove HTML tags
				--     'change quot*es'            cs'"            "change quotes"
				--     <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
				--     delete(functi*on calls)     dsf             function calls
				--
			})
		end,
	},

	-- mini status line
	-- {
	-- 	"utilyre/barbecue.nvim",
	-- 	name = "barbecue",
	-- 	version = "*",
	-- 	event = { "BufReadPost", "BufNewFile", "BufWritePre" },
	-- 	dependencies = {
	-- 		"SmiteshP/nvim-navic",
	-- 		"nvim-tree/nvim-web-devicons",
	-- 	},
	-- 	opts = {
	-- 		kinds = {
	-- 			Array = "",
	-- 			Boolean = "",
	-- 			Class = "",
	-- 			Color = "",
	-- 			Constant = "",
	-- 			Constructor = "",
	-- 			Enum = "",
	-- 			EnumMember = "",
	-- 			Event = "",
	-- 			Field = "",
	-- 			File = "󰈙",
	-- 			Folder = "",
	-- 			Function = "",
	-- 			Interface = "",
	-- 			Key = "",
	-- 			Keyword = "",
	-- 			Method = "",
	-- 			Module = "",
	-- 			Namespace = "",
	-- 			Null = "",
	-- 			Number = "",
	-- 			Object = "",
	-- 			Operator = "",
	-- 			Package = "",
	-- 			Property = "",
	-- 			Reference = "",
	-- 			Snippet = "",
	-- 			String = "",
	-- 			Struct = "",
	-- 			Text = "",
	-- 			TypeParameter = "",
	-- 			Unit = "",
	-- 			Value = "",
	-- 			Variable = "",
	-- 		},
	-- 	},
	-- },

	--harpoon --
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")

			harpoon:setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<S-i>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			vim.keymap.set("n", "<C-u>", function()
				harpoon:list():select(1)
			end)
			vim.keymap.set("n", "<C-i>", function()
				harpoon:list():select(2)
			end)
			vim.keymap.set("n", "<C-o>", function()
				harpoon:list():select(3)
			end)
			vim.keymap.set("n", "<C-p>", function()
				harpoon:list():select(4)
			end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<A-i>", function()
				harpoon:list():prev()
			end)
			vim.keymap.set("n", "<A-o>", function()
				harpoon:list():next()
			end)
		end,
	},
}
