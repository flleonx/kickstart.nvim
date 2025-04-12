-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
vim.o.termguicolors = true

vim.opt.swapfile = false
vim.opt.wrap = false

vim.opt.scrolloff = 7

vim.opt.ph = 15

vim.opt.cursorcolumn = false
vim.opt.cursorline = false

vim.keymap.set('n', ',w', ':w<CR>', { desc = 'Save buffer' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>bc', ':bwipeout<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>bd', ':%bd|e#|bd#<cr>|\'"<CR>', { noremap = true, silent = true })

vim.keymap.set('v', '<', '<gv', { noremap = true, silent = true })
vim.keymap.set('v', '>', '>gv', { noremap = true, silent = true })

vim.keymap.set('n', '<leader>vd', vim.diagnostic.open_float, { noremap = true, silent = true })

if os.getenv 'SHELL' ~= '/bin/zsh' then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy '+',
      ['*'] = require('vim.ui.clipboard.osc52').copy '*',
    },
    paste = {
      ['+'] = function() end,
      ['*'] = function() end,
    },
  }
end

return {
  {
    'sainnhe/gruvbox-material',
    priority = 1000,
    config = function()
      vim.api.nvim_set_option_value('background', 'dark', {})
      vim.cmd.colorscheme 'gruvbox-material'
    end,
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
  {
    'mfussenegger/nvim-lint',
    config = function()
      require('lint').linters_by_ft = {
        go = { 'golangcilint' },
      }
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        callback = function()
          require('lint').try_lint()
        end,
      })
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
    },
    keys = {
      -- Basic debugging keymaps, feel free to change to your liking!
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Start/Continue',
      },
      {
        '<F1>',
        function()
          require('dap').step_into()
        end,
        desc = 'Debug: Step Into',
      },
      {
        '<F2>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step Over',
      },
      {
        '<F3>',
        function()
          require('dap').step_out()
        end,
        desc = 'Debug: Step Out',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>B',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Debug: Set Breakpoint',
      },
      -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
      {
        '<F7>',
        function()
          require('dapui').toggle()
        end,
        desc = 'Debug: See last session result.',
      },
      {
        '<F8>',
        function()
          require('dapui').eval(nil, { enter = true })
        end,
        desc = 'Debug: See last session result.',
      },
      {
        '<leader>dt',
        function()
          require('dap-go').debug_test()
        end,
        desc = 'Debug: See last session result.',
      },
      {
        '<F10>',
        function()
          require('dap').terminate()
          require('dapui').close()
        end,
        desc = 'Debug: See last session result.',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Dap UI setup
      dapui.setup {
        layouts = {
          {
            -- Sidebar layout
            elements = {
              { id = 'scopes', size = 0.40 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'watches', size = 0.20 },
              { id = 'stacks', size = 0.15 },
            },
            size = 50, -- Width of the sidebar (in columns)
            position = 'left', -- Can be "left", "right", "top", "bottom"
          },
          {
            -- Tray layout
            elements = {
              { id = 'repl', size = 0.9 },
              { id = 'console', size = 0.1 },
            },
            size = 10, -- Height of the tray (in lines)
            position = 'bottom',
          },
        },
      }

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open

      -- Install golang specific config
      require('dap-go').setup {}
    end,
  },
}
