local g = love.graphics

local SEASON_NAMES = {
    'spring',
    'summer',
    'fall',
    'winter'
}

local YEAR_FWD_KEY = "w"
local YEAR_BCK_KEY = "s"
local SEASON_FWD_KEY = "d"
local SEASON_BCK_KEY = "a"

local TimeTravelManager = {}

TimeTravelManager.year = 1
TimeTravelManager.season = 1
TimeTravelManager.velocity = 0
TimeTravelManager.deltaAcc = 0

function TimeTravelManager:keypressed(key)
    if key == YEAR_FWD_KEY then
        self:forward(true)
    elseif key == YEAR_BCK_KEY then
        self:backward(true)
    end
    if key == SEASON_FWD_KEY then
        self:forward()
    elseif key == SEASON_BCK_KEY then
        self:backward()
    end
end

function TimeTravelManager:travel(dir)
    if dir < 0 and self.year == 1 and self.season == 1 then
        self.velocity = 0
        return
    end
    self.season = self.season + dir
    if self.season == 5 then
        self.season = 1
        self.year = self.year + 1
    elseif self.season == 0 then
        self.season = 4
        self.year = math.max(1, self.year - 1)
    end
end

function TimeTravelManager:update(dt)
    self.deltaAcc = self.deltaAcc + dt
    if love.keyboard.isDown(SEASON_FWD_KEY) then
        self.velocity = math.max(1, math.min(8, self.velocity + (2 * dt)))
    elseif love.keyboard.isDown(SEASON_BCK_KEY) then
        self.velocity = math.min(-1, math.max(-8, self.velocity - (2 * dt)))
    else
        self.velocity = 0
    end
    if self.deltaAcc > (0.5 / math.abs(self.velocity)) then
        self:travel(self.velocity < 0 and -1 or 1)
        self.deltaAcc = 0
    end
end

function TimeTravelManager:getTravelSpeed()
    return math.abs(self.velocity) * 20
end

function TimeTravelManager:getSeasonName()
    return SEASON_NAMES[self.season]
end

function TimeTravelManager:getTimeIndex()
    return self.year .. '#' .. self.season
end

function TimeTravelManager:getDebug()
    return {
        'Year: ' .. self.year,
        'Season: ' .. self:getSeasonName(),
        'Time velocity: ' .. self.velocity
    }
end

return TimeTravelManager
