---Add a radio to player by serverID
---
---**ERRORS** If the player already has a radio with the requested ID
---@param playerId ServerPlayer Player to add the radio to
---@param radioId string Radio ID. Must be unique across resources
---@param mode string Radio mode. Often one of `am`, `fm`, or `dmr`
---@param txFreq number|nil Transmit frequency. Leave `nil` to disable transmit
---@param rxFreq number|nil Receive frequency. Leave `nil` to disable receive
---@return string radioId
function AddRadioToPlayer(playerId, radioId, mode, txFreq, rxFreq)
    local player = GetOrCreatePlayer(playerId)
    if player.radios[radioId] then
        error("Unable to add radio to player " .. playerId .. ': Player already had radio with ID "' .. radioId .. '"', 2)
    end

    local radio = ServerRadio.new(radioId, player, mode, txFreq, rxFreq)
    player.radios[radioId] = radio
    return radioId
end
exports('addRadioToPlayer', AddRadioToPlayer)

---Set the frequency and mode of a radio for player
---@param playerId ServerPlayer Server ID of player to edit radio for
---@param radioId string Radio ID to set the frequency of
---@param mode string Radio mode. Often one of `am`, `fm`, or `dmr`
---@param txFreq number|nil Transmit frequency of the radio. Set to `nil` to disable transmit
---@param rxFreq number|nil Receive frequency of the radio. Set to `nil` to disable receive
function SetRadioFrequency(playerId, radioId, mode, txFreq, rxFreq)
    local player = GetOrCreatePlayer(playerId)
    if not player.radios[radioId] then
        error("Unable to update radio for player " .. playerId .. ': Player has no radio with ID "' .. radioId .. '"', 2)
    end

    player.radios[radioId]:setFreq(mode, txFreq, rxFreq)
end
exports('setRadioFrequency', SetRadioFrequency)

---Set the power of a radio for player
---@param playerId ServerPlayer Server ID of player to edit radio for
---@param radioId string Radio ID to set the power of
---@param power number Transmit power of the radio. Should probably be between 
---@param sensitivity number Receive sensitivity of the radio
function SetRadioPower(playerId, radioId, power, sensitivity)
    local player = GetOrCreatePlayer(playerId)
    if not player.radios[radioId] then
        error("Unable to update radio for player " .. playerId .. ': Player has no radio with ID "' .. radioId .. '"', 2)
    end

    local radio = player.radios[radioId]
    radio.txPower = power
    radio.rxSensitivity = sensitivity
end
exports('setRadioPower', SetRadioPower)

---Get the receive target for a given radio on player
---@param playerId ServerPlayer Server ID of player to radio to get
---@param radioId string Radio ID to get receive target for
---@return string? rxTarget Receive target ID. May be `nil` if receive is disabled on the radio
function GetRadioRxTarget(playerId, radioId)
    local player = GetOrCreatePlayer(playerId)
    if not player.radios[radioId] then
        error(
        "Unable to get receive target for radio on player " ..
        playerId .. ': Player has no radio with ID "' .. radioId .. '"', 2)
    end
    return player.radios[radioId]:getRxTarget()
end

function RemovePlayerRadio(playerId, radioId)
    local player = GetOrCreatePlayer(playerId)
    if not player.radios[radioId] then
        return
    end
    player.radios[radioId]:dispose()
end

---Get a player's radio by ID
---@param playerId ServerPlayer Player to get radio for
---@param radioId string ID of the radio to get
---@return PVoice.ServerRadio? radio
function GetPlayerRadio(playerId, radioId)
    local player = GetOrCreatePlayer(playerId)
    return player.radios[radioId]
end

local FOUR_PI = 4 * 3.141592653
---Get the power of a radio
---@param distance number Distance from transmitter to receiver
---@param power number Transmitter power
---@param frequency number Radio frequency in kHz
---@return number rxPower Received power
function RadioPower(distance, power, frequency)
    local loss = ((1000 * frequency) / (FOUR_PI * distance)) ^ 2
    return power * loss
end

local radioTargets = {} ---@type { [string]: number }
---Mark a target as a radio target
---@param target string Target ID
---@param frequency number Frequency of the target in kHz
function AddRadioTarget(target, frequency)
    radioTargets[target] = frequency
end

---Get the frequency of a radio target
---@param target string Radio target id
---@return number frequency
function GetRadioFreq(target)
    return radioTargets[target] or 100
end

---Check if a given target is a radio target
---@param target string Target to check
---@return boolean isRadio
function IsRadioTarget(target)
    return radioTargets[target] ~= nil
end

RegisterNetEvent(Events.radio.set_state, function(radioId, tx, rx)
    local player = GetOrCreatePlayer(source)
    if not player.radios[radioId] then
        return
    end
    player.radios[radioId]:setTalk(tx)
    player.radios[radioId]:setListen(rx)
end)