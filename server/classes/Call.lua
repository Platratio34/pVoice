---@class PVoice.Call
---@field id string
---@field members PVoice.ServerPlayer[]
Call = {}

---Create a new call
---@param id string Call ID. Must be unique (for duration of call) between resources
---@param ... PVoice.ServerPlayer List of players in the call
---@return PVoice.Call
function Call.new(id, ...)
    local o = {}
    setmetatable(o, { __index = Call })
    o:__init__(id, ...)
    return o
end

---@package
function Call:__init__(id, ...)
    self.id = id
    self.members = {}
    for _,player in pairs({...}) do
        self:addPlayer(player)
    end
end

---Add a player to the call
---@param player PVoice.ServerPlayer
function Call:addPlayer(player)
    if self.members[player.id] then
        return
    end
    self.members[player.id] = player
    player:setListen(self.id, true)
    player.calls[self.id] = self
end

---Remove a player from the call
---@param player PVoice.ServerPlayer
function Call:dropPlayer(player)
    if not self.members[player.id] then
        return
    end
    player:setListen(self.id, false)
    self.members[player.id] = nil
    player.calls[self.id] = nil
end

---Check if there are any players in the call right now
---@return boolean has
function Call:hasPlayers()
    return IsEmpty(self.members)
end

---Remove all players from the call
function Call:dropAllPlayers()
    for _, player in pairs(self.members) do
        self:dropPlayer(player)
    end
end