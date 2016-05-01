local Util = require 'util'

local Slope = {}
Slope.__index = Slope

function Slope.create(obj, world)
    local self = setmetatable({}, Slope)
    self.world = world
    local rect = {}
    for p in string.gmatch(obj.properties.slope, "([^,]+)") do
        table.insert(rect, tonumber(p))
    end
    self.start = rect[1]
    self.finish = rect[2]
    self.down = self.finish > self.start
    self.x = obj.x
    self.y = obj.y
    self.width = obj.width
    self.height = obj.height
    self.angle = math.atan2(math.abs(self.finish - self.start), self.width)
    return self
end

function Slope:getY(x)
    local platformY = math.tan(self.angle) * (x - self.x)
    local y = self.y + self.start
    if (self.down) then
         y = y + platformY
     else
         y = y - platformY
     end
    y = math.max(self.y, y)
    return y
end

function Slope:draw()
    if Util:isDebug() then
        love.graphics.line(self.x, self.y + self.start, self.x + self.width, self.y + self.finish)
    end
end

return Slope
