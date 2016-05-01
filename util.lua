
local Util = {}

Util.debug = false
Util.inspect = require 'libs.inspect'
Util.debugStack = {}


function Util:setDebug(debug)
    Util.debug = debug
end

function Util:isDebug()
    return Util.debug
end

function Util:stackDebug(items)
    if type(items) ~= 'table' then
        table.insert(Util.debugStack, items)
    else
        for _, line in pairs(items) do
            table.insert(Util.debugStack, line)
        end
    end
end

function Util:update(dt)
    Util.debugStack = {
        love.timer.getFPS() .. ' FPS'
    }
end

function Util:draw()
    if Util.debug then
        for i, line in pairs(Util.debugStack) do
            love.graphics.print(line, 10, (i - 1) * 20 + 10)
        end
    end
end

return Util
