--- @param conf configs?
local function setup(conf)
	require('config').set(conf)
	vim.api.nvim_create_user_command("TodoToggle", function() require('buf'):toggle_buffer() end, {})
end

return { setup = setup }
