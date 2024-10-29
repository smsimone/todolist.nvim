local M = {}

--- @param array table
--- @param comparator function
--- @return integer > 0 if the item exists, <= 0 otherwise
function M.find_index(array, comparator)
	for idx, item in ipairs(array) do
		if comparator(item) then
			return idx
		end
	end
	return -1
end

return M
