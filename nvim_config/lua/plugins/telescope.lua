return function()
  local builtin = require('telescope.builtin')
  require('telescope').setup {
    defaults = {
      file_ignore_patterns = { "node_modules", ".git" },
    },
    pickers = {
      diagnostics = {
        bufnr = 0,
      },
    },
  }

  -- Keymaps for Telescope
  vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Find recently opened files' })
  vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Find existing buffers' })
  vim.keymap.set('n', '<leader>/', function()
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      -- previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer]' })

  -- Custom picker to show diagnostics from all namespaces in the current buffer, with preview
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')
  local previewers = require('telescope.previewers')

  local function all_buffer_diagnostics_picker()
    local bufnr = vim.api.nvim_get_current_buf()
    local all_diags = {}
    -- Collect diagnostics from all namespaces for the current buffer only
    for ns, nsinfo in pairs(vim.diagnostic.get_namespaces()) do
      local diags = vim.diagnostic.get(bufnr, { namespace = ns })
      for _, d in ipairs(diags) do
        d._namespace = nsinfo.name or tostring(ns)
        table.insert(all_diags, d)
      end
    end
    if #all_diags == 0 then
      vim.notify("No diagnostics found in any namespace for this buffer.", vim.log.levels.INFO)
      return
    end
    pickers.new({}, {
      prompt_title = "All Diagnostics (Current Buffer, All Namespaces)",
      finder = finders.new_table {
        results = all_diags,
        entry_maker = function(entry)
          return {
            value = entry,
            display = string.format("%d:%d: %s [%s]", entry.lnum + 1, entry.col + 1, entry.message, entry._namespace or ""),
            ordinal = entry.message,
            lnum = entry.lnum,
            col = entry.col,
            bufnr = bufnr,
          }
        end,
      },
      sorter = conf.generic_sorter({}),
      previewer = previewers.new_buffer_previewer {
        define_preview = function(self, entry, status)
          local lnum = entry.lnum or 0
          local bufnr = entry.bufnr or bufnr
          local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          if lnum < #lines then
            vim.api.nvim_buf_add_highlight(self.state.bufnr, -1, "Visual", lnum, 0, -1)
            pcall(vim.api.nvim_win_set_cursor, self.state.winid, { lnum + 1, 0 })
          end
          vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", vim.api.nvim_buf_get_option(bufnr, "filetype"))
        end,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection and selection.value then
            vim.api.nvim_win_set_cursor(0, { selection.value.lnum + 1, selection.value.col })
          end
        end)
        return true
      end,
    }):find()
  end

  vim.keymap.set('n', '<leader>sd', all_buffer_diagnostics_picker, { desc = '[s]earch [d]iagnostics (current buffer, all namespaces)' })
end
