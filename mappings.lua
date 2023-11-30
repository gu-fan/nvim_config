-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
return {
  -- first key is the mode
  i={
    ["<<"] = {"<><Left>"},
    ["(("] = {"()<Left>"},
    ["[["] = {"[]<Left>"},
    ["{{"] = {"{}<Left>"},
    ["''"] = {"''<Left>"},
    ['""'] = {'""<Left>'},
    ['<C-Z>'] = {'<C-o>u<c-o>zv'},
    ['<C-Y>'] = {'<C-o><C-R><c-o>zv'},
    ['<C-A>'] = {'<C-o>gg<C-o>gH<C-o>G'},
    ['<C-V>'] = {'<C-R>+'},
    -- ["<C-K>"] = {
    --   function()
    --     local cmp = require("cmp")
    --     cmp.mapping.confirm {select=false}
    --   end
    -- },
  },
  c={
    ["<<"] = {"<><Left>"},
    ["(("] = {"()<Left>"},
    ["[["] = {"[]<Left>"},
    ["{{"] = {"{}<Left>"},
    ["''"] = {"''<Left>"},
    ['""'] = {'""<Left>'},
    ['<C-V>'] = {'<C-R>+'},
    -- ["<C-K>"] = {
    --   function()
    --     local cmp = require("cmp")
    --     cmp.mapping(cmp.mapping.complete())
    --   end
    -- },
  },
  n = {
    -- second key is the lefthand side of the map

    -- navigate buffer tabs with `H` and `L`
    -- L = {
    --   function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
    --   desc = "Next buffer",
    -- },
    -- H = {
    --   function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
    --   desc = "Previous buffer",
    -- },

    -- mappings seen under group name "Buffer"
    ['s'] = false,
    ['q:'] = ":",
    ['<leader>W'] = false,
    ["]b"] = false,
    ["[b"] = false,
    ["<S-l>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<S-h>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
    ['<leader><leader>'] = {'zA'},
    ["-"] = { "<c-x>", desc = "Descrement number" },
    ["+"] = { "<c-a>", desc = "Increment number" },
    ['<C-W>1'] = {'<cmd>resize<cr>'},
    ['<C-W>2'] = {'<c-w>='},
    ['<C-W>t'] = {'<c-w>T'},
    ['<C-Z>'] = {'uzv'},
    ['#'] = {'/<C-R><C-W><CR>'},
    ['<C-Y>'] = {'<C-R>zv'},
    ['<C-A>'] = {'ggVG'},
    ['<C-Q>'] = {'<C-V>'},
    ['<C-V>'] = {'"+gP'},
    ['<leader>tt'] = {'viw:Translate ZH<CR>'},
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(
          -- function(bufnr) require("astronvim.utils.buffer").close(bufnr) end
        )
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>ff"] = { 
      function()
        vim.cmd('cd %:h')
        vim.cmd('cd `git rev-parse --show-toplevel`')
        require("telescope.builtin").find_files()
      end
    },
    ["<c-p>"] = { 
      function()
        vim.cmd('cd %:h')
        vim.cmd('cd `git rev-parse --show-toplevel`')
        require("telescope.builtin").find_files()
      end
    },
    ["<leader>gg"] = { 
      function()
        vim.cmd('cd %:h')
        vim.cmd('cd `git rev-parse --show-toplevel`')
        require("telescope.builtin").live_grep()
      end
    },
    ["<c-e>ww"] = { "<cmd>edit /home/ryk/_0wikis/wiki_new/index.rst<cr>"},
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>cd"] = {"<cmd>cd %:p:h<cr>"},
    ["<leader>cg"] = {"<cmd>cd %:h | cd `git rev-parse --show-toplevel`<CR><cmd>pwd<CR>"},
    ["<leader>c"] = false,
    ["<leader>vv"] = {"<cmd>edit /home/ryk/.config/nvim/lua/user/mappings.lua<cr>"},
    ["<leader>vo"] = {"<cmd>edit /home/ryk/.vim/vimrc<cr>"},
    ["<leader>vr"] = {":AstroReload<cr>"},
    ["<leader>rr"] = { 
      "<cmd>sp | term godot4 --path /home/ryk/godot/SLG_P2 /home/ryk/godot/SLG_P2/temp/test.tscn<cr>"
    },
    ["<leader>re"] = { 
      "<cmd>sp | term godot4 --path /home/ryk/godot/SLG_P2 --editor --quit<cr>"
    },
    ["<leader>rt"] = { 
      "<cmd>edit /home/ryk/godot/SLG_P2/temp/test.gd<cr>"
    },
    ["<leader>e"] = {
      function()
        vim.cmd('cd %:h')
        vim.cmd('cd `git rev-parse --show-toplevel`')
        vim.cmd('Neotree toggle current reveal_force_cwd')
        -- if vim.bo.filetype == "neo-tree" then
        --   vim.cmd.wincmd "p"
        -- else
        --   vim.cmd.Neotree "focus"
        -- end
      end,
      desc = "Toggle Explorer Focus",
    },

    ["<leader>cc"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Toggle comment line",
    },

    -- quick save
    -- ["<C-s>"] = { ":w!<cr>", desc = "Save File" },  -- change description but the same command
  },
  v={
    ["<leader>cc"] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    },
    ['<C-c>'] = {'y'},
    ['<C-v>'] = {'"0c<C-R>+<Esc>'},
    ['#'] = {'*'},
    ['<leader>tt'] = {':Translate ZH<CR>'},
  },
  -- t = {
  --   -- setting a mapping to false will disable it
  --   -- ["<esc>"] = false,
  -- },
}
