return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    if wk.add then
      wk.add({
        { "<leader>d", group = "Delete" },
        { "<leader>p", group = "Project/Search" },
        { "<leader>t", group = "Tests/Trouble" },
        { "<leader>v", group = "View" },
        { "<leader>y", group = "Yank" },
      })
      return
    end

    wk.register({
      d = { name = "Delete" },
      p = { name = "Project/Search" },
      t = { name = "Tests/Trouble" },
      v = { name = "View" },
      y = { name = "Yank" },
    }, { prefix = "<leader>" })
  end,
}
