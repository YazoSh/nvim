local g = vim.g
local fn = vim.fn

local plugins_count = fn.len(fn.globpath("~/.local/share/nvim/site/pack/packer/start", "*", 0, 1))

g.dashboard_disable_statusline = 1
g.dashboard_default_executive = "telescope"
g.dashboard_custom_header = {
" ██████  ██████  ██████  ███████     ██   ██  █████  ██   ██  █████ ",
"██      ██    ██ ██   ██ ██          ██   ██ ██   ██ ██   ██ ██   ██",
"██      ██    ██ ██   ██ █████       ███████ ███████ ███████ ███████",
"██      ██    ██ ██   ██ ██          ██   ██ ██   ██ ██   ██ ██   ██",
" ██████  ██████  ██████  ███████     ██   ██ ██   ██ ██   ██ ██   ██",
}

g.dashboard_custom_section = {
a = { description = { " פּ  File Tree    " }, command = "NvimTreeToggle" },
b = { description = { "   Find File    " }, command = "Telescope find_files" },
c = { description = { "   Recents      " }, command = "Telescope oldfiles" },
d = { description = { "   Find Word    " }, command = "Telescope live_grep" },
e = { description = { "   New File     " }, command = "DashboardNewFile" },
f = { description = { "   Bookmarks    " }, command = "Telescope marks" },
}

g.dashboard_custom_footer = {
" ",
"Plugins loaded: " .. plugins_count .. " plugins ",
}
