local actions = require('telescope.actions')
local function buffers()
    return require('telescope.builtin').buffers {
        attach_mappings = function(_, map)
            map('i', '<C-d>', actions.delete_buffer)

            return true
        end
    }
end

return {buffers = buffers}
