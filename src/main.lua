local Util = require 'util'

local GameStateManager = require 'game.render.state.game_state_manager'
local Level = require 'game.render.state.level'
local Splash = require 'game.render.state.splash'

function love.load(args)
    love.handlers.nextstate = function (a, b, c, d)
        if GameStateManager:getStateId() == 'splash' then
            local level = Level.create('main')
            GameStateManager:add('level', level)
            GameStateManager:show('level')
            GameStateManager:load(args)
        end
    end
    local splash = Splash.create()
    GameStateManager:add('splash', splash)
    GameStateManager:show('splash')
    GameStateManager:load(args)
    love.keyboard.setKeyRepeat(true)
    math.randomseed(os.time())
end

function love.update(dt)
    dt = math.min(1/60, dt)
    if love.keyboard.isDown("p") then
        return
    end
    Util:update(dt)
    GameStateManager:update(dt)
end

function love.keypressed(key)
    GameStateManager:keypressed(key)
end

function love.keyreleased(key)
    GameStateManager:keyreleased(key)
    if key == "tab" then
        Util:setDebug(not Util:isDebug())
    end
end

function love.draw()
    GameStateManager:draw()
    Util:draw()
end
