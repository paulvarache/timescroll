local LSystem = {}
LSystem.__index = LSystem

function LSystem.create(variables, constants, axiom, rules)
    local self = setmetatable({}, LSystem)
    self.variables = variables
    self.constants = constants
    self.axiom = axiom
    self.rules = rules
    return self
end

function LSystem:getStringAt(target, prevString, iterations)
    iterations = iterations or 0
    prevString = prevString or self.axiom
    if (iterations == target) then
        return prevString
    end
    local currentString = prevString:gsub('.', function (str)
        if self.rules[str] then
            return self.rules[str]()
        end
        return str
    end)
    return self:getStringAt(target, currentString, iterations + 1)
end

function LSystem:process(s, processors)
    s:gsub('.', function (str)
        if processors[str] then
            processors[str]()
        end
    end)
end

return LSystem
