
# 📋 Todolist.nvim

**Todolist.nvim** is a simple to-do list plugin for [Neovim](https://neovim.io/), perfect for keeping your tasks organized directly within the editor.

## 🚀 Installation

To install the plugin, add it to your preferred package manager. Here’s an example with **lazy.nvim**:

```lua
{
  "smsimone/todolist.nvim",
  dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
  },
  config = function()
    require('todolist').setup({})
  end
}
```

Make sure to install the dependency [`plenary.nvim`](https://github.com/nvim-lua/plenary.nvim), which is required for this plugin to work.

## ✨ Commands

### Open the tasks list

To open the tasks list simply run:
```vim
:TodoShow
```

### Adding a new task

Simple as running:
```vim
:TodoAdd
```
And confirming with `<S-CR>` when you're done.

## 🛠️ Configuration

If you need to customize the plugin's behavior, pass your options to the `setup` function. Here’s an example of a basic configuration:

```lua
require('todolist').setup({
  -- Add your options here
})
```

---

**Enjoy a more organized workflow with Todolist.nvim!** 🎉
