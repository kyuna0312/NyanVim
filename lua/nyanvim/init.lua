local M = {}

M.version = "1.0.0"

--- Check if an executable exists on PATH
---@param name string
---@return boolean
function M.has_executable(name)
  return vim.fn.executable(name) == 1
end

--- Check if nvim version meets minimum
---@param major integer
---@param minor integer
---@return boolean
function M.nvim_version_ok(major, minor)
  local v = vim.version()
  return v.major > major or (v.major == major and v.minor >= minor)
end

return M
