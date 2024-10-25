
# 📋 Todolist.nvim

**Todolist.nvim** is a simple to-do list plugin for [Neovim](https://neovim.io/), perfect for keeping your tasks organized directly within the editor. With an intuitive interface and quick commands, you can create, edit, and view to-do lists for each workspace.

## 🚀 Installation

To install the plugin, add it to your preferred package manager. Here’s an example with **lazy.nvim**:

```lua
{
  "smsimone/todolist.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
  },
  config = function()
    require('todolist').setup({})
  end
}
```

Make sure to install the dependency [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim), which is required for this plugin to work.

## ✨ Commands

### Open the Todolist Buffer

To open and close the dedicated to-do list buffer, use the command:
```vim
:TodoToggle
```

### Adding and Editing Items

Once inside the to-do list buffer, you can:

- **Add a new item**: press `a`
- **Edit an existing item**: press `s`

To-do lists are organized by **workspace**, so you can keep your tasks neatly separated for each project.

## 🛠️ Configuration

If you need to customize the plugin's behavior, pass your options to the `setup` function. Here’s an example of a basic configuration:

```lua
require('todolist').setup({
  -- Add your options here
})
```

**Enjoy a more organized workflow with Todolist.nvim!** 🎉
