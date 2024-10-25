local fs = require('file')

local function ensure_folder()
	local folder = vim.fn.stdpath('data') .. "/todolist/"
	local file_path = folder .. vim.fn.fnamemodify(vim.loop.cwd(), ":t") .. ".todolist"

	if not fs.folder.exists(folder) then fs.folder.create(folder) end
end


vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>TodoToggle<cr>", {
	desc = "Toggle todos"
})

vim.api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.schedule(function() require('buf'):rewrite() end)
	end
})

ensure_folder()
