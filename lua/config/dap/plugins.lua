local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- vim.cmd([[
--   augroup packer_user_config
--     autocmd!
--     autocmd BufWritePost plugins.lua source <afile> | PackerSync
--   augroup end
-- ]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  use { "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" } -- Have packer manage itself
  -- Load only when require
  use { "nvim-lua/plenary.nvim", module = "plenary" }

  -- Colorschemes
  -- use {
  --   "sainnhe/everforest",
  --   config = function()
  --     vim.cmd [[colorscheme everforest]]
  --   end,
  -- }
  use {
    "lunarvim/onedarker.nvim",
    config = function()
      vim.cmd [[colorscheme onedarker]]
    end,
  }
  use "lunarvim/darkplus.nvim"
  use "shaunsingh/nord.nvim" -- Colorscheme
  use "sainnhe/gruvbox-material" -- Colorscheme
  use "folke/tokyonight.nvim" -- Colorscheme
  use "NTBBloodbath/doom-one.nvim"
  use "Mofiqul/vscode.nvim" -- Colorscheme
  -- Startup Screen
  use {
    "goolord/alpha-nvim",
    config = function()
      require("config.alpha").setup()
    end,
  }
  -- Git
  use {
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require("config.neogit").setup()
    end,
  }
  use {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns").setup()
    end,
  }
  use {
    "tpope/vim-fugitive",
    cmd = { "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    requires = { "tpope/vim-rhubarb" },
    -- wants = { "vim-rhubarb" },
  }
  -- Whichkey
  use {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("config.whichkey").setup()
    end,
  }
  -- IndentLine
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "VimEnter",
    config = function()
      require("config.indentblankline").setup()
    end,
  }

  -- Better icons
  use {
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup { default = true }
    end,
  }

  -- Better Comment
  use {
    "numToStr/Comment.nvim",
    opt = true,
    event = "VimEnter",
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("Comment").setup {}
    end,
  }

  -- Better surround
  use { "tpope/vim-surround", event = "InsertEnter" }

  -- Motions
  use { "andymass/vim-matchup", event = "CursorMoved" }
  use { "wellle/targets.vim", event = "CursorMoved" }
  -- use { "unblevable/quick-scope", event = "CursorMoved", disable = false }
  use { "chaoren/vim-wordmotion", opt = true, fn = { "<Plug>WordMotion_w" } }
  -- Easy hopping
  use {
    "phaazon/hop.nvim",
    event = "VimEnter",
    -- cmd = { "HopWord", "HopChar1" },
    config = function()
      require("config.hop").setup()
    end,
  }
  use {
    "ggandor/lightspeed.nvim",
    keys = { "s", "S", "f", "F", "t", "T" },
    config = function()
      require("lightspeed").setup {}
    end,
  }

  -- Markdown
  use {
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  }

  -- Status line
  use {
    "nvim-lualine/lualine.nvim",
    event = "VimEnter",
    config = function()
      require("config.lualine").setup()
    end,
    requires = { "nvim-web-devicons" },
  }
  -- nvim-gps is deprecated
  use {
    "SmiteshP/nvim-gps",
    requires = "nvim-treesitter/nvim-treesitter",
    module = "nvim-gps",
    config = function()
      require("nvim-gps").setup()
    end,
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    -- opt = true,
    -- event = "BufRead",
    run = ":TSUpdate",
    config = function()
      require("config.treesitter").setup()
    end,
    requires = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
    },
  }

  -- nvim-tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle", "NvimTreeClose" },
    config = function()
      require("config.nvimtree").setup()
    end,
  }

  -- Buffer line
  use {
    "akinsho/nvim-bufferline.lua",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    config = function()
      require("config.bufferline").setup()
    end,
  }

  -- nvim-cmp
  use {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("config.cmp").setup()
    end,
    wants = { "LuaSnip" },
    requires = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lua",
      "ray-x/cmp-treesitter",
      "hrsh7th/cmp-cmdline",
      "saadparwaiz1/cmp_luasnip",
      -- "hrsh7th/cmp-nvim-lsp",
      -- "hrsh7th/cmp-nvim-lsp-signature-help",
      -- "hrsh7th/cmp-calc",
      "f3fora/cmp-spell",
      -- "hrsh7th/cmp-emoji",
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require("config.luasnip").setup()
        end,
      },
      "rafamadriz/friendly-snippets",
      disable = false,
    },
  }
  -- Auto pairs
  use {
    "windwp/nvim-autopairs",
    wants = "nvim-treesitter",
    module = { "nvim-autopairs.completion.cmp", "nvim-autopairs" },
    config = function()
      require("config.autopairs").setup()
    end,
  }

  -- Auto tag
  use {
    "windwp/nvim-ts-autotag",
    wants = "nvim-treesitter",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup { enable = true }
    end,
  }

  -- End wise
  use {
    "RRethy/nvim-treesitter-endwise",
    wants = "nvim-treesitter",
    event = "InsertEnter",
  }

  -- LSP
  use {
    "neovim/nvim-lspconfig",
    -- opt = true,
    -- event = "BufReadPre",
    wants = { "nvim-lsp-installer", "cmp-nvim-lsp", "lua-dev.nvim", "vim-illuminate", "null-ls.nvim" },
    config = function()
      require("config.lsp").setup()
    end,
    requires = {
      "williamboman/nvim-lsp-installer",
      "hrsh7th/cmp-nvim-lsp",
      "ray-x/lsp_signature.nvim",
      -- "folke/neodev.nvim",
      -- "folke/lua-dev.nvim",
      "RRethy/vim-illuminate",
      "jose-elias-alvarez/null-ls.nvim",
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup {}
        end,
      },
    },
  }

  use {
    "nvim-telescope/telescope.nvim",
    -- opt = true,
    config = function()
      require("config.telescope").setup()
    end,
    -- cmd = { "Telescope" },
    -- -- module = "telescope",
    -- keys = { "<leader>f", "<leader>p" },
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-fzf-native.nvim",
      "telescope-project.nvim",
      "telescope-repo.nvim",
      "telescope-file-browser.nvim",
      "project.nvim",
    },
    requires = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
      "nvim-telescope/telescope-project.nvim",
      "cljoly/telescope-repo.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      {
        "ahmedkhalf/project.nvim",
        config = function()
          require("project_nvim").setup {}
        end,
      },
    },
  }

  -- trouble.nvim
  use {
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup {
        use_diagnostic_signs = true,
      }
    end,
  }

  -- lspsaga.nvim
  use {
    "glepnir/lspsaga.nvim",
    branch = "main",
    config = function()
      require("lspsaga").init_lsp_saga {
        -- your configuration
      }
    end,
  }

  -- Debugging
  use {
    "mfussenegger/nvim-dap",
    opt = true,
    event = "BufReadPre",
    module = { "dap" },
    wants = { "nvim-dap-virtual-text", "DAPInstall.nvim", "nvim-dap-ui", "nvim-dap-python", "which-key.nvim" },
    requires = {
      "Pocco81/DAPInstall.nvim",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-telescope/telescope-dap.nvim",
      { "leoluz/nvim-dap-go", module = "dap-go" },
      { "jbyuki/one-small-step-for-vimkind", module = "osv" },
    },
    config = function()
      require("config.dap").setup()
    end,
  }

  -- End of plugins
  -- Bootstrap Neovim
  -- if packer_bootstrap then
  --   print "Restart Neovim required after installation!"
  --   require("packer").sync()
  -- end

  -- -- My plugins here
  -- use({ "nvim-lua/plenary.nvim", commit = "968a4b9afec0c633bc369662e78f8c5db0eba249" }) -- Useful lua functions used by lots of plugins
  -- use({ "windwp/nvim-autopairs", commit = "fa6876f832ea1b71801c4e481d8feca9a36215ec" }) -- Autopairs, integrates with both cmp and treesitter
  -- use({ "numToStr/Comment.nvim", commit = "2c26a00f32b190390b664e56e32fd5347613b9e2" })
  -- use({ "JoosepAlviste/nvim-ts-context-commentstring", commit = "88343753dbe81c227a1c1fd2c8d764afb8d36269" })
  -- use({ "kyazdani42/nvim-web-devicons", commit = "8d2c5337f0a2d0a17de8e751876eeb192b32310e" })
  -- use({ "kyazdani42/nvim-tree.lua", commit = "bdb6d4a25410da35bbf7ce0dbdaa8d60432bc243" })
  -- use({ "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" })
  -- use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" })
  -- use({ "nvim-lualine/lualine.nvim", commit = "3362b28f917acc37538b1047f187ff1b5645ecdd" })
  -- use({ "akinsho/toggleterm.nvim", commit = "aaeed9e02167c5e8f00f25156895a6fd95403af8" })
  -- use({ "ahmedkhalf/project.nvim", commit = "541115e762764bc44d7d3bf501b6e367842d3d4f" })
  -- use({ "lewis6991/impatient.nvim", commit = "969f2c5c90457612c09cf2a13fee1adaa986d350" })
  -- use({ "lukas-reineke/indent-blankline.nvim", commit = "6177a59552e35dfb69e1493fd68194e673dc3ee2" })
  -- use({ "goolord/alpha-nvim", commit = "ef27a59e5b4d7b1c2fe1950da3fe5b1c5f3b4c94" })

  -- -- Colorschemes
  -- use({ "folke/tokyonight.nvim", commit = "8223c970677e4d88c9b6b6d81bda23daf11062bb" })
  -- use({ "lunarvim/darkplus.nvim", commit = "2584cdeefc078351a79073322eb7f14d7fbb1835" })

  -- -- cmp plugins
  -- use({ "hrsh7th/nvim-cmp", commit = "df6734aa018d6feb4d76ba6bda94b1aeac2b378a" }) -- The completion plugin
  -- use({ "hrsh7th/cmp-buffer", commit = "62fc67a2b0205136bc3e312664624ba2ab4a9323" }) -- buffer completions
  -- use({ "hrsh7th/cmp-path", commit = "466b6b8270f7ba89abd59f402c73f63c7331ff6e" }) -- path completions
  -- use({ "saadparwaiz1/cmp_luasnip", commit = "a9de941bcbda508d0a45d28ae366bb3f08db2e36" }) -- snippet completions
  -- use({ "hrsh7th/cmp-nvim-lsp", commit = "affe808a5c56b71630f17aa7c38e15c59fd648a8" })
  -- use({ "hrsh7th/cmp-nvim-lua", commit = "d276254e7198ab7d00f117e88e223b4bd8c02d21" })

  -- -- snippets
  -- use({ "L3MON4D3/LuaSnip", commit = "79b2019c68a2ff5ae4d732d50746c901dd45603a" }) --snippet engine
  -- use({ "rafamadriz/friendly-snippets", commit = "d27a83a363e61009278b6598703a763ce9c8e617" }) -- a bunch of snippets to use

  -- -- LSP
  -- use({ "neovim/nvim-lspconfig", commit = "148c99bd09b44cf3605151a06869f6b4d4c24455" }) -- enable LSP
  -- use({ "williamboman/nvim-lsp-installer", commit = "e9f13d7acaa60aff91c58b923002228668c8c9e6" }) -- simple to use language server installer
  -- -- use { "jose-elias-alvarez/null-ls.nvim", commit = "ff40739e5be6581899b43385997e39eecdbf9465" } -- for formatters and linters
  -- use({ "jose-elias-alvarez/null-ls.nvim" }) -- for formatters and linters
  -- use({ "RRethy/vim-illuminate", commit = "c82e6d04f27a41d7fdcad9be0bce5bb59fcb78e5" })

  -- -- Telescope
  -- use({ "nvim-telescope/telescope.nvim", commit = "d96eaa914aab6cfc4adccb34af421bdd496468b0" })

  -- -- Treesitter
  -- use({
  --   "nvim-treesitter/nvim-treesitter",
  --   commit = "518e27589c0463af15463c9d675c65e464efc2fe",
  -- })

  -- -- Git
  -- use({ "lewis6991/gitsigns.nvim", commit = "c18e016864c92ecf9775abea1baaa161c28082c3" })

  -- -- DAP
  -- use({ "mfussenegger/nvim-dap", commit = "014ebd53612cfd42ac8c131e6cec7c194572f21d" })
  -- use({ "rcarriga/nvim-dap-ui", commit = "d76d6594374fb54abf2d94d6a320f3fd6e9bb2f7" })
  -- use({ "ravenxrz/DAPInstall.nvim", commit = "8798b4c36d33723e7bba6ed6e2c202f84bb300de" })

  -- -- My plugins
  -- use({ "williamboman/mason.nvim", commit = "5a25626c15036c5632c86fdb7966a47f2d8d521d" })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
