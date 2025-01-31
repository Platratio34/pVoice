---@class PVoice.Target
---@field id string
---@field talkers { [ServerPlayer]: PVoice.ServerPlayer }
---@field listeners { [ServerPlayer]: PVoice.ServerPlayer }
Target = {}

function Target.new(id)
    local o = {
        id = id
    }
    setmetatable(o, { __index = Target })
    return o
end

function Target:add(player)
    self.talkers[player.id] = player
end

function Target:remove(player)
    self.talkers[player.id] = nil
end

function Target:listen(player)
    self.listeners[player.id] = player
end

function Target:endListen(player)
    self.listeners[player.id] = nil;
end

function Target:notify(...)
    for _,player in pairs(self.listeners) do
        player:send('pvoice:update_target', self.id, ...)
    end
end