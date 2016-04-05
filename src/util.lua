
local Util = {}

Util.debug = false

function Util:setDebug(debug)
    Util.debug = debug
end

function Util:isDebug()
    return Util.debug
end

return Util
