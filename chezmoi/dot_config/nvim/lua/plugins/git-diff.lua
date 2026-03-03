local function toggle_diffview()
    local view = require("diffview.lib").get_current_view()
    if view then
        vim.cmd("DiffviewClose")
    else
        vim.cmd("DiffviewOpen")
    end
end

return {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose" },
    keys = {
        {
            "<C-_>",
            toggle_diffview,
            desc = "Toggle Diffview",
        },
        {
            "<C-/>",
            toggle_diffview,
            desc = "Toggle Diffview",
        },
        {
            "<leader>gd",
            toggle_diffview,
            desc = "Toggle Diffview",
        },
    },
}
