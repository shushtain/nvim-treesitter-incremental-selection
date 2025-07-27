if vim.g.loaded_nvim_treesitter_incremental_selection == true then
  return
end

vim.g.loaded_nvim_treesitter_incremental_selection = true

-- local actions = require("nvim-treesitter-incremental-selection.init")
--
-- vim.api.nvim_create_user_command("TSISInitSelection", function()
--   actions.init_selection()
-- end, {})

-- vim.api.nvim_create_user_command("TSISIncrementNode", function()
--   actions.increment_node()
-- end, { range = true })
--
-- vim.api.nvim_create_user_command("TSISDecrementNode", function()
--   actions.decrement_node()
-- end, {})
--
-- vim.api.nvim_create_user_command("TSISNextSibling", function()
--   actions.next_sibling()
-- end, { range = true })
--
-- vim.api.nvim_create_user_command("TSISPrevSibling", function()
--   actions.prev_sibling()
-- end, {})

-- vim.api.nvim_create_user_command("TSISChild", function(opts)
--   if opts.fargs and #opts.fargs == 1 then
--     actions.child(tonumber(opts.fargs[1]) or 1)
--   else
--     actions.child(1)
--   end
-- end, { nargs = "?", range = true })
