local state = require('todolist.state')

local n = require('nui-components')

local M = {}

function M.create_new_item()
	local renderer = n.create_renderer({ width = 60, height = 10 })

	local title, description = n.create_signal({ value = '' }), n.create_signal({ value = '' })

	local body = function()
		return n.form({
				id = 'new_item',
				submit_key = '<S-CR>',
				on_submit = function(is_valid)
					if not is_valid then
						vim.notify("Check if it's valid", vim.log.levels.ERROR)
						return
					end
					local name = title.value:get_value()

					state.state.add_item(state.Todo.new(name))
					vim.notify("Todo item '" .. name .. "' created", vim.log.levels.INFO)
					renderer:close()
				end
			},
			n.text_input({
				autofocus = true,
				autoresize = true,
				size = 1,
				value = title.value,
				border_label = 'Title',
				max_lines = 1,
				validate = n.validator.all(n.validator.min_length(3), n.validator.max_length(30)),
				on_change = function(value, component)
					title.value = value

					component:modify_buffer_content(function()
						component:set_border_text("bottom", "Length: " .. #value .. "/30",
							"right")
					end)
				end,
			}),
			n.text_input({
				flex = 1,
				border_label = 'Description',
				value = description.value,
				on_change = function(value, component)
					description.value = value

					component:modify_buffer_content(function()
						component:set_border_text("bottom", "Length: " .. #value, "right")
					end)
				end,
			})
		)
	end

	renderer:render(body)
end

return M
