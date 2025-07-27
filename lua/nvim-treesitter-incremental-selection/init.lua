local cfg = require("nvim-treesitter-incremental-selection.config")
local utils = require("nvim-treesitter-incremental-selection.utils")

local M = {}

---@type table<integer, table<TSNode|nil>>
local selections = {}

M.init_selection = function()
  if not utils.parse() then
    return nil
  end

  local buf = vim.api.nvim_get_current_buf()
  local node = vim.treesitter.get_node({
    ignore_injections = cfg.config.ignore_injections,
    include_anonymous = true,
  })

  if not utils.update_selection(node) then
    return nil
  end

  selections[buf] = { [1] = node }
end

M.increment_node = function()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = selections[buf]

  if not nodes or #nodes == 0 then
    return nil
  end

  local node = nodes[#nodes]
  local parent = node:parent()

  if parent == nil then
    return nil
  end

  if not utils.update_selection(parent) then
    return nil
  end

  table.insert(selections[buf], parent)
end

M.decrement_node = function()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = selections[buf]

  if not nodes or #nodes < 2 then
    return nil
  end

  local node = nodes[#nodes - 1]
  if not utils.update_selection(node) then
    return nil
  end

  table.remove(selections[buf])
end

M.next_sibling = function()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = selections[buf]

  if not nodes or #nodes == 0 then
    return nil
  end

  local node = nodes[#nodes]
  local parent = node:parent()

  local ok_children, children = pcall(parent.named_child_count, parent)
  if not ok_children or children < 2 then
    return nil
  end

  local sibling = node:next_named_sibling()

  if sibling == nil and cfg.config.loop_siblings then
    sibling = parent:named_child(0)
  end

  if sibling == nil or not utils.update_selection(sibling) then
    return nil
  end

  selections[buf] = { [1] = sibling }
end

M.prev_sibling = function()
  local buf = vim.api.nvim_get_current_buf()
  local nodes = selections[buf]

  if not nodes or #nodes == 0 then
    return nil
  end

  local node = nodes[#nodes]
  local parent = node:parent()

  local ok_children, children = pcall(parent.named_child_count, parent)
  if not ok_children or children < 2 then
    return nil
  end

  local sibling = node:prev_named_sibling()

  if sibling == nil and cfg.config.loop_siblings then
    sibling = parent:named_child(children)
  end

  if sibling == nil or not utils.update_selection(sibling) then
    return nil
  end

  selections[buf] = { [1] = sibling }
end

M.child = function(nth)
  local buf = vim.api.nvim_get_current_buf()
  local nodes = selections[buf]

  if not nodes or #nodes == 0 then
    return nil
  end

  local parent = nodes[#nodes]

  local ok_children, children = pcall(parent.named_child_count, parent)
  if not ok_children or children == 0 then
    return nil
  end

  local idx = nth
  if type(nth) ~= "number" or idx == 0 then
    idx = 1
  elseif idx < 0 then
    idx = children + 1 + idx
  end
  idx = math.min(children, math.max(idx, 1))

  local child = parent:named_child(idx - 1)

  if child == nil or not utils.update_selection(child) then
    return nil
  end

  selections[buf] = { [1] = child }
end

---Setup function for TS Incremental Selection
---@param config TSIS.Config|nil
M.setup = function(config)
  cfg.__setup(config)
end

return M
