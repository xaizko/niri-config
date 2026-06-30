return {
    'neovim/nvim-lspconfig',
    dependencies = {
        'williamboman/mason.nvim',
        'williamboman/mason-lspconfig.nvim',
        -- Autocompletion
        'hrsh7th/nvim-cmp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'saadparwaiz1/cmp_luasnip',
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lua',
        'github/copilot.vim',
        -- Snippets
        'L3MON4D3/LuaSnip',
        'rafamadriz/friendly-snippets',
    },
    config = function()
        local autoformat_filetypes = {
            "lua",
            "c",
            "rust",
            "cpp",
            "python",
            "java",
            "typescript",
            "typescriptreact",
        }

        -- Set up handlers for modern 0.12+ borders
        vim.lsp.handlers['textDocument/hover'] = function(err, result, ctx, config)
            config = config or {}
            config.border = 'rounded'
            return vim.lsp.handlers.hover(err, result, ctx, config)
        end

        vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx, config)
            config = config or {}
            config.border = 'rounded'
            return vim.lsp.handlers.signature_help(err, result, ctx, config)
        end

        -- Configure error/warnings interface
        vim.diagnostic.config({
            virtual_text = true,
            underline = true,
            severity_sort = true,
            float = {
                style = 'minimal',
                border = 'rounded',
                header = '',
                prefix = '',
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = '✘',
                    [vim.diagnostic.severity.WARN] = '▲',
                    [vim.diagnostic.severity.HINT] = '⚑',
                    [vim.diagnostic.severity.INFO] = '»',
                },
            },
        })

        local lspconfig_defaults = require('lspconfig').util.default_config
        lspconfig_defaults.capabilities = vim.tbl_deep_extend(
            'force',
            lspconfig_defaults.capabilities,
            require('cmp_nvim_lsp').default_capabilities()
        )

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            end,
        })

        require('mason').setup({})
        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls", "intelephense", "ts_ls", "eslint", 
                "clangd", "rust_analyzer", "pyright", "jdtls"
            },
            handlers = {
                function(server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                lua_ls = function()
                    require('lspconfig').lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = { version = 'LuaJIT' },
                                diagnostics = { globals = { 'vim' } },
                                workspace = { library = { vim.env.VIMRUNTIME } },
                            },
                        },
                    })
                end,
            },
        })

        -- --- Core Autocomplete Config Layer ---
        local cmp = require('cmp')
        require('luasnip.loaders.from_vscode').lazy_load()

        vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

        cmp.setup({
            preselect = 'item',
            completion = { completeopt = 'menu,menuone,noinsert' },
            window = { documentation = cmp.config.window.bordered() },
            sources = {
                { name = 'path' },
                { name = 'nvim_lsp' },
                { name = 'buffer',     keyword_length = 3 },
                { name = 'luasnip',    keyword_length = 2 },
            },
            snippet = {
                expand = function(args) require('luasnip').lsp_expand(args.body) end,
            },
            formatting = {
                fields = { 'abbr', 'menu', 'kind' },
                format = function(entry, item)
                    local n = entry.source.name
                    item.menu = n == 'nvim_lsp' and '[LSP]' or string.format('[%s]', n)
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = false }),
                ['<C-f>'] = cmp.mapping.scroll_docs(5),
                ['<C-u>'] = cmp.mapping.scroll_docs(-5),
                ['<C-e>'] = cmp.mapping(function()
                    if cmp.visible() then cmp.abort() else cmp.complete() end
                end),
                ['<Tab>'] = cmp.mapping(function(fallback)
                    local col = vim.fn.col('.') - 1
                    if cmp.visible() then
                        cmp.select_next_item({ behavior = 'select' })
                    elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                        fallback()
                    else
                        cmp.complete()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
            }),
        })

        -- Map Tab to accept Copilot recommendations when a suggestion is visible.
        -- If an nvim-cmp dropdown menu is active instead, fallback to native menu selection.
	vim.g.copilot_no_tab_map = true

        -- 2. Map Shift+Tab (<S-Tab>) to accept the Copilot ghost text suggestion
        vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("<CR>")', {
            silent = true,
            expr = true,
            replace_keycodes = false,
            desc = "Accept Copilot Suggestion"
        })
    end
}
