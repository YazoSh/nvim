local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
    return
end

require("me.lsp.lsp-installer")
require("me.lsp.handlers").setup()
require "me.lsp.null-ls"
