-- Global functions
P = function(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

-- plugins
require('plugins')
require('plugin.telescope')
require('plugin.treesitter')
require('plugin.whichkey')
require('plugin.neoscroll')
require('plugin.orgmode')
require('colorizer').setup()
-- require('plugin.mark-radar')



