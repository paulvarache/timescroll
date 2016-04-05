local Element = require 'game.world.elements.element'

local ElementManager = {}

function ElementManager:create(world, object)
    return Element.create(world, object)
end

return ElementManager
