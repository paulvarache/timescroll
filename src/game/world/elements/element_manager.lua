local Element = require 'game.world.elements.element'
local Tree = require 'game.world.elements.tree'

local Util = require 'util'

local ElementManager = {}

function ElementManager.create(object)
    if object.properties.type == 'tree_l' then
        return Tree.create()
    else
        return Element.create()
    end
end

return ElementManager
