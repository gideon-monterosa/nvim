return {
  { -- LSP
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
      { 'j-hui/fidget.nvim', opts = {} },
      { 'hrsh7th/cmp-nvim-lsp' },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },

        clangd = {
          cmd = { 'clangd', '--background-index', '--clang-tidy', '--completion-style=detailed', '--header-insertion=iwyu' },
          root_dir = function(fname)
            return require('lspconfig.util').root_pattern 'CMakeLists.txt'(fname) or vim.fn.getcwd()
          end,
          capabilities = capabilities,
          settings = {
            clangd = {
              fallbackFlags = { '-std=c++20' },
            },
          },
        },

        ts_ls = {
          root_dir = require('lspconfig').util.root_pattern 'package.json',
          single_file_support = true,
        },

        -- denols = {
        --   root_dir = require('lspconfig').util.root_pattern('deno.json', 'deno.jsonc'),
        --   init_options = {
        --     lint = true,
        --     unstable = true,
        --   },
        -- },
      }

      require('mason').setup()
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        -- LSP
        'lua-language-server',
        'clangd',
        -- 'denols',

        -- Formaters
        'stylua',
        'prettierd',

        -- Linter
        'eslint_d',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style.
        local ignore_filetypes = { 'c', 'cpp' }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
          return
        end

        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end,

      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        cpp = { 'clang_format' },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd' },
      },

      formatters = {
        clang_format = {
          command = 'clang-format',
          args = {
            '--style={BasedOnStyle: Google, AllowShortFunctionsOnASingleLine: Empty}',
          },
        },
      },
    },
  },

  { -- Lint
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    keys = {
      { '<leader>t', '', desc = 'Toggle' },
      { '<leader>tl', '<cmd>ToggleLint<cr>', desc = 'Toggle Inline Linting' },
    },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        markdown = { 'markdownlint' },
        javascript = { 'eslint_d' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }

      local lint_enabled = true
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          if lint_enabled then
            lint.try_lint()
          end
        end,
      })

      local function toggle_lint()
        lint_enabled = not lint_enabled
        if lint_enabled then
          vim.notify('🔍 Inline Linting Enabled', vim.log.levels.INFO)
          lint.try_lint() -- Optionally run lint immediately when enabling
        else
          vim.notify('❌ Inline Linting Disabled', vim.log.levels.WARN)
          vim.diagnostic.reset(nil, vim.api.nvim_get_current_buf())
        end
      end

      vim.api.nvim_create_user_command('ToggleLint', toggle_lint, { desc = 'Toggle Inline Linting' })
    end,
  },

  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
}
