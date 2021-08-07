local i = "i"
local n = "n"
local v = "v"

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

_G.mapper = {
  i = i,
  n = n,
  v = v,
  map = map,
  imap = function(lhs, rhs, opts)
    map(i, lhs, rhs, opts)
  end,
  lmap = function(lhs, rhs, opts)
    map(n, "<Leader>" .. lhs, rhs, opts)
  end
}

