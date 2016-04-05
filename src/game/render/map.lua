local STI = require 'libs.STI'
local bump = require 'libs.bump.bump'
local ElementManager = require 'game.world.elements.element_manager'
local Util = require 'util'

local g = love.graphics

local TILE_S = 32

local Map = {}
Map.__index = Map

function Map.create(path)
    local self = setmetatable({}, Map)
    self.world = bump.newWorld(32)
    self.elements = {}
    return self
end

function Map:load(path)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
    for k, layer in ipairs(self.map.layers) do
        if layer.type == 'objectgroup' then
            for _, object in ipairs(layer.objects) do
                -- Extract spawn point
                if object.type == 'spawn' then
                    self.spawnPoint = { x=(object.x), y=(object.y)}
                -- Extract time elements
                elseif object.type == 'time_element' then
                    local element = ElementManager.create()
                    element:load(self.world, object)
                    table.insert(self.elements, element)
                end
            end
            -- Remove all the objects from the layer
            layer.objects = {}
        end
    end
    g.setBackgroundColor(self.map.backgroundcolor)
end

function Map:getSpawnPoint()
    return self.spawnPoint
end

function Map:getBounds()
    local firstLayer = self.map
    return {
        x = 0,
        y = 0,
        width = self.map.width * self.map.tilewidth,
        height = self.map.height * self.map.tileheight
    }
end

function Map:draw(x, y, width, height)

    -- Draw Range culls unnecessary tiles
    self.map:setDrawRange(x, y, width, height)

    -- Draw the map and all objects within
    self.map:draw()

    for _, element in pairs(self.elements) do
        element:draw()
    end

    if Util:isDebug() then
        -- Draw Collision Map (useful for debugging)
        self.map:bump_draw(self.world)
    end

end

function Map:update(dt)
    self.map:update(dt)
    for _, element in pairs(self.elements) do
        element:update(dt)
    end
end

function Map:getWorld()
    return self.world
end

return Map
