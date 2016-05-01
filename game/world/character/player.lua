local Character = require 'game.world.character.character'

local Util = require 'util'
local g = love.graphics
local k = love.keyboard

local jumpKey = "space"
local MATERIALS = require 'game.world.physics.materials'

local Friction = require 'game.world.physics.friction'

local Player = {}
Player.__index = Player

setmetatable(Player, { __index = Character })

function Player.create(world)
    local self = Character.create()
    setmetatable(self, Player)
    self.world = world
    self.impulse = 600
    self.accel = 500
    self.brake = 800
    self.fallAccel = 900
    self.direction = 1
    self.typeTouching = MATERIALS.AIR
    return self
end

function Player:load()
    self.image = g.newImage('res/images/characters/player.png')
    self.image:setFilter('nearest', 'nearest')
    self.quad = love.graphics.newQuad(0, 0, 50, 50, self.image:getDimensions())
    self.width = 50
    self.height = 50
    self.shapes = {
        body = {},
        slope = {}
    }
    self.world:add(self.shapes.body, self.x, self.y, self.width - 10, self.height - 5)
end

function Player:applyBrake(dt)
    -- air friction. 1 means do not affect brake speed
    -- Touching the ground, the friction is higher => almost immediate stop
    local friction = Friction:get(self.typeTouching)
    if self.vx < 0 then
        self.vx = math.min(0, self.vx + (self.brake * dt * friction))
    else
        self.vx = math.max(0, self.vx - (self.brake * dt * friction))
    end
end

function Player:update(dt)
    local x, y = self:getPosition()
    -- player controls
    if k.isDown("right") then
        self.vx = math.min(400, self.vx + (self.accel * dt))
        self.direction = 1
    elseif k.isDown("left") then
        self.vx = math.max(-400, self.vx - (self.accel * dt))
        self.direction = -1
    else
        -- brake
        self:applyBrake(dt)
    end

    -- player going against the velocity, trigger brake
    if self.vx < 0 and self.direction == 1 or self.vx > 0 and self.direction == -1 then
        self:applyBrake(dt)
    end

    -- Gravity
    self.vy = self.vy + self.fallAccel * dt
    x = x + self.vx * dt
    y = y + self.vy * dt
    local ax, ay, cols, len = self:setPosition(x, y)
    self.canJump = false
    self.typeTouching = MATERIALS.AIR
    self.rotate = 0
    for _, col in ipairs(cols) do
        if col.type == 'slope' then
            if col.slope.touches then
                self.rotate = col.slope.angle
                if not col.slope.down then
                    self.rotate = math.pi * 2 - self.rotate
                end
                self.typeTouching = col.other.properties and col.other.properties.material or MATERIALS.GROUND
                self.canJump = true
            end
        else
            if col.normal.y == -1 then
                self.typeTouching = col.other.properties and col.other.properties.material or MATERIALS.GROUND
                self.canJump = true
                break
            elseif col.normal.y == 1 then
                self.vy = 0
            end
        end
    end
    if self.canJump then
        self.vy = 0
    end
end

function Player:keypressed(key)
    -- Initial impulse from jump
    if key == jumpKey and self.canJump then
        self.vy = -self.impulse
    end
end

function Player:keyreleased(key)
    -- Still ascending from the jump, reduce velocity for a small jump
    if key == jumpKey and self.vy < -250 then
        self.vy = -(self.impulse / 2)
    end
end

function Player:draw()
    local x, y = self:getPosition()
    local offset = 50
    if (self.direction == 1) then
        offset = 0
    end
    g.draw(self.image, self.quad, x - 5, y - 5, 0, self.direction, 1, offset, 0)
end

function Player:getDebug()
    local x, y = self:getPosition()
    return {
        "Player:",
        "x " .. math.floor(x) .. " y ".. math.floor(y),
        "vx " .. math.floor(self.vx) .. " vy " .. math.floor(self.vy)
    }
end

function Player:setPosition(x, y)
    return self.world:move(self.shapes.body, x, y, self:getFilter())
end

function Player:getPosition()
    return self.world:getRect(self.shapes.body)
end

local playerFilter = function(item, other)
    if other.properties and other.properties.slope then
        return 'slope'
    end
    if other.layer and not other.layer.visible then
        return nil
    else
        return 'slide'
    end
end

function Player:getFilter()
    return playerFilter;
end

return Player
