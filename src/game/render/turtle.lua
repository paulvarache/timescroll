local Turtle = {}
Turtle.__index = Turtle

function Turtle.create()
    local self = setmetatable({}, Turtle)
    self.states = {}
    self.pos = { x = 0, y = 0 }
    self.angle = 0
    return self
end

function Turtle:turn(angle)
    self.angle = self.angle + (angle or 0)
end

function Turtle:moveTo(x, y)
    self.pos.x = x or 0
    self.pos.y = y or 0
end

function Turtle:move(d)
    local rad = self.angle * (math.pi / 180)
    local x = self.pos.x + d * math.cos(rad)
    local y = self.pos.y + d * math.sin(rad)
    love.graphics.line(self.pos.x, self.pos.y, x, y)
    self.pos.x = x
    self.pos.y = y
end

function Turtle:push()
    table.insert(self.states, {
        pos = {
            x = self.pos.x,
            y = self.pos.y
        },
        angle = self.angle
    })
end

function Turtle:pop()
    local state = table.remove(self.states, #self.states)
    self.pos = state.pos
    self.angle = state.angle
end


return Turtle
