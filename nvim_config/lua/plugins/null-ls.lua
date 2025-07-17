return function()
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      -- Use Rubocop for diagnostics, prefer bundle exec if Gemfile exists
      null_ls.builtins.diagnostics.rubocop.with({
        command = "bundle",
        args = {
          "exec", "rubocop",
          "--format", "json",
          "--force-exclusion",
          "--stdin", "$FILENAME"
        },
        condition = function(utils)
          local found = utils.root_has_file("Gemfile")

          if found then
            --print("Running: bundle exec rubocop ...")

            local rubocop_version = vim.fn.system("bundle exec rubocop --version")
            --print("Rubocop version: " .. rubocop_version)

            -- print("PATH: " .. vim.fn.getenv("PATH"))
            -- print("BUNDLE_GEMFILE: " .. (vim.fn.getenv("BUNDLE_GEMFILE") or "nil"))
            -- local ruby_version = vim.fn.system("ruby --version")
            -- print("null-ls root: " .. vim.fn.getcwd())
            -- print("Ruby version: " .. ruby_version)
          end

          return found
        end,
      }),
    },
  })
end
