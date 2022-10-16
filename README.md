termitary.nvim
==============

![Drawing of a termitary](./termitary.jpg)

Termitary is a simple Neovim plugin for interacting with terminal buffers.
Termitary hooks into any terminal buffer—native or provided by another
plugin—and provides a remote control interface. With Termitary, there is 
no need to jump across buffers to re-run some test. Just bind a key
to `:Termitary repeat` and get your test results as you go along. You
can also yank and paste into the terminal without switching buffers,
send a visual selection, or pass a range of lines.

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

Configuration
-------------

The default command name is `Termitary` but you can change it by setting
the `command_name` option in the `setup()` function, for example to `T`:

```lua
require('termitary').setup({
  command_name = 'T'
})
```
