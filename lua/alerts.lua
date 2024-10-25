local Input = require("nui.input")
local Popup = require('nui.popup')
local event = require("nui.utils.autocmd").event

local M = {}

---@param prompt string
---@param default string?
---@param on_submit function<string>
function M.input(prompt, default, on_submit)
	local input = Input({
		position = "50%",
		size = {
			width = '40%',
		},
		border = {
			style = "single",
			text = {
				top = prompt,
				top_align = "center",
			},
		},
		relative = {
			type = "editor"
		},
		win_options = {
			winhighlight = "Normal:Normal,FloatBorder:Normal",
		},
	}, {
		prompt = "> ",
		default_value = default,
		on_submit = on_submit,
	})
	input:mount()
	input:on(event.BufLeave, function() input:unmount() end)
	input:map("n", "<Esc>", function() input:unmount() end, { noremap = true })
end

--- @param title string
--- @param content string
function M.info(title, content)
	local popup = Popup({
		enter = true,
		focusable = true,
		relative = {
			type = "editor"
		},
		border = {
			style = "rounded",
			text = {
				top = title,
				top_align = 'center'
			},
		},
		position = '50%',
		size = { width = 40, height = '20%' },
	})
	popup:mount()
	popup:on(event.BufLeave, function() popup:unmount() end)
	popup:map("n", "<Esc>", function() popup:unmount() end, { noremap = true })

	vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { content })
	vim.api.nvim_buf_set_option(popup.bufnr, 'wrap', true)
end

return M
