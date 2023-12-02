-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
local function get_buffers(options)
    local buffers = {}
    local len = 0
    local options_listed = options.listed
    local vim_fn = vim.fn
    local buflisted = vim_fn.buflisted

    for buffer = 1, vim_fn.bufnr('$') do
        if not options_listed or buflisted(buffer) ~= 1 then
            len = len + 1
            buffers[len] = buffer
        end
    end

    return buffers
end

local function  neo_reveal()
    local reveal_file = vim.fn.expand('%:p')
    if (reveal_file == '') then
      reveal_file = vim.fn.getcwd()
    else
      local f = io.open(reveal_file, "r")
      if (f) then
        f.close(f)
      else
        reveal_file = vim.fn.getcwd()
      end
    end
    require('neo-tree.command').execute({
      action = "focus",          -- OPTIONAL, this is the default value
      source = "filesystem",     -- OPTIONAL, this is the default value
      position = "left",         -- OPTIONAL, this is the default value
      reveal_file = reveal_file, -- path to file or folder to reveal
      toggle = true,
      reveal_force_cwd = true,   -- change cwd without asking if needed
    })
end

local function get_git_root()
    local dot_git_path = vim.fn.finddir(".git", ".;")
    return vim.fn.fnamemodify(dot_git_path, ":h")
end

local function find_file_from_git()
    require("telescope.builtin").find_files({cwd=get_git_root()})
end
local function live_grep_from_git()
    require("telescope.builtin").live_grep({cwd=get_git_root()})
end

local function quit_keep_last()
    if vim.fn.winnr('$') ~= 1  then
      if vim.fn.getbufvar(vim.fn.bufnr(), '&buftype') == 'terminal' then
        vim.cmd('bd!')
      else
        vim.cmd('quit')
      end
    else
      vim.cmd('echo "is last window"')
    end
end

local function close_buffer_keep_last()
    require("astronvim.utils.buffer").close() 
end

local function replace_search_n()
    local w = vim.fn.getreg('/')
    vim.fn.feedkeys(":%s/" .. w .. "/" .. w .."/gc", "n")
    local k = vim.api.nvim_replace_termcodes("<left><left><left>", true, false, true)
    vim.api.nvim_feedkeys(k, "n", false)
end
local function replace_search_v()
    local w = vim.fn.getreg('/')
    vim.fn.feedkeys(":s/" .. w .. "/" .. w .."/gc", "n")
    local k = vim.api.nvim_replace_termcodes("<left><left><left>", true, false, true)
    vim.api.nvim_feedkeys(k, "n", false)
end
local function get_dict(k)
    local scripts = vim.api.nvim_exec2("!sdcv -n "..k, {output=true})
    local dic = vim.split(scripts.output, '\n')
    for i=1,3 do
      table.remove(dic, 1)
    end
    -- print(vim.v.errmsg)
    return dic
end
local function float_dict(wd)
    local buf = vim.api.nvim_create_buf(false, true)
    -- local wd = vim.fn.expand('<cword>')
    local dic = get_dict(wd)
    if table.getn(dic) == 1 then
      -- vim.cmd("echo 'no result'")
      -- return
      dic = {'no result'}
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, true, dic)
    local opts = {relative= 'cursor', width=80, height=table.getn(dic), col= 1,
        row= 1, anchor= 'NW', border="single"}
    local win = vim.api.nvim_open_win(buf, 0, opts)
    -- vim.o.foldcolumn = 0
    vim.api.nvim_win_set_option(win, 'foldcolumn', '0')
end

local function float_dict_n()
    float_dict(vim.fn.expand('<cword>'))
end
local function float_dict_v()
    local mode = vim.fn.mode()
    if mode ~= 'v' and mode ~= 'V' then
      vim.cmd('normal! gv')
    end
    vim.cmd('silent! normal! "zygv')
    float_dict(vim.fn.getreg('z'))
end


