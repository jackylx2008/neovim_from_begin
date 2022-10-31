-- In Mac
-- m = option
-- C = ctrl
local M = {}
local opts = { noremap = true, silent = true }
local expr_opts = { noremap = true, expr = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("n", "<Space>", "", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
keymap("n", "<C-Space>", "<cmd>WhichKey \\<leader><cr>", opts)
keymap("n", "<C-i>", "<C-i>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Center search results
keymap("n", "n", "nzz", opts)
keymap("n", "N", "Nzz", opts)

-- Cancel search highlighting with ESC
keymap("n", "<ESC>", ":nohlsearch<Bar>:echo<CR>", opts)

-- Better window navigation
keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)
keymap("n", "<M-tab>", "<c-6>", opts)

-- Tabs --
keymap("n", "<M-t>", ":tabnew %<cr>", opts)
keymap("n", "<M-y>", ":tabclose<cr>", opts)
keymap("n", "<M-\\>", ":tabonly<cr>", opts)

-- Resize with arrows
keymap("n", "<Up>", ":resize +2<CR>", opts)
keymap("n", "<Down>", ":resize -2<CR>", opts)
keymap("n", "<Left>", ":vertical resize +2<CR>", opts)
keymap("n", "<Right>", ":vertical resize -2<CR>", opts)

-- I hate typing these
keymap("n", "H", "^", opts)
keymap("n", "L", "$", opts)
keymap("v", "H", "^", opts)
keymap("v", "L", "$", opts)
keymap("x", "H", "^", opts)
keymap("x", "L", "$", opts)
keymap("o", "H", "^", opts)
keymap("o", "L", "$", opts)

-- keymap("n", "n", "nzzzv", opts)
-- keymap("n", "N", "Nzzzv", opts)

-- Naviagate buffers
keymap("n", "<TAB>", ":bnext<CR>", opts)
keymap("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter
-- Better escape using jk in insert and terminal mode
keymap("i", "jk", "<Esc>", opts)
keymap("i", "kj", "<Esc>", opts)
keymap("i", "jj", "<Esc>", opts)
keymap("t", "jk", "<C-\\><C-n>", opts)
keymap("t", "kj", "<C-\\><C-n>", opts)
keymap("t", "jj", "<C-\\><C-n>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
-- Paste over currently selected text without yanking it
keymap("v", "p", '"_dP', opts)
-- keymap("v", "P", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Custom
-- keymap("n", "<c-h>", "<cmd>nohlsearch<cr>", opts)
-- NOTE: the fact that tab and ctrl-i are the same is stupid
-- keymap("n", "<TAB>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "Q", "<cmd>Bdelete!<CR>", opts)
keymap("n", "<F1>", ":e ~/Notes/<cr>", opts)
keymap("n", "<F3>", ":e .<cr>", opts)
keymap("n", "<F4>", "<cmd>Telescope resume<cr>", opts)
keymap("n", "<F5>", "<cmd>Telescope commands<CR>", opts)

-- WARN: 下述配置功能未知
keymap(
        "n",
        "<F6>",
        [[:echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>]],
        opts
)
keymap("n", "<F7>", "<cmd>TSHighlightCapturesUnderCursor<cr>", opts)
keymap("n", "<F8>", "<cmd>TSPlaygroundToggle<cr>", opts)
keymap("n", "<F11>", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<F12>", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("v", "//", [[y/\V<C-R>=escape(@",'/\')<CR><CR>]], opts)
keymap("n", "<C-p>", "<cmd>Telscope projects<cr>", opts)
keymap("n", "<C-t>", "<cmd>lua vim.lsp.buf.document_symbol()<cr>", opts)
-- keymap("n", "<C-s>", "<cmd>vsplit<cr>", opts)
keymap("n", "<C-z>", "<cmd>ZenMode<cr>", opts)
keymap("n", "<c-n>", ":e ~/Notes/<cr>", opts)
keymap("n", "-", ":lua require'lir.float'.toggle()<cr>", opts)
-- keymap("n", "<C-\\>", "<cmd>vsplit<cr>", opts)
-- vim.cmd[[nnoremap c* /\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn]]
-- vim.cmd[[nnoremap c# ?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN]]
-- keymap("n", "c*", [[/\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgn]], opts)
-- keymap("n", "c#", [[?\<<C-R>=expand('<cword>')<CR>\>\C<CR>``cgN]], opts)
-- keymap("n", "gx", [[:execute '!brave ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)
keymap("n", "gx", [[:silent execute '!$BROWSER ' . shellescape(expand('<cfile>'), 1)<CR>]], opts)
-- Change '<CR>' to whatever shortcut you like :)
-- vim.api.nvim_set_keymap("n", "<CR>", "<cmd>NeoZoomToggle<CR>", { noremap = true, silent = true, nowait = true })
vim.api.nvim_set_keymap("n", "=", "<cmd>JABSOpen<cr>", { noremap = true, silent = true, nowait = true })

-- alt binds
-- keymap("n", "<m-s>", "<cmd>split<cr>", opts)
keymap("n", "<m-v>", "<cmd>lua require('lsp_lines').toggle()<cr>", opts)
-- keymap("n", "<m-q>", "<cmd>:q<cr>", opts)

M.show_documentation = function()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ "vim", "help" }, filetype) then
                vim.cmd("h " .. vim.fn.expand("<cword>"))
        elseif vim.tbl_contains({ "man" }, filetype) then
                vim.cmd("Man " .. vim.fn.expand("<cword>"))
        elseif vim.fn.expand("%:t") == "Cargo.toml" then
                require("crates").show_popup()
        else
                vim.lsp.buf.hover()
        end
end
-- vim.api.nvim_set_keymap("n", "K", ":lua require('user.keymaps').show_documentation()<CR>", opts)

-- vim.api.nvim_set_keymap("n", "<m-b>", "<cmd>lua require('user.bfs').open()<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<m-b>", "<cmd>JABSOpen<cr>", opts)
-- vim.api.nvim_set_keymap("n", "<m-e>", "NvimTreeToggle<cr>", opts)
-- vim.api.nvim_set_keymap(
--   "n",
--   "<m-f>",
--   "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--   opts
-- )
-- Comment
-- keymap("n", "<m-/>", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
-- keymap("x", "<m-/>", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', opts)

-- vim.api.nvim_set_keymap(
--   "n",
--   "<tab>",
--   "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--   opts
-- )

-- vim.api.nvim_set_keymap("n", "<tab>", "<cmd>lua require('telescope.builtin').extensions.harpoon.marks(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>", opts)

-- vim.api.nvim_set_keymap(
--     "n",
--     "<tab>",
--     "<cmd>lua require('telescope').extensions.harpoon.marks(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal', prompt_title='Harpoon'})<cr>",
--     opts
-- )
-- vim.api.nvim_set_keymap(
--     "n",
--     "<s-tab>",
--     "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false, initial_mode='normal'})<cr>",
--     opts
-- )
-- vim.api.nvim_set_keymap("n", "<tab>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", opts)
vim.api.nvim_set_keymap("n", "<m-g>", "<cmd>Telescope git_branches<cr>", opts)
vim.api.nvim_set_keymap("n", "<s-enter>", "<cmd>TodoQuickFix<cr>", opts)
-- l = { "<cmd>lua require('user.bfs').open()<cr>", "Buffers" },

vim.cmd([[
  function! QuickFixToggle()
    if empty(filter(getwininfo(), 'v:val.quickfix'))
      copen
    else
      cclose
    endif
  endfunction
]])

keymap("n", "<m-q>", ":call QuickFixToggle()<cr>", opts)
keymap("n", "<c-l>", "<cmd>lua vim.lsp.codelens.run()<cr>", opts)

-- My configration
-- Tab complete
-- keymap("i", "<expr><TAB>", 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', { norekeymap = true, silent = true })

-- Allow moving the cursor through wrapped lines with j, k, <Up> and <Down>
-- http://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
-- empty mode is same as using :keymap
-- also don't use g[j|k] when in operator pending mode, so it doesn't alter d, y or c behaviour
keymap("", "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
keymap("", "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
keymap("", "<Down>", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true })
keymap("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true })
-- don't yank text on cut ( x )
-- keymap({ "n", "v" }, "x", '"_x')
-- don't yank text on delete ( dd )
-- keymap({ "n", "v" }, "d", '"_d')
-- keymap("", "<F9>",":w<CR> :!clear && g++ % <CR>", opts)
-- keymap("", "<C-F9>",":w<CR> :!clear && g++ % -o %< && ./%< <CR>", opts)

-- keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
-- keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
return M

-- 原版
--[[ -- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)
-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)
-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)
-- Better paste
keymap("v", "p", '"_dP', opts)
-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- Plugins --
-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')
-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts) ]]
