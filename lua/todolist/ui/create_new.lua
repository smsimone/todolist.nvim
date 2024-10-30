local state = require('todolist.state')
local Layout = require('nui.layout')
local Input = require("nui.input")

local M = {}

--- @param title string
---@param content string?
local function add_item(title, content)
	content = content == '' and nil or content
	state.state.add_item(state.Todo.new(title, content))
end

function M.create_new_item()
	--- @type string
	local title = ''
	--- @type string?
	local content = nil


	local task_title = Input({
		enter = true,
		focusable = true,
		border = {
			style = 'single',
			text = { top = "Name", top_align = 'left' }
		},
		win_options = {
			winhighlight = 'Normal:Normal,FloatBorder:Normal'
		}
	}, {
		on_change = function(value)
			title = value
		end
	})

	local task_content = Input({
		focusable = true,
		border = {
			style = 'single',
			text = { top = "Description", top_align = 'left' }
		},
		win_options = {
			winhighlight = 'Normal:Normal,FloatBorder:Normal'
		}
	}, {
		on_change = function(value)
			content = value
		end
	})

	local children = { task_title, task_content }

	local layout = Layout(
		{
			position = "50%",
			relative = { type = 'editor' },
			size = { width = 80, height = 10 },
		},
		Layout.Box({
			Layout.Box(task_title, { size = "10%" }),
			Layout.Box(task_content, { size = "90%" }),
		}, { dir = "col" })
	)

	layout:mount()

	for _, item in pairs(children) do
		item:map("n", "<esc>", function()
			layout:unmount()
		end)
	end

	local current = 1
	local function move_to_next_win()
		local next = current + 1
		if next > #children then
			next = 1
		end
		local item = children[next]
		vim.api.nvim_set_current_win(item.winid)
		current = next
	end

	for _, child in pairs(children) do
		local bufid = vim.api.nvim_win_get_buf(child.winid)

		for i = 1, #children do
			vim.api.nvim_buf_set_keymap(bufid, 'n', '' .. i, '', {
				noremap = true,
				silent = true,
				callback = function()
					local item = children[i]
					vim.api.nvim_set_current_win(item.winid)
				end
			})

			vim.api.nvim_buf_set_keymap(bufid, 'n', '<Tab>', '', {
				silent = false,
				noremap = true,
				callback = function()
					move_to_next_win()
				end
			})

			vim.api.nvim_buf_set_keymap(bufid, 'i', '<Tab>', '', {
				silent = false,
				noremap = true,
				callback = function()
					move_to_next_win()
				end
			})
		end
	end

	for _, item in pairs(children) do
		item:map('n', '<S-CR>', function()
			add_item(title, content)
			vim.notify('Added task with title ' .. title)
			layout:unmount()
		end)
		item:map('i', '<S-CR>', function()
			add_item(title, content)
			vim.notify('Added task with title ' .. title)
			layout:unmount()
		end)
		item:map("n", "<esc>", function()
			layout:unmount()
		end)
	end
	layout:mount()
end

return M
