return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,        -- README: plugin does not support lazy-loading
        build = ":TSUpdate", -- README: keep parsers in sync with plugin
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

            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("tree - sitter - enable", { clear = true }),
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang then return end

                    if vim.treesitter.query.get(lang, "highlights") then vim.treesitter.start(args.buf) end

                    if vim.treesitter.query.get(lang, "indents") then
                        vim.opt_local.indentexpr = 'v:lua.require(“nvim-treesitter”).indentexpr()'
                    end
               end,
            })
        end,
    }
}
