vim.g.mapleader = " "
local set = vim.keymap.set
local api = vim.api.nvim_set_keymap
local opt = { noremap = true, silent = true }

--copy paste--
api("v", "<Y>", '"+y', { noremap = true })
api("n", "<P>", '"+p', { noremap = true })

--open-explorer
api("n", "<Leader>pv", ":Oil<CR>", opt)

--move line--
set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Optional: Customize the highlight group for illuminated words
vim.cmd("highlight link illuminatedWord Visual")

vim.keymap.set(
	"n",
	"fj",
	"<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
	{ noremap = true, silent = true, desc = "Format" }
)
set("n", "<leader>sv", function()
	vim.cmd([[
      update $MYVIMRC
      source $MYVIMRC
    ]])
	vim.notify("Nvim config successfully reloaded!", vim.log.levels.INFO, { title = "nvim-config" })
end, {
	silent = true,
	desc = "reload init.lua",
})

-- Move normally between wrapped lines
set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Keymaps for better default experience
set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

--indenting--
set("v", "<", "<gv")
set("v", ">", ">gv")
--undo--
set("n", "U", "<C-r>", { noremap = true })
set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

--format
set("n", "<leader>fj", vim.lsp.buf.format)

api("i", "<C-j>", "<Down>", { noremap = true })
api("i", "<C-k>", "<Up>", { noremap = true })
api("i", "<C-h>", "<Left>", { noremap = true })
api("i", "<C-l>", "<Right>", { noremap = true })

vim.api.nvim_set_option("completefunc", "completefunc#omni#syntax")

--move to start and end of line
api("n", "sk", "$", { noremap = false })
api("n", "sj", "^", { noremap = false })

--close cureent buffer
set("n", "cb", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })

-- Navigate buffers
set("n", "<S-k>", ":bnext<CR>", { noremap = true })
set("n", "<S-j>", ":bprevious<CR>", { noremap = true })
-- Select all
set("n", "sa", "gg<S-v>G")

--split--
set("n", "sr", ":vsplit <CR>")
set("n", "sd", ":split <cr>")
set("n", "sn", ":tabnew <cr>")

-- resize in split--
api("n", "<Left>", ":vertical resize -2<CR>", opt)
api("n", "<Right>", ":vertical resize +2<CR>", opt)

-- Normal mode navigation
api("n", "<Esc>", "<cmd>noh<CR>", opt)
api("n", "sh", "<C-w>h", opt)
api("n", "sl", "<C-w>l", opt)
set("i", "jf", "<Esc>")
set("v", "o", "<Esc>")
set("x", "o", "<Esc>")
set("x", "e", "=")

api("n", "fj", ":w<CR>", { silent = false })
api("n", "<leader>q", ":q!<CR>", { silent = true })
api("n", "<leader>wq", ":wq<CR>", { silent = true })

-- api("n", "<Leader>/", ":<C-u>normal gcc<CR>", opt)
api("x", "<Leader>/", ":normal gcc<CR>", opt)
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("i", "<C-c>", "<Esc>")

set("n", "Q", "<nop>")

set("n", "<C-[>", "<cmd>cnext<CR>zz")
set("n", "<C-]>", "<cmd>cprev<CR>zz")
-- set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Close all buffers except current
set("n", "ca", "<cmd>%bd|e#|bd#<CR>", { noremap = true, silent = true, desc = "Close all other buffers" })

-- copy to system clipboard
vim.g.clipboard = {
	name = "xclip",
	copy = {
		["+"] = "xclip -selection clipboard",
		["*"] = "xclip -selection primary",
	},
	paste = {
		["+"] = "xclip -selection clipboard -o",
		["*"] = "xclip -selection primary -o",
	},
	cache_enabled = 1,
}

-- replase with workd
set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- compile and run current buffer cpp code in the terminal
vim.api.nvim_set_keymap(
	"n",
	"C-gcc",
	":w<CR>:term g++ -std=c++20 % -o %:r && ./%:r<CR>",
	{ noremap = true, silent = true }
)

-- set("n", "<leader>ee", "oif err != nil {<CR>}<Esc>Oreturn err<Esc>")
