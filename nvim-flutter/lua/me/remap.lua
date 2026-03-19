vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.keymap.set("n", "<leader>h", ":wincmd h<CR>")
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>")
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>")
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>")

-- move line
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "<leader>sv", ":vsplit <CR>")
vim.keymap.set("n", "<leader>sh", ":split <CR>")

vim.keymap.set("x", "p", "pgvy")

-- open command panel
vim.keymap.set("n", "'", ":", { noremap = true })

-- open explorer
vim.keymap.set("n", "<leader>pv", ":Oil<CR>")

-- select line
vim.keymap.set("n", "sl", "V", { silent = true })

-- select all
vim.keymap.set("n", "sa", "gg<S-v>G")

-- escape
vim.keymap.set("i", "jf", "<Esc>")
vim.keymap.set("v", "u", "<Esc>")
vim.keymap.set("n", "<leader>q", ":q!<CR>")
vim.keymap.set("n", "<leader>wq", ":wq<CR>")

-- move to start / end of the line
vim.keymap.set("n", "sk", "$", { noremap = false })
vim.keymap.set("n", "sj", "^", { noremap = false })

-- save
vim.keymap.set("n", "fj", ":w<CR>", { silent = false })

-- format
vim.keymap.set("n", "<leader>jf", vim.lsp.buf.format)

-- Copy
vim.keymap.set("v", "<S-y>", '"+y', { noremap = true })
vim.keymap.set("v", "<S-p>", '"+p', { noremap = true })

vim.keymap.set("i", "<C-j>", "<Down>", { noremap = true })
vim.keymap.set("i", "<C-k>", "<Up>", { noremap = true })
vim.keymap.set("i", "<C-h>", "<Left>", { noremap = true })
vim.keymap.set("i", "<C-l>", "<Right>", { noremap = true })

-- navigate buffer
vim.keymap.set("n", "<S-k>", ":bnext<CR>", { noremap = true })
vim.keymap.set("n", "<S-j>", ":bprevious<CR>", { noremap = true })

-- close buffer
vim.keymap.set("n", "cb", "<cmd>bd<CR>", { noremap = true, silent = true, desc = "Close current buffer" })

-- split view
vim.keymap.set("n", "<sr>", ":vsplit<CR>", { noremap = true })
vim.keymap.set("n", "<sd>", ":split<CR>", { noremap = true })
vim.keymap.set("n", "<sn>", ":tabnew<CR>", { noremap = true })

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<S-d>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<S-u>", "<cmd>cprev<CR>zz")

vim.keymap.set("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>ft", ":silent !flutter-test %:p<CR>")
vim.keymap.set("n", "<leader>ss", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")

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
vim.keymap.set("n", "<leader>ss", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
