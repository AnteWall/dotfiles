return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "fredrikaverpil/neotest-golang",
        "leoluz/nvim-dap-go",
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-golang")({
                    dap = {
                        justMyCode = false
                    },
                }),
            }
        })
        vim.keymap.set("n", "<leader>tr", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
            })
        end, { desc = "Debug: Run nearest test" })

        vim.keymap.set("n", "<leader>tv", function()
            require("neotest").summary.toggle()
        end, { desc = "Debug: Summary toggle" })

        vim.keymap.set("n", "<leader>ts", function()
            require("neotest").run.run({
                suite = true,
                testify = true,
            })
        end, { desc = "Debug: Run test suite" })

        vim.keymap.set("n", "<leader>td", function()
            require("neotest").run.run({
                suite = false,
                testify = true,
                strategy = "dap",
            })
        end, { desc = "Debug: Debug nearest test" })

        vim.keymap.set("n", "<leader>to", function()
            require("neotest").output.open()
        end, { desc = "Debug: Open test output" })

        vim.keymap.set("n", "<leader>ta", function()
            require("neotest").run.run(vim.fn.getcwd())
        end, { desc = "Debug: Open test output" })
    end
}
