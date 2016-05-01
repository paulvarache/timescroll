local STI = require 'libs.STI'
local bump = require 'libs.bump.bump'
local Slope = require 'game.render.slope'
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
    self.evolvable = {}
    self.slopes = {}
    self.playerLayerIndex = nil
    return self
end

local slope = function (world, col, x,y,w,h, goalX, goalY, filter)

    col.slope = {
        touches = false
    }

    local itemCenterX = col.itemRect.x + (col.itemRect.w / 2)
    if itemCenterX - col.other.x > 0 then
        local slopeY = col.other.slope:getY(itemCenterX) - col.itemRect.h
        col.slope.angle = col.other.slope.angle
        col.slope.down = col.other.slope.down
        if slopeY < goalY + 1 then
            goalY = slopeY
            col.slope.touches = true
        end
    end

    local cols, len = world:project(col.item, x,y,w,h, goalX, goalY, filter)
    --[[for _, c in ipairs(cols) do
        if c.normal.x == -1 and col.slope.touches and c.type == 'slide' then
            print(Util.inspect(c))
        end
    end]]--
    return goalX, goalY, cols, len
end

function Map:load(path, player)
    self.map = STI.new(path, { "bump" })
    self.map:bump_init(self.world)
    self.world:addResponse('slope', slope)
    local playerLayerIndex = #self.map.layers
    local elements = {}
    for _, collidable in ipairs(self.map.bump_collidables) do
        if collidable.properties and collidable.properties.slope then
            local slope = Slope.create(collidable, world)
            collidable.slope = slope
        end
    end
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
                    if not elements[i] then
                        elements[i] = {}
                    end
                    local element = ElementManager.create(object)
                    element:load(self.world, object)
                    table.insert(elements[i], element)
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
    for i, layerElements in pairs(elements) do
        self:addElementsToLayer(layerElements, i)
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

    if Util:isDebug() then
        love.graphics.setLineWidth(1)
        -- Draw Collision Map (useful for debugging)
        self.map:bump_draw(self.world)
    end
    for _, slope in ipairs(self.slopes) do
        slope:draw()
    end

end

function Map:update(dt)
    self.map:update(dt)
    for _, slope in ipairs(self.slopes) do
        slope:update(dt)
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

function Map:addElementsToLayer(elements, layerIndex)
    -- creating a custom layer for the player and placing it into the maps layers
    -- just above the objects layer
    local elementsLayer = self.map:convertToCustomLayer(layerIndex)

    -- adding data to the custom layer
    elementsLayer.elements = elements

    -- update callback for custom layer
    function elementsLayer:update(dt)
        for _, element in pairs(self.elements) do
            element:update(dt)
        end
    end

    -- draw callback for custom layer
    function elementsLayer:draw()
        for _, element in pairs(self.elements) do
            element:draw()
        end
    end
end

return Map