return {
  -- first key is the mode
  i={
    ["<<"] = {"<><Left>"},
    ["(("] = {"()<Left>"},
    ["[["] = {"[]<Left>"},
    ["{{"] = {"{}<Left>"},
    ["''"] = {"''<Left>"},
    ['""'] = {'""<Left>'},
    ["{<CR>"] = {"{<CR>}<Esc>O<Tab>"},
    ["[<CR>"] = {"[<CR>]<Esc>O<Tab>"},
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
    -- mappings seen under group name "Buffer"
    ['s'] = "<nop>",
    ['c'] = "<nop>",
    ['cc'] = "<nop>",
    ["gh"] = "<nop>",
    ["Q"] = "<nop>",
    ["q"] = "<nop>",
    ["gq"] = "q",
    ['q:'] = ":",
    ['H'] = "h",
    ['J'] = "j",
    ['K'] = "k",
    ['L'] = "l",
    ['j'] = "gj",
    ['k'] = "gk",
    ['gK'] = "K",
    ["gJ"] = { "mzJ`z" },
    ["<F1>"] = "K",
    -- ['<leader>W'] = false,
    ['<leader>C'] = false,
    ['<leader>c'] = false,
    ['<leader>q'] = false,
    ["<leader>o"] = { function() require("telescope.builtin").oldfiles() end, desc = "Find history" },
    ['<leader>Q'] = false,
    ['<leader><leader>'] = {'zA', desc="Toggle fold"},
    ["]b"] = false,
    ["[b"] = false,
    ["<a-2>"] = {
      replace_search_n,
      desc = "Substitute",
    },
    ["<F2>"] = {
      replace_search_n,
      desc = "Substitute",
    },
    ["<leader>bn"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<leader>bp"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },
    ["-"] = { "<c-x>", desc = "Descrement number" },
    ["+"] = { "<c-a>", desc = "Increment number" },
    ['<C-W>1'] = {'<cmd>resize<cr>', desc="Resize Max"},
    ['<C-W>2'] = {'<c-w>=', desc="Resize Equal"},
    ['<C-W>t'] = {'<c-w>T'},
    ['<C-W><C-q>'] = { quit_keep_last },
    ['<C-W>q'] = { quit_keep_last },
    ['<C-Z>'] = {'uzv'},
    ['#'] = {'/<C-R><C-W><CR>'},
    ['<C-Y>'] = {'<C-R>zv'},
    ['<C-A>'] = {'ggVG'},
    ['<C-Q>'] = {'<C-V>'},
    ['<C-q>'] = {'<C-V>'},
    ['<C-V>'] = {'"+gP'},
    ['<leader>tt'] = {float_dict_n},
    -- ['<leader>te'] = {'viw:Translate EN<CR>:echo<CR>'},
    ['<leader>tr'] = {':TroubleToggle<CR>'},
    ["<leader>i"] = { name = "󰒡 Diagnostic" },
    ['<leader>ii'] = {
      function()  
          vim.diagnostic.open_float()
      end,
      desc = "show diagnostic",
    },
    ['<leader>in'] = {vim.diagnostic.goto_next, desc="next"},
    ['<leader>ip'] = {vim.diagnostic.goto_prev, desc="prev"},
    ["<c-p>"] = { find_file_from_git },
    ["<leader>gg"] = { live_grep_from_git },
    ["<c-e>ww"] = { "<cmd>edit /home/ryk/_0wikis/wiki_new/index.rst<cr>", desc="Open Wiki"},
    ["<leader>b"] = { name = "Buffers" },
    ["<leader>c"] = { name = "comment" },
    ["<leader>cd"] = {
      function()
        vim.cmd('cd %:h')
        vim.cmd('pwd')
      end,
      desc = "cd with current file"
    },
    ga = { "<Plug>(EasyAlign)", desc = "Easy Align" },
    ["<leader>bd"] = {close_buffer_keep_last},
    ["<c-w>c"] = {close_buffer_keep_last},
    ["<leader>v"] = { name = "vimrcs" },
    ["<leader>vi"] = {"<cmd>edit /home/ryk/.config/nvim/lua/user/init.lua<cr>"},
    ["<leader>vv"] = {"<cmd>edit /home/ryk/.config/nvim/lua/user/mappings.lua<cr>"},
    ["<leader>vo"] = {"<cmd>edit /home/ryk/.vim/vimrc<cr>"},
    ["<leader>vr"] = {":AstroReload<cr>"},
    ["<leader>r"] = { name = "󰇥 Godot" },
    ["<leader>rr"] = { 
      "<cmd>sp | term godot4 --path /home/ryk/godot/SLG_P2 /home/ryk/godot/SLG_P2/temp/test.tscn<cr>",
      desc="godot Test Scene",
    },
    ["<leader>re"] = { 
      "<cmd>sp | term godot4 --path /home/ryk/godot/SLG_P2 --editor --quit<cr>",
      desc="godot Reimport",
    },
    ["<leader>rt"] = { 
      "<cmd>sp | term godot4 --headless -s /home/ryk/godot/SLG_P2/temp/min_test.gd<cr>",
    },
    ["<leader>vt"] = { 
      "<cmd>sp /home/ryk/godot/SLG_P2/temp/min_test.gd<cr>",
    },
    ["<leader>z"] = { name = "Zen mode" },
    ["<leader>zz"] = {
      ":ZenMode<CR>:echo<CR>"
    },
    ["<leader>e"] = {
      neo_reveal,
      desc = "Toggle Explorer",
    },
    ["<leader>cc"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Toggle comment line",
    },
    ["<leader>zz"] = {
      ":ZenMode<CR>:echo<CR>"
    },
    ["<leader>e"] = {
      neo_reveal,
      desc = "Toggle Explorer Focus",
    },

    ["<leader>cc"] = {
      function() require("Comment.api").toggle.linewise.count(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Toggle comment line",
    },
  },
  v={
    ["<leader>cc"] = {
      "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<cr>",
    },
    ['<C-c>'] = {'y'},
    ['<C-v>'] = {'"0c<C-R>+<Esc>'},
    -- ['#'] = {'*'},
    ['#'] = {'<esc>gv"zy/<C-R>z<cr>'},
    ['*'] = {'<esc>gv"zy?<C-R>z<cr>'},
    ["<F2>"] = {
      replace_search_v,
      desc = "Substitute",
    },
    ["<a-2>"] = {
      replace_search_v,
      desc = "Substitute",
    },
    ga = { "<Plug>(EasyAlign)", desc = "Easy Align" },
    ['j'] = "gj",
    ['k'] = "gk",
    ['>'] = ">gv",
    ['<'] = "<gv",
    ['c'] = "<nop>",
    ['<leader>tt'] = {float_dict_v},
  },
  t={
    ['<Esc>'] = "<c-\\><c-N>",
  },
}
