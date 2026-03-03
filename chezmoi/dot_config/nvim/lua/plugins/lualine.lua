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

		local contrast_palette = {
			error = { bg = "#eb6f92", fg = "#191724" },
			warn = { bg = "#f6c177", fg = "#191724" },
			info = { bg = "#9ccfd8", fg = "#191724" },
			hint = { bg = "#c4a7e7", fg = "#191724" },
		}

		local function diagnostic_colors(level)
			local palette = contrast_palette[level] or { bg = "#524f67", fg = "#e0def4" }
			return {
				soft_bg = palette.bg,
				text = palette.fg,
			}
		end

		local function get_diag_counts()
			local counts = { error = 0, warn = 0, info = 0, hint = 0 }
			for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
				if diagnostic.severity == vim.diagnostic.severity.ERROR then
					counts.error = counts.error + 1
				elseif diagnostic.severity == vim.diagnostic.severity.WARN then
					counts.warn = counts.warn + 1
				elseif diagnostic.severity == vim.diagnostic.severity.INFO then
					counts.info = counts.info + 1
				elseif diagnostic.severity == vim.diagnostic.severity.HINT then
					counts.hint = counts.hint + 1
				end
			end
			return counts
		end

		local function current_diag_level()
			local counts = get_diag_counts()
			if counts.error > 0 then
				return "error"
			elseif counts.warn > 0 then
				return "warn"
			elseif counts.info > 0 then
				return "info"
			elseif counts.hint > 0 then
				return "hint"
			end
			return nil
		end

		local function diagnostics_badge()
			local counts = get_diag_counts()
			local parts = {}
			if counts.error > 0 then
				table.insert(parts, icons.diagnostics.Error .. counts.error)
			end
			if counts.warn > 0 then
				table.insert(parts, icons.diagnostics.Warn .. counts.warn)
			end
			if counts.info > 0 then
				table.insert(parts, icons.diagnostics.Info .. counts.info)
			end
			if counts.hint > 0 then
				table.insert(parts, icons.diagnostics.Hint .. counts.hint)
			end
			if #parts == 0 then
				return ""
			end
			return " " .. table.concat(parts, " ") .. " "
		end

		local function diagnostics_badge_color()
			local level = current_diag_level()
			if not level then
				return nil
			end
			local palette = diagnostic_colors(level)
			return { fg = palette.text, bg = palette.soft_bg, gui = "bold" }
		end

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
						diagnostics_badge,
						color = diagnostics_badge_color,
						cond = function()
							return current_diag_level() ~= nil
						end,
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
