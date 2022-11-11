diff --git a/after/plugin/keymaps.lua b/after/plugin/keymaps.lua
index b448738..d9b2fe6 100644
--- a/after/plugin/keymaps.lua
+++ b/after/plugin/keymaps.lua
@@ -237,8 +237,8 @@ keymap("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true
 -- keymap("", "<F9>",":w<CR> :!clear && g++ % <CR>", opts)
 -- keymap("", "<C-F9>",":w<CR> :!clear && g++ % -o %< && ./%< <CR>", opts)
 
--- keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
--- keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
+keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
+keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
 return M
 
 -- 原版
diff --git a/lua/config/cmp.lua b/lua/config/cmp.lua
index 0931002..ffc53d6 100644
--- a/lua/config/cmp.lua
+++ b/lua/config/cmp.lua
@@ -1,35 +1,5 @@
 local M = {}
 
-vim.o.completeopt = "menu,menuone,noselect"
-
-local kind_icons = {
-  Text = "",
-  Method = "",
-  Function = "",
-  Constructor = "",
-  Field = "",
-  Variable = "",
-  Class = "ﴯ",
-  Interface = "",
-  Module = "",
-  Property = "ﰠ",
-  Unit = "",
-  Value = "",
-  Enum = "",
-  Keyword = "",
-  Snippet = "",
-  Color = "",
-  File = "",
-  Reference = "",
-  Folder = "",
-  EnumMember = "",
-  Constant = "",
-  Struct = "",
-  Event = "",
-  Operator = "",
-  TypeParameter = "",
-}
-
 function M.setup()
   local has_words_before = function()
     local line, col = unpack(vim.api.nvim_win_get_cursor(0))
@@ -47,30 +17,13 @@ function M.setup()
         require("luasnip").lsp_expand(args.body)
       end,
     },
