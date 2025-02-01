local localServerId = GetPlayerServerId(-1)

Citizen.CreateThread(function()
    while not MumbleIsConnected() do
        Wait(500)
    end
    MumbleSetVoiceChannel(localServerId)
end)

local talkingSources = {} ---@type { [string]: boolean }
local wasTalking = false
function IsTalking()
    for _, _ in pairs(talkingSources) do
        return true
    end
    return false
end
exports('isTalking', IsTalking)

---Start talking from the specified source
---@param source? string Talking source. Defaults to `"proximity"`
function StartTalking(source)
    source = source or 'proximity'

    if talkingSources[source] then
        return
    end
    talkingSources[source] = true

    TriggerServerEvent(Events.setTalking, source, true)
    if wasTalking then
        return
    end
    MumbleSetActive(true)
    wasTalking = true
end

---Stop talking from the specified source
---@param source? string Talking source. Defaults to `"proximity"`
function StopTalking(source)
    source = source or 'proximity'

    if not talkingSources[source] then
        return
    end

    talkingSources[source] = nil
    TriggerServerEvent(Events.setTalking, source, false)
    if not IsTalking() then
        MumbleSetActive(false)
        wasTalking = false
    end
end

exports('startTalking', function()
    StartTalking('proximity')
end)

exports('stopTalking', function()
    StopTalking('proximity')
end)

function SelfMute()
    for source, _ in pairs(talkingSources) do
        TriggerServerEvent(Events.setTalking, source, false)
    end
    MumbleSetActive(false)
    talkingSources = {}
    wasTalking = false
end

local activeRxTargets = {}
RegisterNetEvent(Events.updateVolumes, function(volumes, submixes, targets)
    activeRxTargets = targets
    for i = 1, 128 do
        MumbleSetVolumeOverrideByServerId(i, volumes[i] or -1)
        if volumes[i] then
            MumbleAddVoiceChannelListen(i)
        else
            MumbleRemoveVoiceChannelListen(i)
        end
        if submixes[i] then
            MumbleSetSubmixForServerId(i, GetSubmix(submixes[i]))
        else
            MumbleSetSubmixForServerId(i, -1)
        end
    end
    
    local pos = GetEntityCoords(GetPlayerPed(-1))

    local players = GetActivePlayers()
    for _,player in pairs(players) do
        local serverId = GetPlayerServerId(player)
        MumbleAddVoiceChannelListen(serverId)
        local pPos = GetEntityCoords(GetPlayerPed(player))
        if volumes[serverId] < 1 and #(pPos - pos) < Config.revertDistance then
            MumbleSetVolumeOverrideByServerId(serverId, -1)
            MumbleSetSubmixForServerId(serverId, -1)
        end
    end
end)

---Check if a given receive target is currently receiving audio
---@param target string Receive target
---@return boolean active
function IsRxActive(target)
    return activeRxTargets[target] ~= nil
end
exports('IsRxActive', IsRxActive)