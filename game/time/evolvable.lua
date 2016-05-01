local Evolvable = {}

Evolvable.__index = Evolvable

function Evolvable.create(obj)
    local self = setmetatable({}, Evolvable)
    return self
end

return Evolvable
