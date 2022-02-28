-- Neovim options

local options = {
	number = true,
	numberwidth = 2,
	signcolumn = "yes",
	expandtab = true,
	showmode = false,
	tabstop = 4,
	shiftwidth = 4,
	softtabstop = 4,
	showtabline = 2,
	scrolloff = 8,
	sidescrolloff = 8,
	wrap = false,
	cursorline = true,
	undofile = true,
	termguicolors = true,
	splitright = true,
	splitbelow = true,
	smartindent = true,
	ignorecase = true,
	smartcase = true,
	pumheight = 10,
	mouse = "a",
	hlsearch = true,
	fileencoding = "utf-8",
	conceallevel = 0,
	completeopt = { "menuone", "noselect" },
	cmdheight = 1,
}

vim.cmd([[set iskeyword+=-]])

for opt, v in pairs(options) do
	vim.opt[opt] = v
end
