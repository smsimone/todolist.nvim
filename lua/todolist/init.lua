local ui = require('todolist.ui')

local M = {}

local function register_user_commands()
	vim.api.nvim_create_user_command('TodoShow', function()
		ui.finder.show_items()
	end, {})
	vim.api.nvim_create_user_command('TodoAdd', function()
		ui.create_new.create_new_item()
	end, {})
end

--- @param configs Configs?
function M.setup(configs)
	configs = configs or {}
	register_user_commands()
end

return M
