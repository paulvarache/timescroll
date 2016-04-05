local g = love.graphics

local TimeTravelManager = require 'game.time.time_travel_manager'

-- https://github.com/stevedonovan/Penlight/blob/master/lua/pl/path.lua#L286
local function formatPath(path)
	local np_gen1,np_gen2  = '[^SEP]+SEP%.%.SEP?','SEP+%.?SEP'
	local np_pat1, np_pat2 = np_gen1:gsub('SEP','/'), np_gen2:gsub('SEP','/')
	local k

	repeat -- /./ -> /
		path,k = path:gsub(np_pat2,'/')
	until k == 0

	repeat -- A/../ -> (empty)
		path,k = path:gsub(np_pat1,'')
	until k == 0

	if path == '' then path = '.' end

	return path
end

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
    return self
end

function Element:load(world, object)
    self.world = world
    local properties = object.properties
    self.offset = properties.offset
    local f = dofile('../res/elements/' .. properties.type .. '.lua')
    local tileset = f.tilesets[1]
    local image = g.newImage(formatPath('res/elements/' .. tileset.image))
    image:setFilter('nearest', 'nearest')
    local width = image:getWidth() / f.properties.lifespan
    local height = image:getHeight() / 4
    local id = 0
    for season = 1, 4 do
        for i = 1, f.properties.lifespan do
            local moment = {}
            moment.quad = g.newQuad(width * (i - 1), height * (season - 1), width, height, image:getWidth(), image:getHeight())
            local boxes = {}
            for k, tile in ipairs(tileset.tiles) do
                if tile.id == id then
                    for _, object in ipairs(tile.objectGroup.objects) do
                        if object.shape == "rectangle" then
                            table.insert(boxes, {
                                x = object.x,
                                y = object.y,
                                width = object.width,
                                height = object.height
                            })
                        end
                    end
                end
            end
            moment.boxes = boxes
            self.states[i] = self.states[i] or {}
            self.states[i][season] = moment
            id = id + 1
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
        g.draw(self.tileset, quad, self.pos.x, self.pos.y)
    end
end

function Element:getCurrentState()
    local year = TimeTravelManager.year - self.offset
    if year < 1 then
        return nil
    end
    return self.states[math.min(year, #self.states)][TimeTravelManager.season]
end


return Element
