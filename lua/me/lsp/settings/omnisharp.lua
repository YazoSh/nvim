local nvim_lsp = require'lspconfig'

return {
	root_dir = nvim_lsp.util.root_pattern("*.csproj","*.sln"),
	init_options = {
		cake = {
			enabled = false;
		},
		msbuild = {
			enabled = false;
		},
		dotnet = {
			enabled = false;
		},
		script = {
			enabled = false;
		},
	},
	...
}
