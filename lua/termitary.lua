local M = {}

M.state = {
  custom_new  = nil, -- Allow a user to write their own `new` function at setup
  last_sent   = nil, -- Used by the `repeat` subcommand
  terminal_id = nil  -- Set by the `activate` function
}

-- Use the current terminal buffer
M.activate = function()
  if vim.b.terminal_job_id == nil then
    print('Error: not in a terminal buffer')
    return false
  end

  M.state.terminal_id = vim.b.terminal_job_id

  return true
end

-- Open a new terminal buffer and activate it
M.new = function()
  vim.api.nvim_command('terminal')
  return M.activate()
end

-- Send contents of a register to the active terminal buffer
M.paste = function(register_name)
  local register_contents = vim.fn.getreg(register_name)
  vim.api.nvim_chan_send(M.state.terminal_id, register_contents)
  M.state.last_sent = register_contents
  return true
end

-- Send the last sent text again (repeat alone is a reserved word in Lua)
M.repeater = function()
  vim.api.nvim_chan_send(M.state.terminal_id, M.state.last_sent)
  return true
end

-- Send raw lines of text
M.send = function(lines)
  M.state.last_sent = ''

  for _, line in ipairs(lines) do
    local with_newline = line .. '\r'
    vim.api.nvim_chan_send(M.state.terminal_id, with_newline)
    M.state.last_sent = M.state.last_sent .. with_newline
  end

  return true
end

-- Send text with a newline
M.type = function(words)
  M.state.last_sent = ''

  for _, word in ipairs(words) do
    local with_space = word .. ' '
    vim.api.nvim_chan_send(M.state.terminal_id, word .. ' ')
    M.state.last_sent = M.state.last_sent .. with_space
  end

  vim.api.nvim_chan_send(M.state.terminal_id, '\r')
  M.state.last_sent = M.state.last_sent .. '\r'

  return true
end

-- Parse subcommands etc.
M.run = function(args)
  if args == nil then return false end -- Bail if bad input

  local subcommand = table.remove(args.fargs, 1) -- Note: mutating `fargs` table

  if subcommand == nil        then return false        end -- Bail if bad input
  if subcommand == 'activate' then return M.activate() end
  if subcommand == 'new'      then return M.new()      end

  -- The following subcommands require a terminal_id
  if M.state.terminal_id == nil then
    print('Error: no terminal is active')
    return false
  end

  if subcommand == 'paste'  then return M.paste('"') end
  if subcommand == 'repeat' then return M.repeater() end

  if subcommand == 'send' then
    local selection = vim.api.nvim_buf_get_lines(
      0,
      args.line1 - 1,
      args.line2,
      {}
    )
    return M.send(selection)
  end

  if subcommand == 'type' then
    if #args.fargs <= 0 then
      print('Error: nothing to type')
      return false
    end
    return M.type(args.fargs)
  end

  print('Error: invalid subcommand')

  return false
end

-- Load plugin with optional user configuration
M.setup = function(options)
  if options.command_name == nil then options.command_name = 'Termitary' end
  if options.custom_new   ~= nil then M.new = options.custom_new         end

  local completion = function()
    return { 'activate', 'type', 'new', 'paste', 'repeat', 'send' }
  end

  vim.api.nvim_create_user_command(
    options.command_name,
    function(args) M.run(args) end,
    {nargs = '*', complete = completion, range = true}
  )

  return true
end

return M
