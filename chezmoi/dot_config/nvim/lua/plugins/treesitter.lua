return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,            -- README: plugin does not support lazy-loading
    build = ":TSUpdate",     -- README: keep parsers in sync with plugin
    config = function()
      require("nvim-treesitter").install({
          "go", 
          "lua", 
          "rust", 
          "python", 
          "json", 
          "yaml", 
          "markdown", 
          "dockerfile", 
          "javascript", 
          "typescript"
      })
    end,
  },
}

