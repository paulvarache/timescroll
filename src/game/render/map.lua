local STI = require 'libs.STI'
local bump = require 'libs.bump.bump'
local ElementManager = require 'game.world.elements.element_manager'
local TimeTravelManager = require 'game.time.time_travel_manager'
local Util = require 'util'

local g = love.graphics

local TILE_S = 32

local Map = {}
Map.__index = Map

function Map.create(path)
    local self = setmetatable({}, Map)
    self.world = bump.newWorld(32)
    self.elements = {}
    self.evolvable = {}
    self.playerLayerIndex = nil
    return self
end

function Map:load(path, player)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
    local playerLayerIndex = #self.map.layers
    for i, layer in ipairs(self.map.layers) do
        -- Get the player's layer index
        if layer.type == 'objectgroup' and layer.name == 'PlayerLayer' then
            playerLayerIndex = i
        elseif layer.type == 'objectgroup' then
            for _, object in ipairs(layer.objects) do
                -- Extract spawn point
                if object.type == 'spawn' then
                    self.spawnPoint = { x=(object.x), y=(object.y)}
                -- Extract time elements
                elseif object.type == 'time_element' then
                    local element = ElementManager.create(object)
                    element:load(self.world, object)
                    table.insert(self.elements, element)
                end
            end
            -- Remove all the objects from the layer
            layer.objects = {}
        end
    end
    for k, layer in ipairs(self.map.layers) do
        local props = layer.properties
        if props.evolvable then
            if not self.evolvable[props.group] then
                self.evolvable[props.group] = {}
            end
            self.evolvable[props.group][props.season] = layer
        end
    end
    self:addPlayerToLayer(player, playerLayerIndex)
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
        love.graphics.setLineWidth(1)
        -- Draw Collision Map (useful for debugging)
        self.map:bump_draw(self.world)
    end

end

function Map:update(dt)
    self.map:update(dt)
    for _, element in pairs(self.elements) do
        element:update(dt)
    end
    for _, group in pairs(self.evolvable) do
        local layerVisible = false
        for season, layer in pairs(group) do
            if season == TimeTravelManager:getSeasonName() then
                layer.visible = true
                layerVisible = true
            else
                layer.visible = false
            end
        end
        if not layerVisible then
            group.default.visible = true
        end
    end
end

function Map:getWorld()
    return self.world
end

function Map:addPlayerToLayer(player, layerIndex)
    -- creating a custom layer for the player and placing it into the maps layers
    -- just above the objects layer
    local playerLayer = self.map:convertToCustomLayer(layerIndex)

    -- adding data to the custom layer
    playerLayer.player = player

    -- update callback for custom layer
    function playerLayer:update(dt)
        self.player:update(dt)
    end

    -- draw callback for custom layer
    function playerLayer:draw()
        self.player:draw()
    end
end

return Map
