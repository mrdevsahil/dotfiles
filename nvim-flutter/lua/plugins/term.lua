local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local M = {
  {
    "numToStr/FTerm.nvim",
    config = function()
      require("FTerm").setup({
        blend = 0,
        hl = "Normal",
        dimensions = {
          height = 0.7,
          width = 0.8,
          x = 0.5,
          y = 0.5,
        },
      })

      map("n", "<leader>tt", ":lua require('FTerm').toggle()<CR>", opts)
      map("t", "<leader>tt", '<C-\\><C-n>:lua require("FTerm").toggle()<CR>', opts)
      map("t", "jf", "<C-\\><C-n>", opts) -- Switch to normal mode
      -- map("n", "<C-\\>", "<C-\\><C-n>", opts) -- Switch back to terminal mode
    end,
  },
}

return M
