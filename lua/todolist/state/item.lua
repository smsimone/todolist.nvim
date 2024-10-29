--- @class Todo
--- @field id string
--- @field name string
--- @field description string?
--- @field completed boolean
local Todo = {}
Todo.__index = Todo

local function generate_uuid()
	local random = math.random
	local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
	return string.gsub(template, "[xy]", function(c)
		local v = (c == "x") and random(0, 15) or random(8, 11)
		return string.format("%x", v)
	end)
end

--- @param name string
--- @param description string?
--- @return Todo
function Todo.new(name, description)
	local self = setmetatable({}, Todo)
	self.id = generate_uuid()
	self.name = name
	self.completed = false
	self.description = description
	return self
end

return Todo
