vim.g.base46_cache = vim.fn.stdpath "data" .. "/nvchad/base46/"
vim.g.mapleader = " "

-- fix notify wining pt 1
vim.opt.termguicolors = true

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
    config = function()
      require "options"
    end,
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)

-- setup noice.nvim
require("noice").setup {
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = false, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
}

-- fix notify wining pt 2
require("notify").setup {
  background_colour = "#000000",
}

-- setup mini animate
require("mini.animate").setup()

-- setup nvim-lsputils
if vim.fn.has "nvim-0.5.1" == 1 then
  vim.lsp.handlers["textDocument/codeAction"] = require("lsputil.codeAction").code_action_handler
  vim.lsp.handlers["textDocument/references"] = require("lsputil.locations").references_handler
  vim.lsp.handlers["textDocument/definition"] = require("lsputil.locations").definition_handler
  vim.lsp.handlers["textDocument/declaration"] = require("lsputil.locations").declaration_handler
  vim.lsp.handlers["textDocument/typeDefinition"] = require("lsputil.locations").typeDefinition_handler
  vim.lsp.handlers["textDocument/implementation"] = require("lsputil.locations").implementation_handler
  vim.lsp.handlers["textDocument/documentSymbol"] = require("lsputil.symbols").document_handler
  vim.lsp.handlers["workspace/symbol"] = require("lsputil.symbols").workspace_handler
else
  local bufnr = vim.api.nvim_buf_get_number(0)

  vim.lsp.handlers["textDocument/codeAction"] = function(_, _, actions)
    require("lsputil.codeAction").code_action_handler(nil, actions, nil, nil, nil)
  end

  vim.lsp.handlers["textDocument/references"] = function(_, _, result)
    require("lsputil.locations").references_handler(nil, result, { bufnr = bufnr }, nil)
  end

  vim.lsp.handlers["textDocument/definition"] = function(_, method, result)
    require("lsputil.locations").definition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/declaration"] = function(_, method, result)
    require("lsputil.locations").declaration_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/typeDefinition"] = function(_, method, result)
    require("lsputil.locations").typeDefinition_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/implementation"] = function(_, method, result)
    require("lsputil.locations").implementation_handler(nil, result, { bufnr = bufnr, method = method }, nil)
  end

  vim.lsp.handlers["textDocument/documentSymbol"] = function(_, _, result, _, bufn)
    require("lsputil.symbols").document_handler(nil, result, { bufnr = bufn }, nil)
  end

  vim.lsp.handlers["textDocument/symbol"] = function(_, _, result, _, bufn)
    require("lsputil.symbols").workspace_handler(nil, result, { bufnr = bufn }, nil)
  end
end
