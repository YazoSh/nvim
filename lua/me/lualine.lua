local lualine_status_ok, lualine = pcall(require, "lualine")
if not lualine_status_ok then
	return
end

local colors = {
	yellow = "#ecbe7b",
	blue = "#36A3D9",
	red = "#Ec5f67",
}

local list_registered_providers_names = function(filetype)
	local s = require("null-ls.sources")
	local available_sources = s.get_available(filetype)
	local registered = {}
	for _, source in ipairs(available_sources) do
		for method in pairs(source.methods) do
			registered[method] = registered[method] or {}
			table.insert(registered[method], source.name)
		end
	end
	return registered
end

local list_registered_formatters = function(filetype)
	local null_ls_methods = require("null-ls.methods")
	local formatter_method = null_ls_methods.internal["FORMATTING"]
	local registered_providers = list_registered_providers_names(filetype)
	return registered_providers[formatter_method] or {}
end

local list_registered_linters = function(filetype)
	local null_ls_methods = require("null-ls.methods")
	local formatter_method = null_ls_methods.internal["DIAGNOSTICS"]
	local registered_providers = list_registered_providers_names(filetype)
	return registered_providers[formatter_method] or {}
end

local conditions = {
	buffer_not_empty = function()
		return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
	end,
	hide_in_width = function()
		return vim.fn.winwidth(0) > 80
	end,
	check_git_workspace = function()
		local filepath = vim.fn.expand("%:p:h")
		local gitdir = vim.fn.finddir(".git", filepath .. ";")
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end,
}

local config = {
	options = {
        theme = "ayu_dark",
		disabled_filetypes = { "alpha", "NvimTree", "neo-tree", "dashboard", "Outline" },
		component_separators = "",
		section_separators = "",
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_y = {},
		lualine_z = {},
		lualine_c = {},
		lualine_x = {},
	},
}

local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left({
	function()
		return "▊▊"
	end,
	padding = { left = 0, right = 0 },
})

ins_left({
	"mode",
    padding = { left = 1, right = 0 },
})

ins_left({
	"branch",
	icon = "",
	icons_enabled = true,
	padding = { left = 2, right = 1 },
})

ins_left({
	"filetype",
	cond = conditions.buffer_not_empty,
	padding = { left = 2, right = 1 },
})

ins_left({
	"diff",
	symbols = { added = " ", modified = "柳 ", removed = " " },
	diff_color = {
		added = { fg = colors.green },
		modified = { fg = colors.blue },
		removed = { fg = colors.red },
	},
	cond = conditions.hide_in_width,
	padding = { left = 2, right = 1 },
})

ins_left({
	"diagnostics",
	sources = { "nvim_diagnostic" },
	symbols = { error = " ", warn = " ", info = " ", hint = " " },
	diagnostics_color = {
		color_error = { fg = colors.red },
		color_warn = { fg = colors.yellow },
		color_info = { fg = colors.cyan },
	},
	padding = { left = 2, right = 1 },
})

ins_left({
	function()
		return "%="
	end,
})

ins_right({
	function(_)
		local Lsp = vim.lsp.util.get_progress_messages()[1]

		if Lsp then
			local msg = Lsp.message or ""
			local percentage = Lsp.percentage or 0
			local title = Lsp.title or ""
			local spinners = {
				"",
				"",
				"",
			}

			local success_icon = {
				"",
				"",
				"",
			}

			local ms = vim.loop.hrtime() / 1000000
			local frame = math.floor(ms / 120) % #spinners

			if percentage >= 70 then
				return string.format(" %%<%s %s %s (%s%%%%) ", success_icon[frame + 1], title, msg, percentage)
			end

			return string.format(" %%<%s %s %s (%s%%%%) ", spinners[frame + 1], title, msg, percentage)
		end

		return ""
	end,
	color = { gui = "none" },
	padding = { left = 0, right = 1 },
	cond = conditions.hide_in_width,
})

ins_right({
	function(msg)
		msg = msg or "Inactive"
		local buf_clients = vim.lsp.buf_get_clients()
		if next(buf_clients) == nil then
			if type(msg) == "boolean" or #msg == 0 then
				return "Inactive"
			end
			return msg
		end
		local buf_ft = vim.bo.filetype
		local buf_client_names = {}

		for _, client in pairs(buf_clients) do
			if client.name ~= "null-ls" then
				table.insert(buf_client_names, client.name)
			end
		end

		local supported_formatters = list_registered_formatters(buf_ft)
		vim.list_extend(buf_client_names, supported_formatters)

		local supported_linters = list_registered_linters(buf_ft)
		vim.list_extend(buf_client_names, supported_linters)

		return table.concat(buf_client_names, ", ")
	end,
	icon = " ",
	icons_enabled = true,
	color = { gui = "none" },
	padding = { left = 0, right = 1 },
	cond = conditions.hide_in_width,
})

ins_right({
	function()
		local b = vim.api.nvim_get_current_buf()
		if next(vim.treesitter.highlighter.active[b]) then
			return " 綠TS"
		end
		return ""
	end,
	padding = { left = 1, right = 0 },
	cond = conditions.hide_in_width,
})

ins_right({
	"location",
	padding = { left = 1, right = 1 },
})

ins_right({
	"progress",
	padding = { left = 0, right = 0 },
})

ins_right({
	function()
		return "▊▊"
	end,
	padding = { left = 1, right = 0 },
})

lualine.setup(config)
