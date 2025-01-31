local radios = {} ---@type { [string]: PVoice.ClientRadio }

---Get a radio by ID
---@param id string Radio ID
---@return PVoice.ClientRadio
function GetRadioById(id)
    return radios[id]
end

RegisterNetEvent(Events.radio.update, function(id, mode, txFreq, rxFreq)
    local radio = radios[id]
    if radio then
        radio:setFreq(txFreq, rxFreq, mode)
        return
    end

    radio = ClientRadio.new(id, mode, txFreq, rxFreq)
    radios[id] = radio
end)

RegisterNetEvent(Events.radio.remove, function(id)
    if not radios[id] then
        return
    end
end)

RegisterNetEvent(Events.radio.setRxActive, function(radioId, active)
    if not radios[radioId] then
        return
    end
    radios[radioId].rxActive = active
end)

---Set the state of a radio
---@param radioId string Radio ID
---@param tx boolean Transmitting
---@param rx boolean Receiving
function SetRadioState(radioId, tx, rx)
    local radio = GetRadioById(radioId)
    if not radio then
        error('Could not set radio state: No radio with id "' .. radioId .. '"')
    end
    TriggerServerEvent(Events.radio.set_state, radioId, tx, rx)
    if tx then
        StartTalking(radioId)
    else
        StopTalking(radioId)
    end
end
exports('setRadioState', SetRadioState)

---Get the transmit state of the radio
---@param radioId string Radio ID
---@return boolean transmitting
function GetRadioTxState(radioId)
    local radio = GetRadioById(radioId)
    if not radio then
        error('Could not get radio transmit state: No radio with id "' .. radioId .. '"')
    end
    return radio:getTx()
end
exports('getRadioTxState', GetRadioTxState)

---Get the receive state of the radio (ie. if the radio can receive right now)
---@param radioId string Radio ID
---@return boolean receiving
function GetRadioRxState(radioId)
    local radio = GetRadioById(radioId)
    if not radio then
        error('Could not get radio receive state: No radio with id "' .. radioId .. '"')
    end
    return radio:getRx()
end
exports('getRadioRxState', GetRadioRxState)

---Get the receive activity state (ie. if it is receiving anything right now)
---@param radioId string Radio ID.
---@return boolean active
function GetRadioRxActive(radioId)
    local radio = GetRadioById(radioId)
    if not radio then
        error('Could not get radio receive active state: No radio with id "' .. radioId .. '"')
    end
    return radio:getRxActive()
end
exports('getRadioRxActive', GetRadioRxActive)