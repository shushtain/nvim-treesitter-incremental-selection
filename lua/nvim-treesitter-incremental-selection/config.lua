---@diagnostic disable: inject-field

---@class TSIS.Config
---@field ignore_injections? boolean If `true`, ignore language injections while selecting nodes. This will treat injected code blocks as single nodes without children. Default is `false`
---@field loop_siblings? boolean If `true`, last child will have first child as next sibling, and vice versa. Default is `false`
---@field fallback? boolean If `true` and Treesitter is not active, will select inside Word instead (`viW`). Default is `false`
---@field quiet? boolean If `true` and Treesitter is not active, will not show warning. Default is `false`

---@type TSIS.Config
local M = {}

M.defaults = {
  ignore_injections = false,
  loop_siblings = false,
  fallback = false,
  quiet = false,
}

M.config = {}

M.__setup = function(opts)
  M.config = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
