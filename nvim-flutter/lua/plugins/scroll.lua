return {
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
  } }
