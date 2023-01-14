termitary.nvim 🐜
=================

Termitary is a simple Neovim plugin for interacting with terminal buffers.
Termitary hooks into any terminal buffer—native or provided by another
plugin—and provides a remote control interface. With Termitary, there is 
no need to jump across buffers to re-run some test. Just bind a key
to `:Termitary repeat` and get your test results as you go along. You
can also yank and paste into the terminal without switching buffers,
send a visual selection, or pass a range of lines.

Installation
------------

```sh
$ git clone --depth 1 https://github.com/nat-418/termitary.nvim ~/.local/share/nvim/site/pack/termitary/start/termitary.nvim
```

Usage
-----

Termitary ships a single `:Termitary` command with a few subcommands:

| name             | action                                                   |
| ---------------- | -------------------------------------------------------- |
| `activate`       | Set the current terminal buffer to work with Termitary   |
| `new`            | Open a new terminal buffer and `activate` it             |
| `paste`          | Send contents of the `"` register to the terminal buffer |
| `repeat`         | Send what was sent last again                            |
| `{range}send`    | Put some `{range}` of the current buffer in the terminal |
| `type {text}`    | Send some `{text}` to the active terminal with a `<CR>`  |

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
  local termitary = require('termitary')
  termitary.setup({
    command_name = 'T',
    custom_new = function()
      require('FTerm').open()
      termitary.activate()
    end
  })
})
```

Or to open a new native terminal ten lines tall under the current buffer:

```lua
require('termitary').setup({
  local termitary = require('termitary')
  termitary.setup({
    command_name = 'T',
    custom_new = function()
      vim.cmd('botright 10new')
      vim.cmd('terminal')
      termitary.activate()
      vim.cmd('normal G')
      vim.cmd('wincmd p')
    end
  })
})
```
