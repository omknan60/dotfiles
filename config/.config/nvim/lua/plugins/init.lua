return {
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        config = function ()
            vim.keymap.set("n", "<leader>o", vim.cmd.NvimTreeToggle)
        end
        },
    },
    "windwp/nvim-autopairs",
    {
        "nvimdev/indentmini.nvim",
        event = 'BufEnter',
    },
}
