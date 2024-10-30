local state = require('todolist.state')
local NuiTree = require('nui.tree')
local NuiLine = require("nui.line")
local Popup = require('nui.popup')
local Layout = require('nui.layout')
local Input = require("nui.input")

--- @class TreeNode
--- @field text string
--- @field is_done boolean

--- @class Mapping
--- @field lhs string
--- @field command string | function

local M = {}
local timer = nil

local function debounce(fn, delay)
	return function(...)
		local args = { ... }

		if timer then
			timer:close()
			timer = nil
		end

		timer = vim.defer_fn(function()
			fn(unpack(args))
			timer = nil
		end, delay)
	end
end

--- Shows all the saved items
function M.show_items()
	local items = state.state.get_items()
	local nodes = {}
	for _, i in pairs(items) do
		local node = nil
		node = NuiTree.Node({
			text = i.name,
			is_done = i.completed,
			description = i.description
		})

		table.insert(nodes, node)
	end

	local popup = Popup({
		focusable = true,
		border = {
			style = 'rounded',
			text = {
				top = '[2] - Tasks',
				top_align = 'left'
			}
		},
	})

	local tree = NuiTree({
		bufnr        = popup.bufnr,
		border       = 'single',
		nodes        = nodes,
		focusable    = true,
		prepare_node = function(node, _)
			local line = NuiLine()
			line:append(string.rep("  ", node:get_depth() - 1))


			if node['is_done'] ~= nil then
				line:append(node.is_done and "✔ " or "◻ ")
			end

			line:append(node.text)
			line:append("  ")

			return line
		end
	})

	local searchBox = Input({
		enter = true,
		focusable = true,
		border = {
			style = 'single',
			text = { top = "[1] - Search something", top_align = 'left' }
		},
		win_options = {
			winhighlight = 'Normal:Normal,FloatBorder:Normal'
		}
	}, {
		prompt = "> ",
		on_change = function(value)
			debounce(function()
				-- Always removes all nodes
				for _, node in pairs(tree:get_nodes()) do
					tree:remove_node(node:get_id())
				end

				if value == '' then
					for _, node in pairs(nodes) do
						tree:add_node(node)
					end
				else
					for _, node in pairs(nodes) do
						if node.text:find(value) then
							tree:add_node(node)
						end
					end
				end

				tree:render()
			end, 400)()
		end
	})

	local children = { searchBox, popup }

	local layout = Layout(
		{
			position = "50%",
			relative = { type = 'editor' },
			size = { width = 80, height = 10 },
		},
		Layout.Box({
			Layout.Box(searchBox, { size = "10%" }),
			Layout.Box(popup, { size = "90%" }),
		}, { dir = "col" })
	)

	layout:mount()
	tree:render()

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

	--- TODO: is not working right now
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
		end
	end

	local map_opts = { noremap = true, nowait = true }

	popup:map("n", "<cr>", function()
		local node = tree:get_node()
		node.is_done = not node.is_done
		tree:render()
	end, map_opts)

	popup:map("n", "x", function()
		local node = tree:get_node()
		tree:remove_node(node:get_id())
		tree:render()
	end, map_opts)
end

return M
