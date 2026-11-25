local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


return require('lazy').setup({
    {
        'nvim-telescope/telescope.nvim', version = '*',
        dependencies = { {'nvim-lua/plenary.nvim'} }
    },
    {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            require("rose-pine").setup({})
            vim.cmd('colorscheme rose-pine')
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            -- Optional: only needed if you want to customize the parser install directory
            require("nvim-treesitter").setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- Install your required parsers
            require("nvim-treesitter").install({
                "lua",
                "vim",
                "vimdoc",
                "markdown",
                "markdown_inline",
                -- add your other languages here
            })

            -- Enable Neovim's built-in Tree-sitter highlighting for all filetypes with a parser
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
    {'mbbill/undotree'},
    {'tpope/vim-fugitive'},
    {'neovim/nvim-lspconfig'},             -- Required
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    -- Autocompletion
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        lazy = true,

        dependencies = {
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip"
        },
        build = "make install_jsregexp"
    },
    {'hrsh7th/nvim-cmp'},         -- Required
    {'hrsh7th/cmp-nvim-lsp'},     -- Required
    {'saadparwaiz1/cmp_luasnip'}, -- Optional

    {
        'nvim-lualine/lualine.nvim',
        dependencies = {'nvim-tree/nvim-web-devicons', opt = true}
    },
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons', -- Optional
        },
        config = function ()
            require("nvim-tree").setup {}
        end
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        opts = {
            interactions = {
                -- Option A: Native Chat buffer via Codex ACP adapter (reads ~/.codex/config.toml)
                chat = {
                    adapter = {
                        name = "codex",
                        model = "openai.gpt-5.6-sol",
                    },
                },
                -- Option B: Interactive Codex CLI inside a Neovim terminal with buffer context
                cli = {
                    agent = "codex",
                    agents = {
                        codex = {
                            cmd = "codex",
                            args = {},
                            description = "OpenAI Codex CLI (Bedrock)",
                        },
                    },
                },
            },
        },
        keys = {
            -- This is only when codex-acp is needed
            -- { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat (Codex)" },
            { "<leader>at", "<cmd>CodeCompanionCLI<cr>", mode = { "n", "v" }, desc = "CodeCompanion CLI (Codex)" },
            { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add selection to Chat" },
        },
    }
})
