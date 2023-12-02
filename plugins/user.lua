local utils = require "astronvim.utils"

return {
  --  You can also add new plugins here as well:
  --  Add plugins, the lazy syntax
  --  "andweeb/presence.nvim",
  --  {
  --    "ray-x/lsp_signature.nvim",
  --    event = "BufRead",
  --    config = function()
  --      require("lsp_signature").setup()
  --    end,
  --  },
  {
    "habamax/vim-godot",
    lazy=false,
  },
  {
    "uga-rosa/translate.nvim",
    lazy=false,
  },
  { "junegunn/vim-easy-align", event = "User AstroFile" },
  {
    "epwalsh/pomo.nvim",
    -- version = "*",  -- Recommended, use latest release instead of latest commit
    lazy = true,
    cmd = { "TimerStart", "TimerStop", "TimerRepeat" },
    dependencies = {
      -- Optional, but highly recommended if you want to use the "Default" timer
      "rcarriga/nvim-notify",
    },
    opts = {
      notifiers = {
        {
          name = "Default",
          opts = {
            sticky = false,
          }
        }
      }
    },
  },
  {
    "folke/zen-mode.nvim",
    lazy=true,
    cmd = "ZenMode",
    opts = {
      window = {
        backdrop = 1,
        width = 80,
        height = 0.9,
        options = {
          number = false,
          relativenumber = false,
          foldcolumn = "0",
          list = false,
          showbreak = "NONE",
          signcolumn = "auto",
        },
      },
      plugins = {
        options = {
          cmdheight = 1,
          laststatus = 0,
        },
      },
      on_open = function() -- disable diagnostics, indent blankline, winbar, and offscreen matchup
        vim.g.diagnostics_mode_old = vim.g.diagnostics_mode
        vim.g.diagnostics_mode = 0
        vim.diagnostic.config(require("astronvim.utils.lsp").diagnostics[vim.g.diagnostics_mode])

        vim.g.indent_blankline_enabled_old = vim.g.indent_blankline_enabled
        vim.g.indent_blankline_enabled = false
        vim.g.miniindentscope_disable_old = vim.g.miniindentscope_disable
        vim.g.miniindentscope_disable = true

        vim.g.winbar_old = vim.o.winbar
        vim.api.nvim_create_autocmd({ "BufWinEnter", "BufNew" }, {
          pattern = "*",
          callback = function() vim.o.winbar = nil end,
          group = vim.api.nvim_create_augroup("disable_winbar", { clear = true }),
          desc = "Ensure winbar stays disabled when writing to file, switching buffers, opening floating windows, etc.",
        })

        if utils.is_available "vim-matchup" then
          vim.cmd.NoMatchParen()
          vim.g.matchup_matchparen_offscreen_old = vim.g.matchup_matchparen_offscreen
          vim.g.matchup_matchparen_offscreen = {}
          vim.cmd.DoMatchParen()
        end
      end,
      on_close = function() -- restore diagnostics, indent blankline, winbar, and offscreen matchup
        vim.g.diagnostics_mode = vim.g.diagnostics_mode_old
        vim.diagnostic.config(require("astronvim.utils.lsp").diagnostics[vim.g.diagnostics_mode])

        vim.g.indent_blankline_enabled = vim.g.indent_blankline_enabled_old
        vim.g.miniindentscope_disable = vim.g.miniindentscope_disable_old
        if vim.g.indent_blankline_enabled_old then vim.cmd "IndentBlanklineRefresh" end

        vim.api.nvim_clear_autocmds { group = "disable_winbar" }
        vim.o.winbar = vim.g.winbar_old

        if utils.is_available "vim-matchup" then
          vim.g.matchup_matchparen_offscreen = vim.g.matchup_matchparen_offscreen_old
          vim.cmd.DoMatchParen()
        end
      end,
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      action_keys = {
        close = { "q", "<esc>" },
        cancel = "<c-e>",
      },
    },
  },
  {
    "levouh/tint.nvim",
    event = "User AstroFile",
    opts = {
      highlight_ignore_patterns = { "WinSeparator", "neo-tree", "Status.*" },
      tint = -25, -- Darken colors, use a positive value to brighten
      saturation = 0.5, -- Saturation to preserve
    },
  }
}
