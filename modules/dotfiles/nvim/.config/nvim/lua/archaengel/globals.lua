P = function(x)
    print(vim.inspect(x))
    return x
end

if pcall(require, 'plenary') then
    RELOAD = require('plenary.reload').reload_module
    R = function(name)
        RELOAD(name)
        return require(name)
    end
end
