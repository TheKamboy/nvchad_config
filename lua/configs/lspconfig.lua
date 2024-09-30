-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = { "html", "cssls", "rust_analyzer", "gopls", "marksman", "bashls" }
local nvlsp = require "nvchad.configs.lspconfig"

-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

-- configuring single server, example: typescript
-- lspconfig.tsserver.setup {
--   on_attach = nvlsp.on_attach,
--   on_init = nvlsp.on_init,
--   capabilities = nvlsp.capabilities,
-- }

-- better code action (fzf)
local autocmd = vim.api.nvim_create_autocmd
autocmd("LspAttach", {
  callback = function(args)
    vim.schedule(function()
      vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>lua require('fzf-lua').lsp_code_actions()<cr>", {buffer = args.buf, desc="LSP Code action"})
    end)
  end,
})
