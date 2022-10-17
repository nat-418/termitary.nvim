local M = {}

M.state = {
  custom_new  = nil,
  terminal_id = nil
}

M.activate = function()
  M.state.terminal_id = vim.b.terminal_job_id
  return true
end

M.run = function(args)
  if args == nil then return false end

  -- Warning: mutating fargs table
  local subcommand = table.remove(args.fargs, 1)

  if subcommand == nil then return false end

  if subcommand == 'activate' then
    M.state.terminal_id = vim.b.terminal_job_id

    if M.state.terminal_id == nil then
      print('Error: not in a terminal buffer')
      return false
    end

    return true
  end

  if subcommand == 'new' then
    if M.state.custom_new == nil then
      vim.api.nvim_command('terminal')
      vim.api.nvim_command('norm G')
      M.activate()
      return true
    else
      return M.state.custom_new()
    end

    return false
  end

  -- The following subcommands require a terminal_id
  if M.state.terminal_id == nil then
    print('Error: no terminal is active')
    return false
  end

  if subcommand == 'type' then
    if #args.fargs <= 0 then
      print('Error: nothing to type')
      return false
    end

    for _, word in ipairs(args.fargs) do
      vim.api.nvim_chan_send(M.state.terminal_id, word .. ' ')
    end

    vim.api.nvim_chan_send(M.state.terminal_id, '\r')

    return true
  end

  if subcommand == 'repeat' then
    -- Send Up arrow code
    return vim.api.nvim_chan_send(M.state.terminal_id, '\x1b\x5b\x41\r')
  end

  if subcommand == 'send' then
    local selection = vim.api.nvim_buf_get_lines(
      0,
      args.line1 - 1,
      args.line2,
      {}
    )

    for _, line in ipairs(selection) do
      vim.api.nvim_chan_send(M.state.terminal_id, (line .. '\r'))
    end

    return true
  end

  if subcommand == 'paste' then
    return vim.api.nvim_chan_send(
      M.state.terminal_id,
      vim.fn.getreg('"')
    )
  end

  return false
end

M.setup = function(options)
  local completion = function()
    return {
      'activate',
      'type',
      'new',
      'paste',
      'repeat',
      'send'
    }
  end

  if options.command_name == nil then
    options.command_name = 'Termitary'
  end

  if options.custom_new ~= nil then
    M.state.custom_new = options.custom_new
  end

  vim.api.nvim_create_user_command(
    options.command_name,
    function(args) M.run(args) end,
    {nargs = '*', complete = completion, range = true}
  )

  return true
end

return M
