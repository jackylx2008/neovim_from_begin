-- 是否在屏幕最后一行显示命令 
-- set.showcmd = true 
-- 是否开启语法高亮 
-- set.syntax = "enable" 
-- 是否特殊显示空格等字符 
-- set.list = true 
-- 设定自动缩进的策略为 plugin 
-- set.filetype = "plugin" 
-- 是否开启命令行补全 
-- set.wildmenu = true 
-- 是否开启单词拼写检查 
-- set.spell = true 
-- 设定单词拼写检查的语言 
-- set.spelllang = "en_us,cjk" 
-- 是否开启代码折叠 
-- set.foldenable = true 
-- 指定代码折叠的策略是按照缩进进行的 
-- set.foldmethod = "indent"

local options =  {
foldlevel = 100,  -- 指定代码折叠的最高层级为 100
-- textwidth = 80                      -- 经过试验发现这个参数对于英文采用空格分隔的文本有效，如果是中文没有空格分割就没有效果
textwidth = 0, -- 默认值为0，主要解决markdown文件中输入的时候一行太多了自动换行
hidden = true, -- Required to keep multiple buffers open multiple buffers 跟缓存有关，似乎是与其他app的缓存互通，可以打开和浏览
-- indowlocal.wrap = true
wrap = true,-- Display long lines as just one line 小哥说他不喜欢一长行的行号被分割？自动折行，原小哥设置是nowrap，写一根长句子不会自动折行，一行到底
encoding = "utf-8", -- The encoding displayed utf-8编码模式显示
pumheight = 10, -- Makes popup menu smaller 弹出窗口显示几行内容
fileencoding = "utf-8", -- The encoding written to file
ruler = true, -- Show the cursor position all the time 显示光标所在的行号和列号
cmdheight = 2, -- More space for displaying messags 下方命令行高度

mouse = "a", -- Enable your mouse 在nvim界面可以用鼠标点击移动光标到点击位置
splitbelow = true, -- Horizontal splits will automatically be below
splitright = true, -- Vertical splits will automatically be to the right
conceallevel = 0, -- So that I can see `` in markdown files
tabstop = 4, -- Insert 4 spaces for a tab
shiftwidth = 4, -- Change the number of space characters inserted for indentation
smarttab = true, -- Makes tabbing smarter will realize you have 2 vs 4
expandtab = true, -- Converts tabs to spaces
-- ufferlocal.expandtab = true                         -- Converts tabs to spaces
smartindent = true, -- Makes indenting smart文件类型自动检测
autoindent = true, -- Good auto indent自动换行对齐
-- ufferlocal.autoindent = true
relativenumber = false, -- 设置相对行号
number = true, -- set numbered lines
-- indowlocal.number = true                            -- Line numbers 显示行号
-- background = "dark" -- tell vim what the background color looks like
showtabline = 4, -- Always show tabs
showmode = false, -- We don't need to see things like -- INSERT -- anymore
backup = false, -- This is recommended by coc
writebackup = false, -- This is recommended by coc
updatetime = 100, -- Faster completion
timeoutlen = 200, -- By default timeoutlen is 1000 ms

-- formatoptions-=cro                -- Stop newline continution of comments

clipboard = "unnamedplus", -- Copy paste between vim and everything else app之间共享剪贴板

cursorline = true, -- 突出显示当前行
laststatus = 2, -- Always display the status line

-- Avoids updating the screen before commands are completed
lazyredraw = true,
shortmess = "c",
whichwrap = "b,s,<,>,[,],h,l",
scrolloff = 8,
sidescrolloff = 5,

colorcolumn = "99999", -- fixes indentline for now
guifont = "monospace:h17", -- the font used in graphical neovim applications
foldexpr = "", -- set to "nvim_treesitter#foldexpr()" for treesitter based folding
hlsearch = true, -- highlight all matches on previous search pattern
ignorecase = true, -- ignore case in search patterns
smartcase = true, -- smart case
swapfile = false, -- creates a swapfile
title = true, -- set the title of window to the value of the titlestring
undofile = true, -- enable persistent undo
numberwidth = 2, -- set number column width to 2 {default 4}
signcolumn = "yes", -- always show the sign column ,otherwise it would shift the text each time
-- foldmethod = "manual", -- folding, set to "expr" for treesitter based folding
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- 是否透明背景
vim.g.background_transparency = true
vim.opt.completeopt = {"menuone", "noselect"} -- mostly just for cmp
vim.opt.termguicolors = true -- 设置采用True color

vim.cmd "set whichwrap+=<,>,[,],h,l"
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]] -- TODO: this doesn't seem to work
-- vim.opt_local.formatoptions = vim.opt_local.formatoptions - {"c", "r", "o"}

vim.cmd("filetype plugin indent on") -- 根据语言设置不同的缩进
-- vim.opt.iskeyword:append({"-"}) -- treat dash separated words as a word text objec 字母含有'-'认为是一个单词
-- setwindowlocal.signcolumn = "yes"

-- 原版
--[[ vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = "a"                             -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.fillchars.eob=" "
vim.opt.shortmess:append "c"
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-") ]]
