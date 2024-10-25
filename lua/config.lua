---@class S
---@field conf configs
local M = {}

--- @class symbols
--- @field completed string
--- @field todo string

--- @class configs
--- @field item_symbols symbols
--- @field max_length integer? if null, will be used the column width
--- @field text_ellipsis string
--- @field reorder_elements boolean if true, the completed elements will be put at the end of the list
local config = {
	item_symbols = {
		todo = '[]',
		completed = '[x]',
	},
	max_length = nil,
	text_ellipsis = '...',
	reorder_elements = false
}

--- get the full user config or just a specified value
---@param key string?
---@return any
function M.get(key)
	if key then return config[key] end
	return config
end

--- @return configs
function M.get_conf()
	return config
end

---@param user_conf configs?
---@return configs
function M.set(user_conf)
	user_conf = user_conf or {}
	config = vim.tbl_deep_extend("force", config, user_conf)
	return config
end

return M
