local Path = require('plenary.path')

local File = {}
local Folder = {}

--- @param path string
function File.exists(path)
	local file = Path:new(path)
	return file:exists() and file:is_file()
end

--- @param path string
--- @returns string[]
function File.read_lines(path)
	local file = Path:new(path)
	if not file:exists() then
		return {}
	end
	--- @type string[]
	local lines = {}
	for line in file:iter() do
		if #line ~= 0 then
			table.insert(lines, line)
		end
	end
	return lines
end

--- @param path string
--- @return boolean
function Folder.exists(path)
	local dir = Path:new(path)
	return dir:exists() and dir:is_dir()
end

--- @param path string
function Folder.create(path)
	local dir = Path:new(path)
	if not dir:exists() then
		dir:mkdir({ parents = true })
	end
end

return {
	file = File,
	folder = Folder,
}
