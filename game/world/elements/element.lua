local g = love.graphics

local STI = require 'libs.STI'
local Util = require 'util'

local TimeTravelManager = require 'game.time.time_travel_manager'

local Element = {}

Element.__index = Element

function Element.create()
    local self = setmetatable({}, Element)
    self.pos = {}
    self.tileset = nil
    self.states = {}
    self.currentBoxes = {}
    self.timeIndex = TimeTravelManager:getTimeIndex()
    self.offset = 0
    self.steps = {}
    self.reversed = false
    if math.random() > 0.5 then
        self.reversed = true
    end
    return self
end

function Element:load(world, object)
    self.world = world
    local properties = object.properties
    self.offset = properties.offset
    local stiObject = STI.new('res/elements/' .. properties.type .. '.lua')
    for p in string.gmatch(stiObject.properties.steps, "([^ ]+)") do
        table.insert(self.steps, tonumber(p))
    end
    local tileset = stiObject.tilesets[1]
    local image = tileset.image
    image:setFilter('nearest', 'nearest')
    local width = image:getWidth() / stiObject.properties.lifespan
    local height = image:getHeight() / 4
    local id = 0
    for _, tile in ipairs(stiObject.tiles) do
        if tile.tileset == 1 then
            local season = math.floor(tile.id / 4) + 1
            local year = (tile.id % #self.steps) + 1
            local boxes = {}
            if tile.objectGroup then
                for _, object in ipairs(tile.objectGroup.objects) do
                    if object.shape == "rectangle" then
                        local box = {
                            x = object.x,
                            y = object.y,
                            width = object.width,
                            height = object.height
                        }
                        if self.reversed then
                            box.x = tile.width - (box.x + box.width)
                        end
                        table.insert(boxes, box)
                    end
                end
            end
            if not self.states[year] then
                self.states[year] = {}
            end
            self.states[year][season] = {
                quad = tile.quad,
                boxes = boxes
            }
        end
    end
    self.tileset = image
    self.pos = {
        x = object.x,
        y = object.y
    }
end

function Element:update(dt)
    -- Check if the player traveled in time
    if self.timeIndex ~= TimeTravelManager:getTimeIndex() then
        -- Remove previous boxes
        for _, box in ipairs(self.currentBoxes) do
            self.world:remove(box)
        end
        local state = self:getCurrentState()
        if state ~= nil then
            -- Add the new ones
            self.currentBoxes = state.boxes
            for _, box in ipairs(self.currentBoxes) do
                self.world:add(box, box.x + self.pos.x, box.y + self.pos.y, box.width, box.height)
            end
        end
    end

    self.timeIndex = TimeTravelManager:getTimeIndex()
end

function Element:draw()
    local state = self:getCurrentState()
    if state ~= nil then
        local quad = state.quad
        local direction = self.reversed and -1 or 1
        -- TODO update when online
        local offset = self.reversed and 64 or 0
        g.draw(self.tileset, quad, self.pos.x, self.pos.y, 0, direction, 1, offset)
    end
end

-- Get the index of the stored state from the year
function Element:getImageX(year)
    local imageX
    for i, v in ipairs(self.steps) do
        if year == v then
            return i
        elseif year < v then
            return i - 1
        end
    end
    return #self.steps
end

function Element:getCurrentState()
    local year = TimeTravelManager.year - self.offset
    if year < 1 then
        return nil
    end
    local imageX = self:getImageX(year)
    return self.states[imageX][TimeTravelManager.season]
end


return Element
