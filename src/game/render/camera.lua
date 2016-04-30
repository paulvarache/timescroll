
local g = love.graphics

local camera = {}

camera.x = 0
camera.y = 0
camera.scaleX = 1
camera.scaleY = 1
camera.rotation = 0
camera.intensity = 0

function camera:set()
    local shaking = math.random() > 0.5 and self.intensity or -self.intensity
    g.push()
    g.rotate(-self.rotation)
    g.scale(1 / self.scaleX, 1/ self.scaleY)
    g.translate(-self.x + shaking, -self.y)
end

function camera:unset()
    g.pop()
end

function camera:move(x, y)
    self.x = self.x + (x or 0)
    self.y = self.y + (y or 0)
end

function camera:scale(sx, sy)
    sx = sx or 1
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * (sy or sx)
end

function camera:rotate(dir)
    self.rotation = self.rotation + dir
end

function camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function camera:shake(intensity)
    self.intensity = intensity
end

function camera:focus(player, map)
    local px, py = player:getPosition()
    local rect = map:getBounds()
    local ww, wh = g.getDimensions()

    -- Center on player
    local tx = px - ww / 2
    local ty = py - wh / 2
    -- prevent out of bounds
    tx = math.min(math.max(tx, rect.x), rect.width - ww)
    ty = math.min(math.max(ty, rect.y), rect.height - wh)

    self:setPosition(tx, ty)

end

return camera
