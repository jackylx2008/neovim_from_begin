local M = {}

function M.setup(_)
  local dap = require "dap"
  dap.configurations.cpp = {}
end

return M
