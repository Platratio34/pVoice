local calls = {} ---@type { [string]: PVoice.Call }

local nextId = 0
local function genId()
    local id = 'call:' .. nextId
    nextId = nextId + 1
    while calls[id] do
        id = 'call:' .. nextId
        nextId = nextId + 1
    end
    return id
end

---Create a new call
---@param ... ServerPlayer Players in the call by server ID
---@return string callId The Id of the call, for future reference
function NewCall(...)
    local cId = genId()
    local call = Call.new(cId)
    calls[cId] = call
    for _,pId in pairs({...}) do
        call:addPlayer(GetOrCreatePlayer(pId))
    end
    return cId
end
exports('newCall', NewCall)

---Add a player to call by ID
---@param callId string Call ID
---@param serverId ServerPlayer Player to add by server ID
function AddPlayerToCall(callId, serverId)
    if not calls[callId] then
        error('Unable to add player to call: No call with ID "' .. callId .. '"', 2)
    end
    local player = GetOrCreatePlayer(serverId)
    calls[callId]:addPlayer(player)
end
exports('addPlayerToCall', AddPlayerToCall)

---Remove a player from a call by ID
---@param callId string Call ID
---@param serverId ServerPlayer Player to remove by server ID
function DropPlayerFromCall(callId, serverId)
    if not calls[callId] then
        error('Unable to drop player from call: No call with ID "' .. callId .. '"', 2)
    end
    local player = GetOrCreatePlayer(serverId)
    calls[callId]:dropPlayer(player)
    if not calls[callId]:hasPlayers() then
        RemoveCall(callId)
    end
end
exports('dropPlayerFromCall', DropPlayerFromCall)

---Remove a call, dropping all players from it and allowing re-use of the ID.
---
---**Call ID will be invalid after making this call**
---@param callId string Call ID
function RemoveCall(callId)
    if not calls[callId] then
        return
    end
    calls[callId]:dropAllPlayers()
    calls[callId] = nil
end
exports('removeCall', RemoveCall)

---Check if a target is a call target
---@param target string Talking target
---@return boolean isCall
function IsCall(target)
    return calls[target] ~= nil
end

---Calculate the volume of a call by ID
---@param callId string Call ID
---@param txPlayer PVoice.ServerPlayer
---@param rxPlayer PVoice.ServerPlayer
---@param positionCache { [ServerPlayer]: Vector3 } Cache of player positions
---@return boolean connected
---@return string? submix
function CalcCallVolume(callId, txPlayer, rxPlayer, positionCache)
    if not calls[callId] then
        error('Unknown call ID: "' .. callId .. '"', 2)
    end

    local distToTower = DistToCellTower(positionCache[txPlayer.id])
    local distFromTower = DistToCellTower(positionCache[rxPlayer.id])

    if distToTower > Config.calls.towerOuterDistance or distFromTower > Config.calls.towerOuterDistance then
        return false
    end
    if distToTower > Config.calls.towerInnerDistance or distFromTower > Config.calls.towerInnerDistance then
        return true, Config.calls.submixId
    end 
    return true
end