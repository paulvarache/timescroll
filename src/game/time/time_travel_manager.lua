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

function TimeTravelManager:forward(year)
    if (year) then
        self.year = self.year + 1
    else
        if self.season == 4 then
            self.year = self.year + 1
            self.season = 1
        else
            self.season = self.season + 1
        end
    end
end

function TimeTravelManager:backward(year)
    if (year) then
        self.year = math.max(1, self.year - 1)
    else
        if self.season == 1 then
            self.year = math.max(1, self.year - 1)
            self.season = 4
        else
            self.season = self.season - 1
        end
    end
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
        'Season: ' .. self:getSeasonName()
    }
end

return TimeTravelManager
