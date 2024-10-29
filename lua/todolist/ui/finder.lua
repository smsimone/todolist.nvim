local state = require('todolist.state')
local n = require('nui-components')

--- @class TreeNode
--- @field text string
--- @field is_done boolean

local M = {}


--- Shows all the saved items
function M.show_items()
	local items = state.state.get_items()
	local render_tree = nil

	local nodes = {}
	for _, i in pairs(items) do
		table.insert(nodes, n.node({ text = i.name, is_done = i.completed }))
	end

	local signal = n.create_signal({ query = '', data = nodes })

	local renderer = n.create_renderer({
		width = 60,
		height = 10,
		mappings = {}
	})

	local subscription = signal:observe(function(old, curr)
		if not render_tree then return end

		--- @type string
		local query = curr.query
		local filtered = {}
		for _, item in pairs(curr.data) do
			--- @type string
			local text = item.text
			if not text:find(query) then
				render_tree:remove_node(item:get_id())
			end
		end

		curr.data = filtered
		if render_tree then
			-- vim.print(vim.inspect(render_tree))
		end
	end)

	local body = function()
		return n.rows({ flex = 2 },
			n.text_input({
				autofocus = true,
				size = 1,
				max_lines = 1,
				value = signal.query,
				border_label = "Filter",
				on_change = function(value)
					signal.query = value
				end
			}),
			n.tree({
				flex = 1,
				border_label = 'Tasks',
				data = signal.data,
				on_select = function(node, component)
					local tree = component:get_tree()
					if not render_tree then render_tree = tree end

					node.is_done = not node.is_done
					tree:render()
				end,
				prepare_node = function(node, line, component)
					local tree = component:get_tree()
					if not render_tree then render_tree = tree end

					if node.is_done then
						line:append("✔", "String")
					else
						line:append("◻", "Comment")
					end

					line:append(" ")
					line:append(node.text)

					return line
				end
			})
		)
	end
	renderer:on_unmount(function()
		subscription:unsubscribe()
	end)
	renderer:render(body)
end

return M
