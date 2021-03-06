local Util = require 'util'

local LSystem = require 'game.render.l_system'
local Turtle = require 'game.render.turtle'
local TimeTravelManager = require 'game.time.time_travel_manager'

local Tree = {}

Tree.__index = Tree

function Tree.create()
    local self = setmetatable({}, Tree)
    self.image = love.graphics.newImage('res/images/tree.png')
    self.quads = {
        center = love.graphics.newQuad(8, 8, 8, 8, self.image:getDimensions()),
        left = love.graphics.newQuad(0, 8, 8, 8, self.image:getDimensions()),
        right = love.graphics.newQuad(16, 8, 8, 8, self.image:getDimensions())
    }
    self.pos = {}
    self.cache = {}
    self.treeString = ''
    local rules = {}
    rules['X'] = function ()
        local b = ''
        if math.random() > 0.5 then
            b = 'F[--X][FSX]++'
        else
            b = 'F[---X][FSX]++'
        end
        if math.random() > 0.5 then
            b = b .. 'X'
        else
            b = b .. '+X'
        end
        return b
    end
    rules['F'] = function ()
        if math.random() > 0.5 then
            return 'FFFF'
        end
        return 'FS'
    end
    self.treeSystem = LSystem.create({ 'X', 'F', 'S' }, { '+', '-', '[', ']' }, 'X', rules)
    self.size = 1 + (math.random() * 2)
    return self
end

function Tree:load(world, object)
    self:setPosition(object.x + object.width / 2, object.y + object.height)
    self.offset = object.properties.offset or 0
end

function Tree:setPosition(x, y)
    self.pos.x = x or self.pos.x
    self.pos.y = y or self.pos.y
end

function Tree:update(dt)

end

function Tree:getProcessors(turtle)
    local processors = {}
    local season = TimeTravelManager.season
    processors['X'] = function (step)
        if season == 1 then
            turtle:move(2)
        elseif season == 2 then
            turtle:move(3)
        elseif season == 3 then
            turtle:move(2)
        end
    end
    processors['F'] = function (step)
        turtle:move(3 * self.size)
    end
    processors['S'] = function (step)
        turtle:move(1 * self.size)
    end
    processors['-'] = function ()
        turtle:turn(-15)
    end
    processors['+'] = function ()
        turtle:turn(15)
    end
    processors['['] = function (step)
        turtle:push()
    end
    processors[']'] = function (step)
        turtle:pop()
    end
    return processors
end

function Tree:draw()
    local year = math.min(TimeTravelManager.year - self.offset, 4)
    if year < 1 then
        return nil
    end

    local turtle = Turtle.create()
    local image = self.image
    local quads = self.quads

    --[[function turtle:draw(x, y)
        love.graphics.line(self.pos.x, self.pos.y, x, y)
        local steps = math.sqrt(math.pow(x - self.pos.x, 2) + math.pow(y - self.pos.y, 2)) / 8
        local xStep = (x - self.pos.x) / steps
        local yStep = (y - self.pos.y) / steps
        love.graphics.push()
        love.graphics.translate(self.pos.x, self.pos.y)
        for i=0, steps do
            love.graphics.draw(image, quads.center, (xStep * i), (yStep * i), self.angle * (math.pi / 180), 1, 1, 4, 4)
        end
        love.graphics.pop()
    end]]--

    turtle:moveTo(self.pos.x, self.pos.y)
    turtle:turn(-90)

    if not self.cache[year] then
        self.cache[year] = self.treeSystem:getStringAt(year)
    end

    local treeString = self.cache[year]
    love.graphics.push()
    LSystem:process(treeString, self:getProcessors(turtle))
    love.graphics.pop()
    love.graphics.setColor(255, 255, 255)

    if Util.isDebug() then
        love.graphics.print('x: ' .. math.floor(self.pos.x) .. ' y: ' .. math.floor(self.pos.y), self.pos.x, self.pos.y)
    end
end


return Tree
