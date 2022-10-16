local M = {}

M.state = {
  terminal_id = nil
}

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
    vim.api.nvim_command('terminal')
    M.state.terminal_id = vim.b.terminal_job_id
    return true
  end

  -- The following subcommands require a terminal_id
  if M.state.terminal_id == nil then
    print('Error: no terminal is active')
    return false
  end

  if subcommand == 'execute' then
    if #args.fargs <= 0 then
      print('Error: nothing to execute')
    end

    for _, line in ipairs(args.fargs) do
      vim.api.nvim_chan_send(M.state.terminal_id, line)
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

M.setup = function(opts)
  local completion = function()
    return {
      'activate',
      'execute',
      'new',
      'paste',
      'repeat',
      'send'
    }
  end

  if opts.command_name == nil then
    opts.command_name = 'Termitary'
  end

  return vim.api.nvim_create_user_command(
    opts.command_name,
    function(args) M.run(args) end,
    {nargs = '*', complete = completion, range = true}
  )
end

return M
