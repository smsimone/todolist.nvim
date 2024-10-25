local config = require 'config'
local Strings = require 'strings'

---@class Todo
---@field desc string
---@field completed boolean
local Todo = { desc = "", completed = false }

Todo.__index = Todo

---@param desc string
---@param completed boolean | nil
function Todo:new(desc, completed)
	assert(desc ~= nil)
	local instance = setmetatable({}, Todo)
	instance.desc = desc
	instance.completed = completed or false
	return instance
end

--- @param max_width integer
--- @return string
function Todo:printable_desc(max_width)
	local check = " "
	if self.completed then check = config.get_conf().completed_symbol end
	local str = "[" .. check .. "] " .. self.desc
	return Strings.clamp(str, max_width, config.get_conf().text_ellipsis)
end

function Todo:toggle_completed()
	self.completed = not self.completed
end

--- @return string
function Todo:serialize()
	local flg_completed = 0
	if self.completed then flg_completed = 1 end
	--- @type integer[]
	local bytes = { flg_completed }
	for i = 1, #self.desc do
		table.insert(bytes, string.byte(self.desc, i))
	end
	return require('strings').join(bytes, ',')
end

--- @param data string
function Todo:deserialize(data)
	local bytes = require('strings').split(data, ',')
	local flg_completed = bytes[1]

	local instance = setmetatable({}, Todo)
	if flg_completed == 1 then instance.completed = true else instance.completed = false end

	local desc = ""
	for i = 2, #bytes do
		desc = desc .. string.char(bytes[i])
	end
	instance.desc = desc

	return instance
end

return Todo
