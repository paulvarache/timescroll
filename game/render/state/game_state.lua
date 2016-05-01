local GameState = {}
GameState.__index = GameState

function GameState.create()
    return setmetatable({}, GameState)
end


function GameState:load()

end

function GameState:keypressed(key)

end

function GameState:keyreleased(key)

end

function GameState:update(dt)

end

function GameState:draw()

end

return GameState
