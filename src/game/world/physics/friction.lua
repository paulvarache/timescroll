local MATERIALS = require 'game.world.physics.materials'

local FRICTIONS = {}
FRICTIONS[MATERIALS.GROUND] = 4
FRICTIONS[MATERIALS.AIR] = 1

local Friction = {}

function Friction:get(material)
    return FRICTIONS[material]
end

return Friction
