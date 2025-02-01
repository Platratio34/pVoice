local submixes = {} ---@type { [string]: integer }

function GetSubmix(submixId)
    return submixes[submixId]
end

Citizen.CreateThread(function()
    Wait(500)

    for name,mix in pairs(Config.submixes) do
        local id = CreateAudioSubmix(name)
        if id == nil then
            error('Unable to create submix "'..name..'"')
        end
        submixes[name] = id

        if mix.radio then
            SetAudioSubmixEffectRadioFx(id, 1)
        end
        for param,value in pairs(mix.effects_int) do
            SetAudioSubmixEffectParamInt(id, 1, param, value)
        end
        for param, value in pairs(mix.effects) do
            SetAudioSubmixEffectParamFloat(id, 1, param, value)
        end
        
        AddAudioSubmixOutput(id, 1)
    end
end)

