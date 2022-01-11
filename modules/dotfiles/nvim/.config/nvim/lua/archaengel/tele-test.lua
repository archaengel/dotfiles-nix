local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local make_entry = require('telescope.make_entry')

local cmd_gen = function() return {"cat", [[test_entry_lines.txt]]} end
local test_finder = finders.new_job(cmd_gen, make_entry.gen_from_string(), 10,
                                    "~")

local M = {}
M.tele_test_picker = function() pickers.new({finder = test_finder}):find() end

return M

