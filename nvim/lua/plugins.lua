-- C:\Users\hasan\AppData\Local\nvim-data\site\pack\packer

return require("packer").startup({
  function(use)
    use({ 'wbthomason/packer.nvim' })
    --> Visual -------------------------------------
    use({ 'navarasu/onedark.nvim' })
    use({ 'glepnir/dashboard-nvim', config = function() require('config.dashboard') end })
    use({ 'kyazdani42/nvim-web-devicons' })
    use({ 'Yggdroot/indentLine', opt = true, event = 'BufRead' })
    use({ 'folke/zen-mode.nvim', opt = true, cmd = 'ZenMode'})
    use({ 'hasansujon786/kissline.nvim' })
    use({ 'hasansujon786/notifier.nvim' })
    use({ 'hasansujon786/telescope-yanklist.nvim' })
    -- use({ 'folke/tokyonight.nvim' })

    --> Productiviry -------------------------------
    use({ 'vimwiki/vimwiki', opt = true, cmd = {'VimwikiIndex','VimwikiTabIndex','VimwikiUISelect'} })
    use({ 'kristijanhusak/orgmode.nvim', opt = true, event = 'BufRead', config = function() require('config.orgmode') end })
    use({ 'mkropat/vim-tt', opt = true, event = 'VimEnter', config = function () vim.g.tt_loaded = 1 end })

    --> Navigation ---------------------------------
    use({ 'ThePrimeagen/harpoon', opt = true, event = 'VimEnter' })
    use({ 'nvim-telescope/telescope.nvim', config = function() require('config.telescope') end })
    use({ 'nvim-telescope/telescope-fzy-native.nvim' })
    use({ 'nvim-telescope/telescope-project.nvim', opt = true, cmd = {'SwitchProjects'}, config = function ()
      vim.cmd[[command! SwitchProjects lua require("telescope").extensions.project.project{}]]
    end })

    use({ 'lambdalisue/fern-renderer-nerdfont.vim' })
    use({ 'hasansujon786/glyph-palette.vim' })
    use({ 'lambdalisue/nerdfont.vim' })
    use({ 'lambdalisue/fern.vim' })

    --> Utils --------------------------------------
    use({ 'nvim-lua/popup.nvim' })
    use({ 'nvim-lua/plenary.nvim' })
    use({ 'tpope/vim-eunuch', opt = true, cmd = {'Delete','Move','Rename','Mkdir','Chmod'} })
    use({ 'voldikss/vim-floaterm', opt = true, cmd = {'FloatermNew','FloatermToggle'} })
    use({ 'mg979/vim-visual-multi', opt = true, event = 'BufRead' })
    use({ 'michaeljsmith/vim-indent-object', opt = true, event = 'BufRead' })
    use({ 'tweekmonster/startuptime.vim', opt = true, cmd = 'StartupTime' })
    -- " use 'tpope/vim-scriptease'
    use({ 'hasansujon786/vim-rel-jump', opt = true, event = 'BufRead' })
    use({ 'dhruvasagar/vim-open-url', opt = true, event = 'BufRead' })
    use({ 'unblevable/quick-scope', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-commentary', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-surround', opt = true, event = 'BufRead' })
    use({ 'justinmk/vim-sneak', opt = true, event = 'BufRead' })
    use({ 'Konfekt/vim-CtrlXA', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-repeat', opt = true, event = 'BufRead' })
    use({ 'folke/which-key.nvim', config = function() require('config.whichkey') end })
    use({ 'folke/neoscroll.nvim', opt = true, event = 'VimEnter', config = function() require('config.neoscroll') end })

    --> Git ----------------------------------------
    use({ 'airblade/vim-gitgutter', opt = true, event = 'BufRead' })
    use({ 'tpope/vim-fugitive', opt = true, cmd = {'Git','GBrowse','GV'}})
    use({ 'tpope/vim-rhubarb', opt = true, cmd = {'Git','GBrowse','GV'}})
    use({ 'junegunn/gv.vim', opt = true, cmd = 'GV' })
    use({ 'TimUntersberger/neogit', opt = true, cmd = 'Neogit' })
    -- use({'ruifm/gitlinker.nvim'})
    -- ues({'tanvirtin/vgit.nvim'})

    --> Lsp & completions --------------------------
    use({ 'nvim-treesitter/nvim-treesitter', config = function() require('config.treesitter') end })
    use({ 'nvim-treesitter/playground', opt = true, cmd = {'TSPlaygroundToggle','TSHighlightCapturesUnderCursor'} })
    use({ 'JoosepAlviste/nvim-ts-context-commentstring', opt = true, event = 'BufRead'  })

    use({ 'honza/vim-snippets', opt = true, event = 'InsertEnter'})
    use({
      'neoclide/coc.nvim',
      config = function ()
        vim.cmd "source ~/dotfiles/nvim/config/coc.vim"
      end,
      disable = vim.g.disable_coc,
      opt = true,
      event = 'BufRead'
    })

    use({ 'gu-fan/colorv.vim', opt = true, cmd = 'ColorV' })
    use({ 'mattn/emmet-vim', opt = true, event = 'BufRead' })
    use({ 'norcalli/nvim-colorizer.lua', opt = true, event = 'BufRead',
      config = function ()
        require('colorizer').setup()
        vim.cmd('ColorizerReloadAllBuffers')
      end
    })

    -- TODO: refactor all of this (for now it works, but yes I know it could be wrapped in a simpler function)
    use {
      "neovim/nvim-lspconfig",
      disable = vim.g.disable_lsp
    }
    -- use { "kabouzeid/nvim-lspinstall", event = "VimEnter", config = function() require("lspinstall").setup() end, }
    use {
      "hrsh7th/nvim-compe",
      disable = vim.g.disable_lsp,
      -- event = "InsertEnter",
      config = function()
        require('config.compe')
      end,
    }
    use {
      "windwp/nvim-autopairs",
      disable = vim.g.disable_lsp,
      -- event = "InsertEnter",
      -- after = { "telescope.nvim" },
      config = function()
        require('config.autopairs')
      end,
    }
    use {
      "airblade/vim-rooter",
      disable = vim.g.disable_lsp,
      config = function()
        vim.g.rooter_silent_chdir = 1
      end,
    }
    use {
      "hrsh7th/vim-vsnip",
      disable = vim.g.disable_lsp,
      event = "InsertEnter"
    }
    use {
      "rafamadriz/friendly-snippets",
      disable = vim.g.disable_lsp,
      event = "InsertEnter"
    }
  end,
})
