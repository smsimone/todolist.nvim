local bufname = 'TodoList'
local Todo    = require('todo')
local configs = require('config')
local alerts  = require('alerts')

local M       = {
	--- @type integer | nil id of the list buffer
	bufId = nil,

	--- @type Todo[]
	todos = {},
	---
	--- @type string
	file_path = ""
}

--- @return integer
local function get_cursor_index()
	return vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())[1]
end

function M:toggle_buffer()
	local folder   = vim.fn.stdpath('data') .. "/todolist/"
	self.file_path = folder .. vim.fn.fnamemodify(vim.loop.cwd(), ":t") .. ".todolist"


	if self:is_open() then
		vim.api.nvim_buf_delete(self.bufId, { unload = true })
		return
	end

	if not self.bufId then
		self:deserialize()
		self.bufId = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_buf_set_name(self.bufId, bufname)
	end

	self:register_keymaps()

	vim.cmd("vsplit")
	vim.api.nvim_win_set_buf(0, self.bufId)
	vim.api.nvim_win_set_width(0, 30)
	vim.schedule(function() self:rewrite() end)
end

function M:rewrite()
	vim.api.nvim_buf_set_option(self.bufId, 'modifiable', true)

	local max_width = configs.get_conf().max_length
	if not max_width then
		local winid = vim.fn.bufwinid(self.bufId)
		max_width = vim.api.nvim_win_get_width(winid) - 5
	end
	max_width = max_width - #configs.get_conf().text_ellipsis

	--- @type string[]
	local lines = {}
	for _, item in ipairs(self.todos) do
		table.insert(lines, item:printable_desc(max_width))
	end

	vim.api.nvim_buf_set_lines(self.bufId, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(self.bufId, 'modifiable', false)
end

function M:serialize()
	local file = io.open(self.file_path, "w+")
	assert(file ~= nil)

	for _, item in pairs(self.todos) do
		file:write(item:serialize() .. "\n")
	end
	vim.notify("Wrote " .. #self.todos .. " items")
	file:close()
	vim.notify("Wrote backup", vim.log.levels.DEBUG)
end

function M:deserialize()
	local lines = require 'file'.file.read_lines(self.file_path)
	vim.notify("Read " .. #lines .. " lines from backup")
	if #lines == 0 then return end

	for _, line in pairs(lines) do
		local item = Todo:deserialize(line)
		table.insert(self.todos, item)
	end
end

function M:register_keymaps()
	-- Open todo in a floating window
	vim.api.nvim_buf_set_keymap(self.bufId, "n", "<cr>", "", {
		desc = "Show item",
		noremap = true,
		silent = true,
		callback = function()
			local Popup = require('nui.popup')
			local Layout = require('nui.layout')

			local popup = Popup({ enter = true, border = 'single' })
			local layout = Layout(
				{
					position = "50%",
					size = { width = 80, height = '40%' },
				},
				Layout.Box({
					Layout.Box(popup, { size = "100%" })
				}),
				{ dir = "row" }
			)

			layout:mount()
		end
	})

	-- Creates a new item
	vim.api.nvim_buf_set_keymap(self.bufId, "n", "a", "",
		{
			desc = "Add item",
			noremap = true,
			silent = true,
			callback = function()
				alerts.input("Write something", nil, function(result)
					if not result then return end
					local item = Todo:new(result, false)
					if #self.todos == 0 then
						table.insert(self.todos, item)
					else
						local idx = get_cursor_index()
						table.insert(self.todos, idx + 1, item)
					end
					vim.schedule(function() self:rewrite() end)
					vim.schedule(function() self:serialize() end)
				end)
			end
		})

	-- Mark as completed
	vim.api.nvim_buf_set_keymap(self.bufId, "n", "c", "", {
		desc = "Mark as complete",
		noremap = true,
		silent = true,
		callback = function()
			local idx = get_cursor_index()
			self.todos[idx]:toggle_completed()
			vim.schedule(function() self:rewrite() end)
			vim.schedule(function() self:serialize() end)
		end
	})

	-- Changes an existent item
	vim.api.nvim_buf_set_keymap(self.bufId, "n", "s", "",
		{
			desc = "Edit item",
			noremap = true,
			silent = true,
			callback = function()
				local idx = get_cursor_index()

				alerts.input("Write something", self.todos[idx].desc, function(input)
					if not input then return end
					self.todos[idx] = Todo:new(input, false)
					vim.schedule(function() self:rewrite() end)
					vim.schedule(function() self:serialize() end)
				end)
			end
		})
end

--- checks if the buffer is currently displayed
--- @return boolean
function M:is_open()
	return self.bufId ~= nil and vim.api.nvim_buf_is_loaded(self.bufId) and vim.fn.bufwinnr(self.bufId) ~= -1
end

--- @param name string
--- @return integer | nil
function M.buf_exists(name)
	local buffers = vim.api.nvim_list_bufs()
	for _, buf in pairs(buffers) do
		local tmp_name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
		print("Bufid " .. buf .. " with name '" .. tmp_name .. "'")
		if tmp_name == name then
			return buf
		end
	end
	return nil
end

return M
