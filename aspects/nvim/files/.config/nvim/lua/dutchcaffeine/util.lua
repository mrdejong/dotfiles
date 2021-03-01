local util = {}

util.buf_get_var = function(handle, name)
  local result
  pcall(function()
    result = vim.api.nvim_buf_get_var(handle, name)
  end)
  return result
end

util.get_var = function(name)
  local result
  pcall(function()
    result = vim.api.nvim_get_var(name)
  end)
  return result
end

util.tabpage_get_var = function(handle, name)
  local result
  pcall(function ()
    result = vim.api.nvim_tabpage_get_var(handle, name)
  end)
  return result
end

util.win_get_var = function(handle, name)
  local result
  pcall(function()
    result = vim.api.nvim_win_get_var(handle, name)
  end)
  return result
end

return util
