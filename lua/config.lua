---@class S
---@field conf configs
local M = {}

--- @class configs
--- @field completed_symbol string
--- @field max_length integer? if null, will be used the column width
--- @field text_ellipsis string
local config = {
	completed_symbol = 'x',
	max_length = nil,
	text_ellipsis = '...'
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