-    -- formatting = {
-    --   format = function(entry, vim_item)
-    --     vim_item.menu = ({
-    --       buffer = "[Buffer]",
-    --       luasnip = "[Snip]",
-    --       nvim_lua = "[Lua]",
-    --       treesitter = "[Treesitter]",
-    --     })[entry.source.name]
-    --     return vim_item
-    --   end,
-    -- },
     formatting = {
       format = function(entry, vim_item)
-        -- Kind icons
-        vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
-        -- Source
         vim_item.menu = ({
-          nvim_lsp = "[LSP]",
           buffer = "[Buffer]",
           luasnip = "[Snip]",
           nvim_lua = "[Lua]",
           treesitter = "[Treesitter]",
-          path = "[Path]",
-          -- nvim_lsp_signature_help = "[Signature]",
         })[entry.source.name]
         return vim_item
       end,
diff --git a/lua/config/lsp/formatting.lua b/lua/config/lsp/formatting.lua
deleted file mode 100644
index 649ec2a..0000000
--- a/lua/config/lsp/formatting.lua
+++ /dev/null
@@ -1,44 +0,0 @@
-local M = {}
-
-local util = require "util"
-
-M.autoformat = true
-
-function M.toggle()
-  M.autoformat = not M.autoformat
-  if M.autoformat then
-    util.info("enabled format on save", "Formatting")
-  else
-    util.warn("disabled format on save", "Formatting")
-  end
-end
-
-function M.format()
-  if M.autoformat then
-    vim.lsp.buf.formatting_sync(nil, 2000)
-  end
-end
-
-function M.setup(client, buf)
-  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
-  local nls = require "config.lsp.null-ls"
-
-  local enable = false
-  if nls.has_formatter(ft) then
-    enable = client.name == "null-ls"
-  else
-    enable = not (client.name == "null-ls")
-  end
-
-  client.server_capabilities.document_formatting = enable
-  if client.server_capabilities.document_formatting then
-    vim.cmd [[
-      augroup LspFormat
-        autocmd! * <buffer>
-        autocmd BufWritePre <buffer> lua require("config.lsp.formatting").format()
-      augroup END
-    ]]
-  end
-end
-
-return M
diff --git a/lua/config/lsp/handlers.lua b/lua/config/lsp/handlers.lua
deleted file mode 100644
index 0eaa577..0000000
--- a/lua/config/lsp/handlers.lua
+++ /dev/null
@@ -1,46 +0,0 @@
-local M = {}
-
-function M.setup()
-  -- LSP handlers configuration
-  local lsp = {
-    float = {
-      focusable = true,
-      style = "minimal",
-      border = "rounded",
-    },
-    diagnostic = {
-      -- virtual_text = true,
-      virtual_text = { spacing = 4, prefix = "●" },
-      underline = true,
-      update_in_insert = false,
-      severity_sort = true,
-      float = {
-        focusable = true,
-        style = "minimal",
-        border = "rounded",
-      },
-    },
-  }
-
-  -- Diagnostic signs
-  local diagnostic_signs = {
-    { name = "DiagnosticSignError", text = "" },
-    { name = "DiagnosticSignWarn", text = "" },
-    { name = "DiagnosticSignHint", text = "" },
-    { name = "DiagnosticSignInfo", text = "" },
-  }
-  for _, sign in ipairs(diagnostic_signs) do
-    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
-  end
-
-  -- Diagnostic configuration
-  vim.diagnostic.config(lsp.diagnostic)
-
-  -- Hover configuration
-  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, lsp.float)
-
-  -- -- Signature help configuration
-  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, lsp.float)
-end
-
-return M
diff --git a/lua/config/lsp/highlighting.lua b/lua/config/lsp/highlighting.lua
deleted file mode 100644
index 1c3ef0e..0000000
--- a/lua/config/lsp/highlighting.lua
+++ /dev/null
@@ -1,42 +0,0 @@
-local M = {}
-
-local utils = require "utils"
-
-M.highlight = true
-
-function M.toggle()
-  M.highlight = not M.highlight
-  if M.highlight then
-    utils.info("Enabled document highlight", "Document Highlight")
-  else
-    utils.warn("Disabled document highlight", "Document Highlight")
-  end
-end
-
-function M.highlight(client)
-  if M.highlight then
-    if client.server_capabilities.document_highlight then
-      local present, illuminate = pcall(require, "illuminate")
-      if present then
-        illuminate.on_attach(client)
-      else
-        vim.api.nvim_exec(
-          [[
-            augroup lsp_document_highlight
-              autocmd! * <buffer>
-              autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
-              autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
-            augroup END
-          ]],
-          false
-        )
-      end
-    end
-  end
-end
-
-function M.setup(client)
-  M.highlight(client)
-end
-
-return M
diff --git a/lua/config/lsp/init.lua b/lua/config/lsp/init.lua
index ab846c2..ecb82c0 100644
--- a/lua/config/lsp/init.lua
+++ b/lua/config/lsp/init.lua
@@ -4,29 +4,7 @@ local servers = {
   html = {},
   jsonls = {},
   pyright = {},
-  sumneko_lua = {
-    settings = {
-      Lua = {
-        runtime = {
-          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
-          version = "LuaJIT",
-          -- Setup your lua path
-          path = vim.split(package.path, ";"),
-        },
-        diagnostics = {
-          -- Get the language server to recognize the `vim` global
-          globals = { "vim" },
-        },
-        workspace = {
-          -- Make the server aware of Neovim runtime files
-          library = {
-            [vim.fn.expand "$VIMRUNTIME/lua"] = true,
-            [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
-          },
-        },
-      },
-    },
-  },
+  sumneko_lua = {},
   vimls = {},
   clangd = {},
   marksman = {},
@@ -35,14 +13,6 @@ local servers = {
   -- rust_analyzer = {},
 }
 
-local lsp_signature = require "lsp_signature"
-lsp_signature.setup {
-  bind = true,
-  handler_opts = {
-    border = "rounded",
-  },
-}
-
 local function on_attach(client, bufnr)
   -- Enable completion triggered by <C-X><C-O>
   -- See `:help omnifunc` and `:help ins-completion` for more information.
@@ -54,11 +24,15 @@ local function on_attach(client, bufnr)
 
   -- Configure key mappings
   require("config.lsp.keymaps").setup(client, bufnr)
-
-  -- Configure highlighting
-  require("config.lsp.highlighting").setup(client)
 end
 
+local lsp_signature = require "lsp_signature"
+lsp_signature.setup {
+  bind = true,
+  handler_opts = {
+    border = "rounded",
+  },
+}
 
 local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
 
@@ -70,9 +44,6 @@ local opts = {
   },
 }
 
--- Setup LSP handlers
-require("config.lsp.handlers").setup()
-
 function M.setup()
   require("config.lsp.installer").setup(servers, opts)
 end
diff --git a/lua/config/lsp/installer.lua b/lua/config/lsp/installer.lua
index 5c3070c..012eb69 100644
--- a/lua/config/lsp/installer.lua
+++ b/lua/config/lsp/installer.lua
@@ -10,11 +10,6 @@ function M.setup(servers, options)
     if server_available then
       server:on_ready(function()
         local opts = vim.tbl_deep_extend("force", options, servers[server.name] or {})
-
-        -- if server.name == "sumneko_lua" then
-        --   opts = require("neodev").setup { lspconfig = opts }
-        -- end
-
         server:setup(opts)
       end)
 
diff --git a/lua/config/lsp/keymaps.lua b/lua/config/lsp/keymaps.lua
index ee54690..7666cd4 100644
--- a/lua/config/lsp/keymaps.lua
+++ b/lua/config/lsp/keymaps.lua
@@ -27,7 +27,7 @@ local function keymappings(client, bufnr)
   }
   -- if client.resolved_capabilities.document_formatting then
   if client.server_capabilities.documentFormattingProvider then
