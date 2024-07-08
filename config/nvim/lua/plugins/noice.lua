return {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
        -- Noice options
        messages = {
            enable = false
        }
    },
    dependencies = {
        'MunifTanjim/nui.nvim',
        'rcarriga/nvim-notify',
    }
}
