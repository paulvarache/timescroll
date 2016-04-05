local g = love.grpahics

local Character = {}

Character.__index = Character

function Character.create()
    local self = setmetatable({}, Character)
    self.x = 0
    self.y = 0
    self.vx = 0
    self.vy = 100
    return self
end

function Character:draw()
    -- I want to be implemented really bad!!!
end


return Character
