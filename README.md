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

Both the command name and the how `new` works can be changed  in the
`setup` function. In this example we will remap the command name from
the default `Termitary` to `T` and add an integration with the
[FTerm](https://github.com/numtostr/FTerm.nvim) floating terminal plugin:

```lua
require('termitary').setup({
  command_name = 'T',
  custom_new = function()
    require('FTerm').open()
  end
})
```
