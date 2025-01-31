---@class PVoice.Tower
---@field id string
---@field pos Vector3
---@field targetPairs { [string]: { [string]: PVoice.Tower.TargetPair } }
Tower = {}

---Create a new radio tower
---@param id string Tower ID. Must be unique between resources
---@param pos Vector3 Location of the tower
---@return PVoice.Tower tower
function Tower.new(id, pos)
    return setmetatable({}, {__index = Tower}):__init__(id, pos)
end

---@package
function Tower:__init__(id, pos)
    self.id = id
    self.pos = pos
    self.targetPairs = {}
    return self
end

---Add a target pair to the tower
---@param rx string Receive target on the tower (source)
---@param tx string Re-transmit target from the tower (destination)
---@param power number Re-transmit power
function Tower:addTargetPair(rx, tx, power)
    local pair = { ---@type PVoice.Tower.TargetPair
        rx = rx,
        tx = tx,
        power = power
    }
    self.targetPairs[tx] = self.targetPairs[tx] or {}
    self.targetPairs[tx][rx] = pair
end

---Remove a target pair from the tower
---@param rx string Receive target on the tower (source)
---@param tx string Re-transmit target from the tower (destination)
function Tower:removeTargetPair(rx, tx)
    if not self.targetPairs[tx] then
        return
    end
    self.targetPairs[tx][rx] = nil
end

---Get a list of all targets that are re-broadcast on the specified target
---@param rxTarget string Destination target
---@return { [string]: number } targets Source targets, with their respective power modifiers
function Tower:getRebroadcast(rxTarget)
    if not self.targetPairs[rxTarget] then
        return {}
    end
    local list = {}
    for rx,pair in pairs(self.targetPairs[rxTarget]) do
        list[rx] = pair.power
    end
    return list
end

---@class PVoice.Tower.TargetPair
---@field rx string
---@field tx string
---@field power number