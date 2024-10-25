local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

---@param prompt string
---@param default string?
---@param on_submit function<string>
function M.input(prompt, default, on_submit)
	local input = Input({
		position = "50%",
		size = {
			width = 20,
		},
		border = {
			style = "single",
			text = {
				top = prompt,
				top_align = "center",
			},
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
end

return M
