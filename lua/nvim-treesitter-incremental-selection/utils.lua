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
  local ok_end, _ = pcall(node.end_, node)

  if not ok_start or not ok_end then
    return false
  end

  local srow, scol = node:start()
  local erow, ecol = node:end_()

  local mode = vim.api.nvim_get_mode()
  if mode.mode ~= "v" then
    vim.cmd("normal! v")
  end

  buf = vim.api.nvim_get_current_buf()
  lines = vim.api.nvim_buf_line_count(buf)

  srow = srow + 1
  erow = math.min(erow + 1, lines)
  ecol = math.max(ecol - 1, 0)

  -- document-wide scope is often (0, 0, lines, 0),
  -- even if the last line has characters.
  -- to account for that, we check if it's the highest node,
  -- and select the hanging characters if it is.
  if srow == 1 and scol == 0 and erow == lines and ecol == 0 then
    local parent = node:parent()
    if parent == nil then
      last = vim.api.nvim_buf_get_lines(buf, -2, -1, false)[1]
      ecol = last and (#last - 1) or ecol
    end
  end

  local ok_begin, _ = pcall(vim.api.nvim_win_set_cursor, 0, { srow, scol })
  if not ok_begin then
    return false
  end

  vim.cmd("normal! o")
  pcall(vim.api.nvim_win_set_cursor, 0, { erow, ecol })

  return true
end

return M
