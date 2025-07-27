# Incremental Selection with Treesitter for Neovim

People who switch to the `main` branch of [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) might notice that it aims to remove modules, such as `incremental_selection`. This plugin aims to bring it back and more.

## Setup

### Lazy

Provided values are the defaults:

```lua
return {
  "shushtain/nvim-treesitter-incremental-selection",
  config = function()
    local tsis = require("nvim-treesitter-incremental-selection")

    ---@type TSIS.Config
    tsis.setup({
      ignore_injections = false,
      loop_siblings = false,
    })
  end
}
```

### ignore_injections

If `true`, ignore language injections while selecting nodes. This will treat injected code blocks as single nodes without children.

For example:

If this setting is `false`, incrementing selection within a Markdown code block selects a node from injected language. If this is `true`, the same action selects the whole code block, as a Markdown node, disregarding injected nodes.

### loop_siblings

If `true`, last child will have first child as next sibling, and vice versa.

For example:

You select one of key-value pairs within a table. If this setting is `true`, calling `next_sibling` on the last pair would jump-select the first pair. Calling `prev_sibling` on the first pair would jump-select the last pair. If this setting is `false`, calling those functions would do nothing in those cases.

## Usage

This plugin doesn't set any keymaps by default.

### Standard capabilities

You may be familiar with `init_selection`, `node_incremental`, `node_decremental` from the `master` branch of [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter). These have slightly different names but act in similar fashion.

> ⚠️ `scope_incremental` is not implemented (for now?).

Use this commands:

```lua
local tsis = require("nvim-treesitter-incremental-selection")
vim.keymap.set("n", "<shortcut>", tsis.init_selection)
vim.keymap.set("v", "<shortcut>", tsis.increment_node)
vim.keymap.set("v", "<shortcut>", tsis.decrement_node)
```

### Extended capabilities

There were no `next_sibling`, `prev_sibling` or `child` in the original implementation. One of good reasons for that is that they break the original flow (after switching to siblings or children, `decrement_node` chain must be emptied). But still, you may want to use them occasionally.

Use this commands:

```lua
local tsis = require("nvim-treesitter-incremental-selection")
vim.keymap.set("v", "<shortcut>", tsis.next_sibling)
vim.keymap.set("v", "<shortcut>", tsis.prev_sibling)
vim.keymap.set("v", "<shortcut>", tsis.child) -- first child
vim.keymap.set("v", "<shortcut>", function()
  tsis.child()   -- first child
  tsis.child(0)  -- first child
  tsis.child(1)  -- first child

  tsis.child(6)  -- sixth child
  tsis.child(-1) -- last child
  tsis.child(-3) -- third child from the right
end)
```

> ⚠️ Children use 1-based indexing. To count backwards, use negative numbers. `0` falls back to `1`. If positive or negative index goes past the child count, the last child from that direction is chosen.

## Considerations

- This plugin is not tested beyond personal setup.
- The underlying code is not identical to the original implementation, and often simplified.
- I've tried to wrap everything sensitive with `pcall` but it may still break occasionally.
