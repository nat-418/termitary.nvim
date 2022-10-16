termitary.nvim
==============

![Drawing of a termitary](./termitary.jpg)

Termitary is a simple Neovim plugin for interacting with terminal buffers.

Usage
-----

Termitary ships a single `:Termitary` command with a few subcommands:

| name             | action                                                   |
| ---------------- | -------------------------------------------------------- |
| `activate`       | Set the current terminal buffer to work with Termitary   |
| `execute {text}` | Send some `{text}` to the active terminal with a `<CR>`  |
| `new`            | Open a new terminal buffer and `activate` it             |
| `paste`          | Send contents of the `"` register to the terminal buffer |
| `repeat`         | Emulate pressing `<Up><CR>` in the terminal buffer       |
| `{range}send`    | Put some `{range}` of the current buffer in the terminal |

For example, to send the contents of some buffer to a REPL running in the
active terminal buffer: `:%Termitary send`.

Installation
------------

Using [Packer](https://github.com/wbthomason/packer.nvim):
```lua
use({
  'https://github.com/nat-418/termitary.nvim',
  config = function()
    require('termitary').setup()
  end
})
```

Configuration
-------------

The default command name is `Termitary` but you can change it by setting
the `command_name` option in the `setup()` function, for example to `:T`:

```
require('termitary').setup({
  command_name = 'T'
})
```
