local arrays = require('todolist.utils.arrays')
local file = require('todolist.file.file')

local State = {}

--- @type Todo[]
local items = {}

--- @param mode 'r' | 'w+'
--- @return file*?
local function get_file(mode)
	local ws_file = file.get_workspace_file()
	local ff = io.open(ws_file, mode)
	return ff
end

local function on_load()
	local ff = get_file('r')
	if not ff then return end

	local content = ff:read('*a')
	ff:close()

	--- @type Todo[]
	local data = vim.fn.json_decode(content)
	items = data
end

on_load()

local function persist()
	--- @type string
	local values = vim.fn.json_encode(items)

	local ff = get_file('w+')
	if not ff then return end

	ff:write(values)
	ff:close()
end

--- @return Todo[]
function State.get_items()
	return items
end

--- @param id string Uuid of the item that must be toggled
function State.toggle_completion(id)
	local idx = arrays.find_index(items,
		--- @param item Todo
		function(item)
			return item.id == id
		end)
	if idx < 0 then
		vim.notify('The item with id ' .. id .. ' does not exists', vim.log.levels.ERROR)
	end
end

--- @param item Todo
function State.add_item(item)
	table.insert(items, item)
	vim.schedule(function() persist() end)
end

return State
