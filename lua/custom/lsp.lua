-- Custom LSP configurations
-- Called from inside the nvim-lspconfig config function in init.lua

local M = {}

function M.setup()
  -- GDScript (Godot 4) — server is embedded in Godot, not in Mason
  -- Godot must be open with the project for the LSP to work
  vim.lsp.config('gdscript', {
    cmd = vim.lsp.rpc.connect('127.0.0.1', 6005),
    filetypes = { 'gdscript' },
    root_dir = vim.fs.root(0, { 'project.godot', '.git' }),
  })
  vim.lsp.enable 'gdscript'

  -- basedpyright with custom analysis settings
  vim.lsp.config('basedpyright', {
    settings = {
      basedpyright = {
        analysis = {
          typeCheckingMode = 'standard',
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          autoImportCompletions = true,
          diagnosticMode = 'workspace',
        },
      },
    },
  })
  vim.lsp.enable 'basedpyright'

  -- Arduino language server
  vim.lsp.config('arduino_language_server', {
    cmd = {
      'arduino-language-server',
      '-clangd',
      vim.fn.exepath 'clangd',
      '-cli',
      vim.fn.exepath 'arduino-cli',
      '-cli-config',
      vim.fn.expand '~/.arduino15/arduino-cli.yaml',
      '-fqbn',
      'arduino:avr:mega',
    },
  })
  vim.lsp.enable 'arduino_language_server'
end

return M
