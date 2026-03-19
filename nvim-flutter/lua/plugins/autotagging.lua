return {
  {
    "windwp/nvim-ts-autotag",
    lazy = false,
    config = {},
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  }
}
