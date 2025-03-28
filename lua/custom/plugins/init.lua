-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

vim.opt.swapfile = false
vim.opt.wrap = false

vim.opt.scrolloff = 7

vim.opt.ph = 15

vim.opt.cursorcolumn = false
vim.opt.cursorline = false

vim.keymap.set('n', ',w', ':w<CR>', { desc = 'Save buffer' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>dc', ':bwipeout<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>db', ':%bd|e#|bd#<cr>|\'"<CR>', { noremap = true, silent = true })

vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, { noremap = true, silent = true })

return {
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
  },
  {
    'f-person/auto-dark-mode.nvim',
    opts = {
      set_dark_mode = function()
        vim.api.nvim_set_option_value('background', 'dark', {})
        vim.cmd.colorscheme 'gruvbox-material'
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value('background', 'light', {})
        vim.cmd.colorscheme 'gruvbox-material'
      end,
      update_interval = 10000,
      fallback = 'dark',
    },
  },
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
  -- stylua: ignore
  keys = {
    { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
    { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
    { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
    { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
  },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
    config = function()
      require('oil').setup {
        default_file_explorer = true,
        columns = {
          'size',
          'icon',
          -- "permissions",
          -- "mtime",
        },
      }
      vim.keymap.set('n', '<C-l>', '<CMD>Oil<CR>', { desc = 'Open parent directory' })
    end,
  },
  {
    'cbochs/grapple.nvim',
    opts = {
      scope = 'git',
      icons = false,
    },
    keys = {
      { '<leader>m', '<cmd>Grapple toggle<cr>', desc = 'Grapple toggle tag' },
      { '<leader>M', '<cmd>Grapple toggle_tags<cr>', desc = 'Grapple open tags window' },
      { '<leader>n', '<cmd>Grapple cycle_tags next<cr>', desc = 'Grapple cycle next tag' },
      { '<leader>p', '<cmd>Grapple cycle_tags prev<cr>', desc = 'Grapple cycle previous tag' },
    },
  },
}