-    keymap_l.l.f = { "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", "Format Document" }
+    keymap_l.l.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
   end
 
   local keymap_g = {
diff --git a/lua/config/lsp/t.py b/lua/config/lsp/t.py
new file mode 100644
index 0000000..e69de29
diff --git a/lua/config/lualine.lua b/lua/config/lualine.lua
index 74d3d47..fe25929 100644
--- a/lua/config/lualine.lua
+++ b/lua/config/lualine.lua
@@ -1,61 +1,5 @@
 local M = {}
 
--- Color table for highlights
-local colors = {
-  bg = "#202328",
-  fg = "#bbc2cf",
-  yellow = "#ECBE7B",
-  cyan = "#008080",
-  darkblue = "#081633",
-  green = "#98be65",
-  orange = "#FF8800",
-  violet = "#a9a1e1",
-  magenta = "#c678dd",
-  blue = "#51afef",
-  red = "#ec5f67",
-}
-
-local function separator()
-  return "%="
-end
-
-local function lsp_client()
-  local buf_clients = vim.lsp.buf_get_clients()
-  if next(buf_clients) == nil then
-    return ""
-  end
-  local buf_client_names = {}
-  for _, client in pairs(buf_clients) do
-    if client.name ~= "null-ls" then
-      table.insert(buf_client_names, client.name)
-    end
-  end
-  return "[" .. table.concat(buf_client_names, ", ") .. "]"
-end
-
-local function lsp_progress(_, is_active)
-  if not is_active then
-    return
-  end
-  local messages = vim.lsp.util.get_progress_messages()
-  if #messages == 0 then
-    return ""
-  end
-  local status = {}
-  for _, msg in pairs(messages) do
-    local title = ""
-    if msg.title then
-      title = msg.title
-    end
-    table.insert(status, (msg.percentage or 0) .. "%% " .. title)
-  end
-  local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-  local ms = vim.loop.hrtime() / 1000000
-  local frame = math.floor(ms / 120) % #spinners
-  return table.concat(status, "  ") .. " " .. spinners[frame + 1]
-end
-
-
 function M.setup()
   local gps = require "nvim-gps"
 
@@ -79,13 +23,7 @@ function M.setup()
           color = { fg = "#f3ca28" },
         },
       },
-      lualine_x = {
-        { lsp_client, icon = " ", color = { fg = colors.violet, gui = "bold" } },
-        { lsp_progress },
-        "encoding",
-        "fileformat",
-        "filetype"
-      },
+      lualine_x = { "encoding", "fileformat", "filetype" },
       lualine_y = { "progress" },
       lualine_z = { "location" },
     },
diff --git a/lua/config/whichkey.lua b/lua/config/whichkey.lua
index 735542c..7cc5783 100644
--- a/lua/config/whichkey.lua
+++ b/lua/config/whichkey.lua
@@ -123,7 +123,7 @@ function M.setup()
       m = { "<cmd>BrowseMdnSearch<cr>", "Mdn" },
     },
 
