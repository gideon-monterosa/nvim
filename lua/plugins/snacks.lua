---@diagnostic disable: undefined-global
return {
  {
    'folke/snacks.nvim',
    dependencies = {
      { 'folke/todo-comments.nvim' },
    },
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      picker = {
        enabled = true,
        previewers = {
          diff = {
            builtin = false,
            cmd = { 'delta' },
          },

          git = {
            builtin = false,
            cmd = { 'delta' },
          },
        },
      },

      -- TODO: not working (maybe I got it wrong else gitsign)
      statuscolumn = { enabled = true },

      lazygit = { enabled = true },

      dashboard = {
        enabled = true,
      },

      scroll = {
        enabled = true,
        animate = {
          duration = { step = 25, total = 100 },
        },
      },

      styles = {
        float = {
          backdrop = 90,
        },
      },
    },
    keys = {
      -- TODO: remove as soon as .stylua.toml is recognized
      -- stylua: ignore start

      -- Find
      { '<leader><leader>', function() Snacks.picker.buffers() end, desc = 'Find Buffers', },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find Global" },
      { '<leader>fF', function() Snacks.picker.files() end, desc = 'Find All Files', },
      { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Find Recent', },
      { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "Find Todo" },
      { '<leader>ff', function()
          local in_git_repo = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null') == 'true\n'
          if in_git_repo then
            Snacks.picker.git_files()
          else
            Snacks.picker.files()
          end
        end,
        desc = 'Find Files (Git/All)',
      },

      -- Git
      { '<leader>gg', function() Snacks.lazygit.open(opts) end, desc = 'Open LazyGit', },
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

      -- LSP
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto Type Definition" },
      -- stylua: ignore end
    },
  },
}
