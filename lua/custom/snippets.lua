-- LuaSnip filetype extensions for friendly-snippets
-- Loaded as part of the LuaSnip/friendly-snippets config in init.lua

local M = {}

function M.setup()
  local luasnip = require 'luasnip'
  luasnip.filetype_extend('typescript', { 'tsdoc' })
  luasnip.filetype_extend('javascript', { 'jsdoc' })
  luasnip.filetype_extend('lua', { 'luadoc' })
  luasnip.filetype_extend('python', { 'pydoc' })
  luasnip.filetype_extend('rust', { 'rustdoc' })
  luasnip.filetype_extend('cs', { 'csharpdoc' })
  luasnip.filetype_extend('java', { 'javadoc' })
  luasnip.filetype_extend('c', { 'cdoc' })
  luasnip.filetype_extend('cpp', { 'cppdoc' })
  luasnip.filetype_extend('php', { 'phpdoc' })
  luasnip.filetype_extend('kotlin', { 'kdoc' })
  luasnip.filetype_extend('ruby', { 'rdoc' })
  luasnip.filetype_extend('sh', { 'shelldoc' })
end

return M
