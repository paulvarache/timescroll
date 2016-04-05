local g = love.graphics

--constants
local TILE_S = 16

local camera = require 'game.render.camera'
local Map = require 'game.render.map'
local Player = require 'game.world.characters.player'
local TimeTravelManager = require 'game.time.time_travel_manager'
local Util = require 'util'

local map
local player
local debugStack = {}

local k = love.keyboard

local windowWidth, windowHeight = g.getDimensions()

function stackDebug(items)
    if type(items) ~= 'table' then
        table.insert(debugStack, items)
    else
        for _, line in pairs(items) do
            table.insert(debugStack, line)
        end
    end
end

function love.load(args)
    map = Map.create()
    map:load('res/map/main.lua')
    player = Player.create(map:getWorld())
    player:load()
    local spawn = map:getSpawnPoint()
    player:setPosition(spawn.x, spawn.y)
    love.keyboard.setKeyRepeat(true)
end

function love.update(dt)
    dt = math.min(1/60, dt)
    if k.isDown("p") then
        return
    end
    map:update(dt)
    player:update(dt)
    camera:focus(player, map)
end

function love.keypressed(key)
    TimeTravelManager:keypressed(key)
    player:keypressed(key)
end

function love.keyreleased(key)
    player:keyreleased(key)
    if key == "tab" then
        Util:setDebug(not Util:isDebug())
    end
end

function love.draw()
    camera:set()

    map:draw(camera.x, camera.y, windowWidth, windowHeight)
    player:draw()

    camera:unset()

    debugStack = {}

    if Util:isDebug() then
        stackDebug(TimeTravelManager:getDebug())
        stackDebug(player:getDebug())
        for i, line in pairs(debugStack) do
            g.print(line, 10, (i - 1) * 20 + 10)
        end
    end

end
