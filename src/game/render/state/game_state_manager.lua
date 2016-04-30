local GameStateManager = {}

GameStateManager.states = {}
GameStateManager.currentStateId = nil

function GameStateManager:add(id, state)
    GameStateManager.states[id] = state
end

function GameStateManager:remove(id)
    GameStateManager.states[id] = nil
end

function GameStateManager:show(id)
    GameStateManager.currentStateId = id
end

function GameStateManager:getStateId()
    return self.currentStateId
end

function GameStateManager:getState()
    return GameStateManager.states[GameStateManager.currentStateId]
end

function GameStateManager:canRender()
    return GameStateManager.currentStateId and GameStateManager.states[GameStateManager.currentStateId]
end

function GameStateManager:load()
    if not GameStateManager:canRender() then return end
    GameStateManager:getState():load()
end

function GameStateManager:keypressed(key)
    if not GameStateManager:canRender() then return end
    GameStateManager:getState():keypressed(key)
end

function GameStateManager:keyreleased(key)
    if not GameStateManager:canRender() then return end
    GameStateManager:getState():keyreleased(key)
end

function GameStateManager:update(dt)
    if not GameStateManager:canRender() then return end
    GameStateManager:getState():update(dt)
end

function GameStateManager:draw()
    if not GameStateManager:canRender() then return end
    GameStateManager:getState():draw()
end

return GameStateManager
