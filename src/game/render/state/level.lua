local GameState = require 'game.render.state.game_state'
local Map = require 'game.render.map'
local Player = require 'game.world.character.player'
local Camera = require 'game.render.camera'
local TimeTravelManager = require 'game.time.time_travel_manager'

local Util = require 'util'

local windowWidth, windowHeight = love.graphics.getDimensions()

local Level = {}
Level.__index = Level

setmetatable(Level, { __index = GameState })

function Level.create(id)
    local self = GameState.create()
    setmetatable(self, Level)
    self.id = id
    self.map = nil
    self.player = nil
    return self
end

function Level:load()
    local path = 'res/map/' .. self.id .. '.lua'
    self.map = Map.create()
    self.player = Player.create(self.map:getWorld())
    self.player:load()
    self.map:load(path, self.player)
    local spawn = self.map:getSpawnPoint()
    self.player:setPosition(spawn.x, spawn.y)
end

function Level:update(dt)
    TimeTravelManager:update(dt)
    Camera:shake(TimeTravelManager:getTravelSpeed() * dt)
    Camera:focus(self.player, self.map)
    self.map:update(dt)
    Util:stackDebug(self.player:getDebug())
    Util:stackDebug(TimeTravelManager:getDebug())
end

function Level:draw()
    Camera:set()
    self.map:draw(Camera.x, Camera.y, windowWidth, windowHeight)
    Camera:unset()
end

function Level:keypressed(key)
    self.player:keypressed(key)
end

function Level:keyreleased(key)
    self.player:keyreleased(key)
end

return Level
