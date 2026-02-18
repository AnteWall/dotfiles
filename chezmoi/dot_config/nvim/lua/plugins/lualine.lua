return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
      },
      git = {
        added = " ",
        modified = " ",
        removed = " ",
      },
    }

    local function pretty_path()
      local path = vim.fn.expand("%:~:.")
      if path == "" then
        return ""
      end

      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon = ""
      local ok, devicons = pcall(require, "nvim-web-devicons")
      if ok then
        icon = devicons.get_icon(filename, extension, { default = true }) or icon
      end

      local max_length = 48
      if #path > max_length then
        path = "..." .. path:sub(-(max_length - 3))
      end

      return icon .. " " .. path
    end

    local lualine_y = {}
    local has_codecompanion, codecompanion = pcall(require, "lualine.components.codecompanion")
    if has_codecompanion then
      table.insert(lualine_y, codecompanion)
    end

    vim.o.laststatus = 2

    local opts = {
      options = {
        theme = "auto",
        icons_enabled = true,
        disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },

        lualine_b = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          { pretty_path },
        },
        lualine_c = {},
        lualine_x = {
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = lualine_y,
        lualine_z = {
          function()
            return " " .. os.date("%R")
          end,
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = { "lazy" },
    }

    return opts
  end,
}
