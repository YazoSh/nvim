local blank_status_ok, blank = pcall(require, "indent_blankline")
if not blank_status_ok then
	print("Error loading blank line indentaion plugin")
	return
end

blank.setup {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = false,
}
