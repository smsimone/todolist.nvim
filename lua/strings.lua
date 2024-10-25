local M = {}

--- @param data integer[]
--- @param sep string
--- @return string
function M.join(data, sep)
	local str = ""
	for _, v in pairs(data) do
		if #str == 0 then
			str = "" .. v
		else
			str = str .. sep .. v
		end
	end
	return str
end

--- @param data string
--- @param sep string
--- @return integer[]
function M.split(data, sep)
	local result = {}
	-- Usa gmatch per iterare su ogni parte della stringa divisa dal separatore
	for match in (data .. sep):gmatch("(.-)" .. sep) do
		table.insert(result, tonumber(match, 10))
	end
	return result
end

--- @param str string
--- @param width integer
--- @param ellipsis string
--- @return string
function M.clamp(str, width, ellipsis)
	if #str <= width then return str end
	local substr = str:sub(1, width)
	return substr .. ellipsis
end

return M
