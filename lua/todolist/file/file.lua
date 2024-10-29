local Path = require('plenary.path')

local M = {}

--- @return string
function M.get_workspace_file()
	local data_path = vim.fn.stdpath("data")
	local folder_name = data_path .. "/todolist/" .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
	return folder_name .. ".json"
end

--- Ensures that the data/todolist folder exists
function M.ensure_folder_exists()
	local data_path = vim.fn.stdpath("data")
	local folder_name = data_path .. "/todolist"
	Path:new(folder_name):mkdir({ parents = true })
end

return M
