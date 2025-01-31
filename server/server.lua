local players = {} ---@type { [ServerPlayer]: PVoice.ServerPlayer }

---Get or return the wrapper for the specified server player
---@param id ServerPlayer
---@return PVoice.ServerPlayer
function GetOrCreatePlayer(id)
    if (players[id]) then
        return players[id]
    end
    local p = ServerPlayer.new(id)
    players[id] = p
    return p
end

RegisterNetEvent(Events.setTalking, function(talkSource, talking)
    local player = GetOrCreatePlayer(source)
    player:setTalking(talkSource, talking)
end)

-- RegisterNetEvent(Events.setTalking, function(target, talking)
--     GetOrCreatePlayer(source):setTalking(target, talking)
-- end)

-- RegisterNetEvent(Events.setListen, function(target, listen)
--     GetOrCreatePlayer(source):setListen(target, listen)
-- end)

AddEventHandler('playerDropped', function(_, _, _)
    local id = source
    if(players[id]) then
        players[id]:drop()
        players[id] = nil
    end
end)

---Get the set of all players talking on the specified target
---@param target? string Talking target. If absent will return all players who are talking
---@return { [ServerPlayer]: PVoice.ServerPlayer } talkers
function GetPlayersTalking(target)
    local set = {}
    for id,player in pairs(players) do
        if player:isTalking(target) then
            set[id] = player
        end
    end
    return set
end

local function calcVolumes()
    local positionCache = {}
    for pId, player in pairs(players) do
        positionCache[pId] = player:getPos()
    end
    for pId, player in pairs(players) do
        -- tower radio:
        local volumes = ProcessTowers(player, positionCache)

        -- direct radio:
        local rxTargets = player:getListenTargets()
        for rxTarget, _ in pairs(rxTargets) do
            local rxSens = player:getRxSensitivity(rxTarget)
            for txId, txPlayer in pairs(GetPlayersTalking(rxTarget)) do
                local dist = #(positionCache[txId] - positionCache[pId])
                local txPower = txPlayer:getTxPower(rxTarget)
                if IsRadioTarget(rxTarget) then
                    local receivedPower = RadioPower(dist, txPower, GetRadioFreq(rxTarget))
                    local receivedVolume = math.min(receivedPower * rxSens, 1)
                    if receivedVolume > 0.01 then
                        volumes[txId] = math.max(volumes[txId] or 0, receivedVolume)
                    end
                else
                    volumes[txId] = math.max(volumes[txId] or 0, txPower * rxSens)

                end
            end
        end
        player:send(Events.updateVolumes, volumes)
    end
end

Citizen.CreateThread(function()
    while true do
        calcVolumes()
        Wait(Config.updateFrequency)
    end
end)