-    p = {
+    P = {
       name = "Packer",
       c = { "<cmd>PackerCompile profile=true<cr>", "Compile" },
       p = { "<cmd>PackerProfile<cr>", "Profile" },
@@ -217,7 +217,7 @@ function M.setup()
       r = { "<cmd>Telescope file_browser<cr>", "Browser" },
       w = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer" },
     },
-      P = {
+      p = {
         name = "Project",
         p = { "<cmd>lua require'telescope'.extensions.project.project{}<cr>", "List" },
         s = { "<cmd>Telescope repo list<cr>", "Search" },
diff --git a/lua/plugins.lua b/lua/plugins.lua
index 648fc27..a5cf9a1 100644
--- a/lua/plugins.lua
+++ b/lua/plugins.lua
@@ -1,5 +1,6 @@
 local fn = vim.fn
 
+
 -- Automatically install packer
 local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
 if fn.empty(fn.glob(install_path)) > 0 then
@@ -15,7 +16,6 @@ if fn.empty(fn.glob(install_path)) > 0 then
   vim.cmd([[packadd packer.nvim]])
 end
 
-
 -- Autocommand that reloads neovim whenever you save the plugins.lua file
 -- vim.cmd([[
 --   augroup packer_user_config
@@ -47,33 +47,33 @@ return packer.startup(function(use)
 
   -- Colorschemes
   use({
-    "sainnhe/everforest",
-    config = function()
-      vim.cmd([[colorscheme everforest]])
-    end,
+      "sainnhe/everforest",
+      config = function()
+        vim.cmd([[colorscheme everforest]])  
+      end,
   })
   -- Startup Screen
   use({
-    "goolord/alpha-nvim",
-    config = function()
-      require("config.alpha").setup()
-    end,
+      "goolord/alpha-nvim",
+      config = function()
+        require("config.alpha").setup()
+      end,
   })
   -- Git
   use({
-    "TimUntersberger/neogit",
-    cmd = "Neogit",
-    config = function()
-      require("config.neogit").setup()
-    end,
+      "TimUntersberger/neogit",
+      cmd = "Neogit",
+      config = function()
+        require("config.neogit").setup()
+      end,
   })
   -- Whichkey
   use({
-    "folke/which-key.nvim",
-    event = "VimEnter",
-    config = function()
-      require("config.whichkey").setup()
-    end,
+      "folke/which-key.nvim",
+      event = "VimEnter",
+      config = function()
+        require("config.whichkey").setup()
+      end,
   })
   -- IndentLine
   use {
@@ -178,14 +178,14 @@ return packer.startup(function(use)
 
   -- nvim-tree
   use {
-    "kyazdani42/nvim-tree.lua",
-    requires = {
-      "kyazdani42/nvim-web-devicons",
-    },
-    cmd = { "NvimTreeToggle", "NvimTreeClose" },
-    config = function()
-      require("config.nvimtree").setup()
-    end,
+   "kyazdani42/nvim-tree.lua",
+   requires = {
+     "kyazdani42/nvim-web-devicons",
+   },
+   cmd = { "NvimTreeToggle", "NvimTreeClose" },
+     config = function()
+     require("config.nvimtree").setup()
+   end,
   }
 
   -- Buffer line
@@ -270,67 +270,42 @@ return packer.startup(function(use)
       "williamboman/nvim-lsp-installer",
       "hrsh7th/cmp-nvim-lsp",
       "ray-x/lsp_signature.nvim",
-      -- "folke/neodev.nvim",
-      "RRethy/vim-illuminate",
     },
   }
 
-  use {
-    "nvim-telescope/telescope.nvim",
-    -- opt = true,
-    config = function()
-      require("config.telescope").setup()
-    end,
-    -- cmd = { "Telescope" },
-    -- -- module = "telescope",
-    -- keys = { "<leader>f", "<leader>p" },
-    wants = {
-      "plenary.nvim",
-      "popup.nvim",
-      "telescope-fzf-native.nvim",
-      "telescope-project.nvim",
-      "telescope-repo.nvim",
-      "telescope-file-browser.nvim",
-      "project.nvim",
-    },
-    requires = {
-      "nvim-lua/popup.nvim",
-      "nvim-lua/plenary.nvim",
-      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
-      "nvim-telescope/telescope-project.nvim",
-      "cljoly/telescope-repo.nvim",
-      "nvim-telescope/telescope-file-browser.nvim",
-      {
-        "ahmedkhalf/project.nvim",
-        config = function()
-          require("project_nvim").setup {}
-        end,
+    use {
+      "nvim-telescope/telescope.nvim",
+      opt = true,
+      config = function()
+        require("config.telescope").setup()
+      end,
+      cmd = { "Telescope" },
+      -- module = "telescope",
+      -- keys = { "<leader>f", "<leader>p" },
+      wants = {
+        "plenary.nvim",
+        "popup.nvim",
+        "telescope-fzf-native.nvim",
+        "telescope-project.nvim",
+        "telescope-repo.nvim",
+        "telescope-file-browser.nvim",
+        "project.nvim",
       },
-    },
-  }
-
-  -- -- trouble.nvim
-  -- use {
-  --   "folke/trouble.nvim",
-  --   event = "BufReadPre",
-  --   wants = "nvim-web-devicons",
-  --   cmd = { "TroubleToggle", "Trouble" },
-  --   config = function()
-  --     require("trouble").setup {
-  --       use_diagnostic_signs = true,
-  --     }
-  --   end,
-  -- }
-  --
-  -- -- lspsaga.nvim
-  -- use {
-  --   "tami5/lspsaga.nvim",
-  --   event = "VimEnter",
-  --   cmd = { "Lspsaga" },
-  --   config = function()
-  --     require("lspsaga").setup {}
-  --   end,
-  -- }
+      requires = {
+        "nvim-lua/popup.nvim",
+        "nvim-lua/plenary.nvim",
+        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
+        "nvim-telescope/telescope-project.nvim",
+        "cljoly/telescope-repo.nvim",
+        "nvim-telescope/telescope-file-browser.nvim",
+        {
+          "ahmedkhalf/project.nvim",
+          config = function()
+            require("project_nvim").setup {}
+          end,
+        },
+      },
+    }
 
   -- End of plugins
   -- Bootstrap Neovim
@@ -338,7 +313,7 @@ return packer.startup(function(use)
     print "Restart Neovim required after installation!"
     require("packer").sync()
   end
-
+  
   -- -- My plugins here
   -- use({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }) -- Useful lua functions used by lots of plugins
   -- use({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }) -- Autopairs, integrates with both cmp and treesitter
diff --git a/lua/user/keymaps.lua b/lua/user/keymaps.lua
index e33252d..70cba40 100644
--- a/lua/user/keymaps.lua
+++ b/lua/user/keymaps.lua
@@ -237,8 +237,8 @@ keymap("", "<Up>", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true
 -- keymap("", "<F9>",":w<CR> :!clear && g++ % <CR>", opts)
 -- keymap("", "<C-F9>",":w<CR> :!clear && g++ % -o %< && ./%< <CR>", opts)
 
--- keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
--- keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
+keymap("n", "<leader>f", ":lua vim.lsp.buf.formatting()<CR>", opts)
+keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
 return M
 
 -- 原版
diff --git a/plugin/packer_compiled.lua b/plugin/packer_compiled.lua
index 9781a33..2fdc10e 100644
--- a/plugin/packer_compiled.lua
+++ b/plugin/packer_compiled.lua
@@ -11,7 +11,7 @@ local no_errors, error_msg = pcall(function()
 
   local time
   local profile_info
-  local should_profile = false
+  local should_profile = true
   if should_profile then
     local hrtime = vim.loop.hrtime
     profile_info = {}
@@ -44,8 +44,8 @@ local function save_profiles(threshold)
 end
 
 time([[Luarocks path setup]], true)
-local package_path_str = "/Users/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/Users/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/Users/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/Users/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
-local install_cpath_pattern = "/Users/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
+local package_path_str = "/home/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
+local install_cpath_pattern = "/home/liuxin/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
 if not string.find(package.path, package_path_str, 1, true) then
   package.path = package.path .. ';' .. package_path_str
 end
@@ -75,7 +75,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/Comment.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/Comment.nvim",
     url = "https://github.com/numToStr/Comment.nvim"
   },
   LuaSnip = {
@@ -85,95 +85,95 @@ _G.packer_plugins = {
     },
     loaded = false,
     needs_bufread = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/LuaSnip",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/LuaSnip",
     url = "https://github.com/L3MON4D3/LuaSnip",
     wants = { "friendly-snippets" }
   },
   ["alpha-nvim"] = {
     config = { "\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.alpha\frequire\0" },
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/alpha-nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/alpha-nvim",
     url = "https://github.com/goolord/alpha-nvim"
   },
   ["cmp-buffer"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-buffer/after/plugin/cmp_buffer.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-buffer",
     url = "https://github.com/hrsh7th/cmp-buffer"
   },
   ["cmp-cmdline"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-cmdline/after/plugin/cmp_cmdline.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-cmdline",
     url = "https://github.com/hrsh7th/cmp-cmdline"
   },
   ["cmp-nvim-lsp"] = {
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/cmp-nvim-lsp",
     url = "https://github.com/hrsh7th/cmp-nvim-lsp"
   },
   ["cmp-nvim-lua"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua/after/plugin/cmp_nvim_lua.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-nvim-lua",
     url = "https://github.com/hrsh7th/cmp-nvim-lua"
   },
   ["cmp-path"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-path/after/plugin/cmp_path.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-path",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-path",
     url = "https://github.com/hrsh7th/cmp-path"
   },
   ["cmp-spell"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-spell/after/plugin/cmp-spell.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-spell/after/plugin/cmp-spell.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-spell",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-spell",
     url = "https://github.com/f3fora/cmp-spell"
   },
   ["cmp-treesitter"] = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-treesitter/after/plugin/cmp_treesitter.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-treesitter/after/plugin/cmp_treesitter.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-treesitter",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp-treesitter",
     url = "https://github.com/ray-x/cmp-treesitter"
   },
   cmp_luasnip = {
-    after_files = { "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
+    after_files = { "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp_luasnip/after/plugin/cmp_luasnip.lua" },
     load_after = {
       ["nvim-cmp"] = true
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/cmp_luasnip",
     url = "https://github.com/saadparwaiz1/cmp_luasnip"
   },
   everforest = {
     config = { "\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme everforest\bcmd\bvim\0" },
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/everforest",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/everforest",
     url = "https://github.com/sainnhe/everforest"
   },
   ["friendly-snippets"] = {
@@ -182,7 +182,7 @@ _G.packer_plugins = {
     },
     loaded = false,
     needs_bufread = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/friendly-snippets",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/friendly-snippets",
     url = "https://github.com/rafamadriz/friendly-snippets"
   },
   ["hop.nvim"] = {
@@ -190,7 +190,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/hop.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/hop.nvim",
     url = "https://github.com/phaazon/hop.nvim"
   },
   ["indent-blankline.nvim"] = {
@@ -198,12 +198,12 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/indent-blankline.nvim",
     url = "https://github.com/lukas-reineke/indent-blankline.nvim"
   },
   ["lsp_signature.nvim"] = {
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/lsp_signature.nvim",
     url = "https://github.com/ray-x/lsp_signature.nvim"
   },
   ["lualine.nvim"] = {
@@ -211,7 +211,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/lualine.nvim",
     url = "https://github.com/nvim-lualine/lualine.nvim"
   },
   ["markdown-preview.nvim"] = {
@@ -219,7 +219,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/markdown-preview.nvim",
     url = "https://github.com/iamcco/markdown-preview.nvim"
   },
   neogit = {
@@ -228,7 +228,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = true,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/neogit",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/neogit",
     url = "https://github.com/TimUntersberger/neogit"
   },
   ["nvim-autopairs"] = {
@@ -236,7 +236,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-autopairs",
     url = "https://github.com/windwp/nvim-autopairs",
     wants = { "nvim-treesitter" }
   },
@@ -245,17 +245,17 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-bufferline.lua",
     url = "https://github.com/akinsho/nvim-bufferline.lua",
     wants = { "nvim-web-devicons" }
   },
   ["nvim-cmp"] = {
-    after = { "cmp-treesitter", "cmp_luasnip", "cmp-buffer", "LuaSnip", "cmp-cmdline", "cmp-nvim-lua", "friendly-snippets", "cmp-spell", "cmp-path" },
+    after = { "friendly-snippets", "cmp-buffer", "cmp-cmdline", "cmp-path", "cmp-spell", "cmp-treesitter", "LuaSnip", "cmp_luasnip", "cmp-nvim-lua" },
     config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15config.cmp\frequire\0" },
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-cmp",
     url = "https://github.com/hrsh7th/nvim-cmp",
     wants = { "LuaSnip" }
   },
@@ -264,18 +264,18 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-gps",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-gps",
     url = "https://github.com/SmiteshP/nvim-gps"
   },
   ["nvim-lsp-installer"] = {
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer",
     url = "https://github.com/williamboman/nvim-lsp-installer"
   },
   ["nvim-lspconfig"] = {
     config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15config.lsp\frequire\0" },
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/nvim-lspconfig",
     url = "https://github.com/neovim/nvim-lspconfig",
     wants = { "nvim-lsp-installer", "lsp_signature.nvim", "cmp-nvim-lsp" }
   },
@@ -285,26 +285,26 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-tree.lua",
     url = "https://github.com/kyazdani42/nvim-tree.lua"
   },
   ["nvim-treesitter"] = {
     config = { "\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.treesitter\frequire\0" },
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/nvim-treesitter",
     url = "https://github.com/nvim-treesitter/nvim-treesitter"
   },
   ["nvim-treesitter-endwise"] = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-endwise",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-treesitter-endwise",
     url = "https://github.com/RRethy/nvim-treesitter-endwise",
     wants = { "nvim-treesitter" }
   },
   ["nvim-treesitter-textobjects"] = {
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/nvim-treesitter-textobjects",
     url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects"
   },
   ["nvim-ts-autotag"] = {
@@ -312,7 +312,7 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-ts-autotag",
     url = "https://github.com/windwp/nvim-ts-autotag",
     wants = { "nvim-treesitter" }
   },
@@ -321,70 +321,93 @@ _G.packer_plugins = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/nvim-web-devicons",
     url = "https://github.com/kyazdani42/nvim-web-devicons"
   },
   ["packer.nvim"] = {
     loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/packer.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/start/packer.nvim",
     url = "https://github.com/wbthomason/packer.nvim"
   },
   ["plenary.nvim"] = {
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/plenary.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/plenary.nvim",
     url = "https://github.com/nvim-lua/plenary.nvim"
   },
   ["popup.nvim"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/popup.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/popup.nvim",
     url = "https://github.com/nvim-lua/popup.nvim"
   },
   ["project.nvim"] = {
     config = { "\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17project_nvim\frequire\0" },
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/project.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/project.nvim",
     url = "https://github.com/ahmedkhalf/project.nvim"
   },
   ["telescope-file-browser.nvim"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/telescope-file-browser.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/telescope-file-browser.nvim",
     url = "https://github.com/nvim-telescope/telescope-file-browser.nvim"
   },
   ["telescope-fzf-native.nvim"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/telescope-fzf-native.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/telescope-fzf-native.nvim",
     url = "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
   },
   ["telescope-project.nvim"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/telescope-project.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/telescope-project.nvim",
     url = "https://github.com/nvim-telescope/telescope-project.nvim"
   },
   ["telescope-repo.nvim"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/telescope-repo.nvim",
+    load_after = {
+      ["telescope.nvim"] = true
+    },
+    loaded = false,
+    needs_bufread = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/telescope-repo.nvim",
     url = "https://github.com/cljoly/telescope-repo.nvim"
   },
   ["telescope.nvim"] = {
+    after = { "popup.nvim", "telescope-repo.nvim", "telescope-file-browser.nvim", "project.nvim", "telescope-fzf-native.nvim", "telescope-project.nvim" },
+    commands = { "Telescope" },
     config = { "\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.telescope\frequire\0" },
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/telescope.nvim",
+    loaded = false,
+    needs_bufread = true,
+    only_cond = false,
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/telescope.nvim",
     url = "https://github.com/nvim-telescope/telescope.nvim",
     wants = { "plenary.nvim", "popup.nvim", "telescope-fzf-native.nvim", "telescope-project.nvim", "telescope-repo.nvim", "telescope-file-browser.nvim", "project.nvim" }
   },
-  ["vim-illuminate"] = {
-    loaded = true,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/start/vim-illuminate",
-    url = "https://github.com/RRethy/vim-illuminate"
-  },
   ["which-key.nvim"] = {
     config = { "\27LJ\2\n=\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\20config.whichkey\frequire\0" },
     loaded = false,
     needs_bufread = false,
     only_cond = false,
-    path = "/Users/liuxin/.local/share/nvim/site/pack/packer/opt/which-key.nvim",
+    path = "/home/liuxin/.local/share/nvim/site/pack/packer/opt/which-key.nvim",
     url = "https://github.com/folke/which-key.nvim"
   }
 }
@@ -422,10 +445,10 @@ if not vim.g.packer_custom_loader_enabled then
   vim.g.packer_custom_loader_enabled = true
 end
 
--- Config for: project.nvim
-time([[Config for project.nvim]], true)
-try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0004\2\0\0B\0\2\1K\0\1\0\nsetup\17project_nvim\frequire\0", "config", "project.nvim")
-time([[Config for project.nvim]], false)
+-- Config for: everforest
+time([[Config for everforest]], true)
+try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme everforest\bcmd\bvim\0", "config", "everforest")
+time([[Config for everforest]], false)
 -- Config for: alpha-nvim
 time([[Config for alpha-nvim]], true)
 try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\17config.alpha\frequire\0", "config", "alpha-nvim")
@@ -434,32 +457,25 @@ time([[Config for alpha-nvim]], false)
 time([[Config for nvim-treesitter]], true)
 try_loadstring("\27LJ\2\n?\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\22config.treesitter\frequire\0", "config", "nvim-treesitter")
 time([[Config for nvim-treesitter]], false)
--- Config for: everforest
-time([[Config for everforest]], true)
-try_loadstring("\27LJ\2\n:\0\0\3\0\3\0\0056\0\0\0009\0\1\0'\2\2\0B\0\2\1K\0\1\0\27colorscheme everforest\bcmd\bvim\0", "config", "everforest")
-time([[Config for everforest]], false)
 -- Config for: nvim-lspconfig
 time([[Config for nvim-lspconfig]], true)
 try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15config.lsp\frequire\0", "config", "nvim-lspconfig")
 time([[Config for nvim-lspconfig]], false)
--- Config for: telescope.nvim
-time([[Config for telescope.nvim]], true)
-try_loadstring("\27LJ\2\n>\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\21config.telescope\frequire\0", "config", "telescope.nvim")
-time([[Config for telescope.nvim]], false)
 
 -- Command lazy-loads
 time([[Defining lazy-load commands]], true)
+pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Telescope lua require("packer.load")({'telescope.nvim'}, { cmd = "Telescope", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
 pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file MarkdownPreview lua require("packer.load")({'markdown-preview.nvim'}, { cmd = "MarkdownPreview", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
-pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
 pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeClose lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeClose", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
+pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file Neogit lua require("packer.load")({'neogit'}, { cmd = "Neogit", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
 pcall(vim.cmd, [[command -nargs=* -range -bang -complete=file NvimTreeToggle lua require("packer.load")({'nvim-tree.lua'}, { cmd = "NvimTreeToggle", l1 = <line1>, l2 = <line2>, bang = <q-bang>, args = <q-args>, mods = "<mods>" }, _G.packer_plugins)]])
 time([[Defining lazy-load commands]], false)
 
 -- Keymap lazy-loads
 time([[Defining lazy-load keymaps]], true)
-vim.cmd [[noremap <silent> gcc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gcc", prefix = "" }, _G.packer_plugins)<cr>]]
 vim.cmd [[noremap <silent> gbc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gbc", prefix = "" }, _G.packer_plugins)<cr>]]
 vim.cmd [[noremap <silent> gc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gc", prefix = "" }, _G.packer_plugins)<cr>]]
+vim.cmd [[noremap <silent> gcc <cmd>lua require("packer.load")({'Comment.nvim'}, { keys = "gcc", prefix = "" }, _G.packer_plugins)<cr>]]
 time([[Defining lazy-load keymaps]], false)
 
 vim.cmd [[augroup packer_load_aucmds]]
@@ -470,9 +486,9 @@ vim.cmd [[au FileType markdown ++once lua require("packer.load")({'markdown-prev
 time([[Defining lazy-load filetype autocommands]], false)
   -- Event lazy-loads
 time([[Defining lazy-load event autocommands]], true)
+vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-cmp', 'nvim-ts-autotag', 'nvim-treesitter-endwise'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
+vim.cmd [[au VimEnter * ++once lua require("packer.load")({'hop.nvim', 'indent-blankline.nvim', 'lualine.nvim', 'Comment.nvim', 'which-key.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
 vim.cmd [[au BufReadPre * ++once lua require("packer.load")({'nvim-bufferline.lua'}, { event = "BufReadPre *" }, _G.packer_plugins)]]
-vim.cmd [[au InsertEnter * ++once lua require("packer.load")({'nvim-treesitter-endwise', 'nvim-ts-autotag', 'nvim-cmp'}, { event = "InsertEnter *" }, _G.packer_plugins)]]
-vim.cmd [[au VimEnter * ++once lua require("packer.load")({'lualine.nvim', 'which-key.nvim', 'hop.nvim', 'Comment.nvim', 'indent-blankline.nvim'}, { event = "VimEnter *" }, _G.packer_plugins)]]
 time([[Defining lazy-load event autocommands]], false)
 vim.cmd("augroup END")
 if should_profile then save_profiles() end
