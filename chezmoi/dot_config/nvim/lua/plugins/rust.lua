return {
	"mrcjkb/rustaceanvim",
	version = "^8", -- Recommended
	lazy = false, -- This plugin is already lazy
	init = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						inlayHints = {
							chainingHints = { enable = true },
							closingBraceHints = { enable = true },
							parameterHints = { enable = true },
							typeHints = { enable = true },
						},
					},
				},
			},
		}
	end,
}
