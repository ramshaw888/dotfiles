-- lsp_timing.lua - Track LSP request performance
local M = {}
M.requests = {}
local telescope_patched = false

-- Original request function
local orig_request = vim.lsp.buf_request

-- Override the request function
vim.lsp.buf_request = function(bufnr, method, params, handler)
  local request_id

  -- Get the client
  local clients = vim.lsp.get_active_clients({bufnr = bufnr})
  local client = clients and clients[1]

  if client then
    local start_time = vim.loop.hrtime()

    -- Create a wrapped handler to track completion time
    local wrapped_handler = function(err, result, ctx, config)
      local end_time = vim.loop.hrtime()
      local duration_ms = (end_time - start_time) / 1000000

      -- Log timing info
      local log_entry = {
        method = method,
        client = client.name,
        duration_ms = duration_ms,
        success = err == nil,
        timestamp = os.time()
      }

      table.insert(M.requests, log_entry)

      -- Log to console if requested
      if M.log_to_console then
        print(string.format("LSP: %s - %s completed in %.2f ms", 
                           client.name, method, duration_ms))
      end

      -- Call original handler
      if handler then
        return handler(err, result, ctx, config)
      end
    end

    -- Call original request with wrapped handler
    return orig_request(bufnr, method, params, wrapped_handler)
  else
    -- No active client, just pass through
    return orig_request(bufnr, method, params, handler)
  end
end

-- Patch Telescope's LSP request function
local function patch_telescope()
  if telescope_patched then return end

  -- Only do this if telescope is loaded
  local ok, telescope_lsp = pcall(require, "telescope.lsp")
  if not ok then return end

  -- Store the original make_request function
  local original_make_request = telescope_lsp.make_request

  -- Override with our timing wrapper
  telescope_lsp.make_request = function(bufnr, method, params, opts)
    local start_time = vim.loop.hrtime()

    -- Track the request
    local client_id = opts and opts.client_id
    local client_name = "telescope"

    if client_id then
      local client = vim.lsp.get_client_by_id(client_id)
      if client then
        client_name = client.name
      end
    else
      -- Try to get the first active client for this buffer
      local clients = vim.lsp.get_active_clients({bufnr = bufnr})
      if clients and clients[1] then
        client_name = clients[1].name
      end
    end

    -- Call the original with modified callback
    local results = original_make_request(bufnr, method, params, opts)

    -- Calculate duration in a delayed manner
    vim.defer_fn(function()
      local end_time = vim.loop.hrtime()
      local duration_ms = (end_time - start_time) / 1000000

      -- Log timing info
      local log_entry = {
        method = method,
        client = client_name,
        duration_ms = duration_ms,
        success = true, -- We don't know if it failed without modifying deeper
        timestamp = os.time()
      }

      table.insert(M.requests, log_entry)

      -- Log to console if requested
      if M.log_to_console then
        print(string.format("LSP (Telescope): %s - %s completed in %.2f ms", 
                           client_name, method, duration_ms))
      end
    end, 10) -- Small delay to ensure the request has completed

    return results
  end

  telescope_patched = true
  print("Telescope LSP functions patched for timing")
end

-- Patch Telescope's builtin functions
local function patch_telescope_builtins()
  local ok, builtin = pcall(require, "telescope.builtin")
  if not ok then return end

  -- List of LSP-related builtin functions to patch
  local lsp_functions = {
    "lsp_references",
    "lsp_definitions",
    "lsp_implementations",
    "lsp_type_definitions",
    "lsp_document_symbols",
    "lsp_workspace_symbols",
    "lsp_dynamic_workspace_symbols",
    "lsp_incoming_calls",
    "lsp_outgoing_calls"
  }

  for _, func_name in ipairs(lsp_functions) do
    local original_func = builtin[func_name]

    -- Skip if function doesn't exist
    if not original_func then goto continue end

    builtin[func_name] = function(opts)
      local start_time = vim.loop.hrtime()

      -- Call the original function
      local result = original_func(opts)

      -- Record timing in a deferred manner
      vim.defer_fn(function()
        local end_time = vim.loop.hrtime()
        local duration_ms = (end_time - start_time) / 1000000

        -- Log timing info
        local log_entry = {
          method = "telescope." .. func_name,
          client = "telescope_builtin",
          duration_ms = duration_ms,
          success = true,
          timestamp = os.time()
        }

        table.insert(M.requests, log_entry)

        -- Log to console if requested
        if M.log_to_console then
          print(string.format("Telescope: %s completed in %.2f ms", 
                             func_name, duration_ms))
        end
      end, 100) -- Longer delay for Telescope operations

      return result
    end

    ::continue::
  end

  print("Telescope builtin LSP functions patched for timing")
end

-- Helper function to print stats
M.print_stats = function()
  if #M.requests == 0 then
    print("No LSP requests recorded")
    return
  end

  local stats = {}

  -- Group by method and client
  for _, req in ipairs(M.requests) do
    local key = req.client .. ":" .. req.method
    stats[key] = stats[key] or {
      count = 0,
      total_ms = 0,
      min_ms = math.huge,
      max_ms = 0,
      client = req.client,
      method = req.method
    }

    local entry = stats[key]
    entry.count = entry.count + 1
    entry.total_ms = entry.total_ms + req.duration_ms
    entry.min_ms = math.min(entry.min_ms, req.duration_ms)
    entry.max_ms = math.max(entry.max_ms, req.duration_ms)
  end

  -- Convert to array for sorting
  local stats_array = {}
  for _, stat in pairs(stats) do
    stat.avg_ms = stat.total_ms / stat.count
    table.insert(stats_array, stat)
  end

  -- Sort by average duration (slowest first)
  table.sort(stats_array, function(a, b) return a.avg_ms > b.avg_ms end)

  -- Print the results
  print("\nLSP Request Statistics:")
  print(string.format("%-20s %-30s %-8s %-8s %-8s %-8s", 
                     "CLIENT", "METHOD", "COUNT", "AVG(ms)", "MIN(ms)", "MAX(ms)"))
  print(string.rep("-", 80))

  for _, stat in ipairs(stats_array) do
    print(string.format("%-20s %-30s %-8d %-8.2f %-8.2f %-8.2f",
                       stat.client, stat.method, stat.count,
                       stat.avg_ms, stat.min_ms, stat.max_ms))
  end
end

-- Enable console logging
M.log_to_console = true

-- Create a command to view stats
vim.api.nvim_create_user_command("LspStats", function()
  M.print_stats()
end, {})

-- Reset stats
vim.api.nvim_create_user_command("LspStatsReset", function()
  M.requests = {}
  print("LSP request statistics reset")
end, {})

-- Initialize and patch when this module loads
local function initialize()
  -- Make sure Telescope is patched when it's loaded
  if package.loaded["telescope"] then
    patch_telescope()
    patch_telescope_builtins()
  else
    -- Set up autocommand to patch Telescope when it loads
    vim.api.nvim_create_autocmd("User", {
      pattern = "TelescopeLoaded",
      callback = function()
        patch_telescope()
        patch_telescope_builtins()
      end,
      once = true
    })
  end
end

initialize()

return M
