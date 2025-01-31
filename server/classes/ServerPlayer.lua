---@class PVoice.ServerPlayer
---@field id ServerPlayer
---@field protected _talkingTargets { [string]: PVoice.IDValueSet }
---@field protected _listenTargets { [string]: PVoice.IDValueSet }
---@field radios { [string]: PVoice.ServerRadio }
ServerPlayer = {}

---Create a new server player wrapper
---@param id ServerPlayer
---@return PVoice.ServerPlayer
function ServerPlayer.new(id)
    local o = {}
    setmetatable(o, { __index = ServerPlayer })
    o:__init__(id)
    return o
end

---Internal constructor for server player wrapper
---@param id ServerPlayer
---@package
function ServerPlayer:__init__(id)
    self.id = id
    self._listenTargets = {}
    self._talkingTargets = {}
    self.radios = {}
end

---Send an event to the player
---@param event string Event name
---@param ... any Event parameters
function ServerPlayer:send(event, ...)
    TriggerClientEvent(event, self.id, ...)
end

---Get the position of the player.
---
---Will return (0,0,0) if the payer doesn't have an associated ped right now
---@return Vector3
function ServerPlayer:getPos()
    local ped = GetPlayerPed(self.id)
    if not ped then
        return vector3(0, 0, 0)
    end
    return GetEntityCoords(ped)
end

---Get the currently active talking targets for the player
---@return { [string]: boolean }
function ServerPlayer:getTalkingTargets()
    local targets = {}
    for id, set in pairs(self._talkingTargets) do
        if not set:empty() then
            targets[id] = true
        end
    end
    return targets
end

---Get the targets the player is currently listening to
---@return { [string]: boolean }
function ServerPlayer:getListenTargets()
    local targets = {}
    for id, set in pairs(self._listenTargets) do
        if not set:empty() then
            targets[id] = true
        end
    end
    return targets
end

---Set the talking state of the player for the specified target
---@param target string
---@param talking? boolean
---@param source? string
---@param power? number
function ServerPlayer:setTalking(target, talking, source, power)
    if talking == nil then
        talking = true
    end
    source = source or ''

    if not self._talkingTargets[target] then
        self._talkingTargets[target] = IDValueSet.new()
    end
    local targetW = GetOrCreateTarget(target)
    if talking then
        self._talkingTargets[target]:setValue(source, power or 1)
        targetW:add(self)
    else
        self._talkingTargets[target]:unset(source)
        if not self:isTalking(target) then
            targetW:remove(self)
        end
    end
end

---Check if the player is currently talking.
---@param target? string Specific target to check
---@return boolean talking
function ServerPlayer:isTalking(target)
    if not target then
        for _, set in pairs(self._talkingTargets) do
            if not set:empty() then
                return true
            end
        end
        return false
    end
    if not self._talkingTargets[target] then
        return false
    end
    return not self._talkingTargets[target]:empty()
end

---Check if the player is currently listening to the specified target
---@param target string Target to check
---@return boolean listening
function ServerPlayer:isListening(target)
    if not self._listenTargets[target] then
        return false
    end
    return not self._listenTargets[target]:empty()
end

---Drop the player, exiting all targets
function ServerPlayer:drop()
    for target,_ in pairs(self._talkingTargets) do
        GetOrCreateTarget(target):remove(self)
    end
    for target,_ in pairs(self._listenTargets) do
        GetOrCreateTarget(target):endListen(self)
    end
end

---Set the listening state of the server player for the specified target
---@param target string
---@param listen? boolean
---@param source? string
---@param sensitivity? number
function ServerPlayer:setListen(target, listen, source, sensitivity)
    if listen == nil then
        listen = true
    end
    source = source or ''

    local targetW = GetOrCreateTarget(target)
    if not self._listenTargets[target] then
        self._listenTargets[target] = IDValueSet.new()
    end
    if listen then
        self._listenTargets[target]:setValue(source, sensitivity or 1)
        targetW:listen(self)
    else
        self._listenTargets[target]:unset(source)
        if self._listenTargets[target]:empty() then
            targetW:endListen(self)
        end
    end
end

---Get the transmit power for a given target
---@param target string Target to get power of
---@return number power
function ServerPlayer:getTxPower(target)
    if not self._talkingTargets[target] then
        return 0
    end
    local power = 0
    for _, pow in pairs(self._talkingTargets[target].set) do
        power = math.max(power, pow)
    end
    return power
end

---Get the receive sensitivity for a given target
---@param target string Target to get the sensitivity of
---@return number sensitivity
function ServerPlayer:getRxSensitivity(target)
    if not self._listenTargets[target] then
        return 0
    end
    local power = 0
    for _, pow in pairs(self._listenTargets[target].set) do
        power = math.max(power, pow)
    end
    return power
end