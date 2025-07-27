local M = {}

M.parse = function()
  local ok_parser, parser = pcall(vim.treesitter.get_parser)
  if not ok_parser or parser == nil then
    return false
  end

  -- parse with range=true for full source
  local ok_parse, _ = pcall(parser.parse, parser, true)
  if not ok_parse then
    return false
  end

  return true
end

M.update_selection = function(node)
  local ok_start, _ = pcall(node.start, node)
  local ok_end, _ = pcall(node.start, node)

  if not ok_start or not ok_end then
    return false
  end

  local srow, scol = node:start()
  local erow, ecol = node:end_()

  local mode = vim.api.nvim_get_mode()
  if mode.mode ~= "v" then
    vim.cmd("normal! v")
  end

  ecol = math.max(ecol, 1)

  local ok_begin, _ = pcall(vim.api.nvim_win_set_cursor, 0, { srow + 1, scol })
  if not ok_begin then
    return false
  end

  vim.cmd("normal! o")
  pcall(vim.api.nvim_win_set_cursor, 0, { erow + 1, ecol - 1 })

  return true
end

return M
