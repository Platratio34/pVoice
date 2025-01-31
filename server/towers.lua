local towers = {} ---@type { [string]: PVoice.Tower }

---Create a new tower with ID
---@param id string Tower ID. Must be unique between resources
---@param pos Vector3 Tower position
---@return string towerId
function AddTower(id, pos)
    if towers[id] then
        return id
    end
    local tower = Tower.new(id, pos)
    towers[id] = tower
    return id
end
exports('addTower', AddTower)

---Add a target pair to a tower by tower ID
---@param towerId string Tower ID to modify
---@param rxTarget string Receive target (source target)
---@param txTarget string Re-transmit target (destination target)
---@param power number Re-transmit power
function TowerAddTargetPair(towerId, rxTarget, txTarget, power)
    if not towers[towerId] then
        error('Could not add target pair to tower: No tower with id "' .. towerId .. '"')
    end
    towers[towerId]:addTargetPair(rxTarget, txTarget, power)
end
exports('towerAddTargetPair', TowerAddTargetPair)

---Remove a target pair from a tower by tower ID
---@param towerId string Tower ID to modify
---@param rxTarget string Receive target (source target)
---@param txTarget string Re-transmit target (destination target)
function TowerRemoveTargetPair(towerId, rxTarget, txTarget)
    if not towers[towerId] then
        error('Could not remove target pair to tower: No tower with id "' .. towerId .. '"')
    end
    towers[towerId]:removeTargetPair(rxTarget, txTarget)
end
exports('towerRemoveTargetPair', TowerRemoveTargetPair)

---Set the position of a tower by ID
---@param towerId string Tower ID to modify
---@param x number New X position of the tower
---@param y number New Y position of the tower
---@param z number New Z position of the tower
function TowerSetPosition(towerId, x, y, z)
    if not towers[towerId] then
        error('Could not set position of tower: No tower with id "' .. towerId .. '"')
    end
    towers[towerId].pos = vector3(x, y, z)
end
exports('towerSetPosition', TowerSetPosition)

---Process re-transmit volumes for the given player
---@param rxPlayer PVoice.ServerPlayer
---@param positionCache { [ServerPlayer]: Vector3 }
---@return { [ServerPlayer]: number } volumes
function ProcessTowers(rxPlayer, positionCache)
    local volumes = {}
    local playerPos = positionCache[rxPlayer.id]
    
    for rxTarget, _ in pairs(rxPlayer:getListenTargets()) do -- loop over all receive targets
        local rxSensitivity = rxPlayer:getRxSensitivity(rxTarget)

        for _, tower in pairs(towers) do -- loop over all towers
            local list = tower:getRebroadcast(rxTarget)

            if not IsEmpty(list) then -- if the tower re-transmits onto this target
                local distToTower = #(tower.pos - playerPos)

                for txTarget, power in pairs(list) do -- loop over all source targets for the tower
                    for id, txPlayer in pairs(GetPlayersTalking(txTarget)) do -- loop over all players talking on this target
                        local txDistToTower = #(tower.pos - positionCache[id])
                        local txPower = txPlayer:getTxPower(txTarget)
                        
                        local towerReceivedPower = RadioPower(txDistToTower, txPower, GetRadioFreq(txTarget)) -- power received at the tower from txPlayer
                        local towerVolume = math.min(towerReceivedPower, 1) -- turn it into a volume to prevent way-over powering

                        local playerReceivedPower = RadioPower(distToTower, towerVolume * power, GetRadioFreq(rxTarget)) -- power received at rxPlayer from tower
                        local playerVolume = math.min(playerReceivedPower * rxSensitivity, 1) -- Volume at player, effected by rx sensitivity

                        if playerVolume > 0.01 then -- Ignore the volume if it is less than 1 percent
                            volumes[id] = math.max(volumes[id] or 0, playerVolume) -- Only track the loudest path to the receiving player
                        end
                    end
                end
            end
        end
    end

    return volumes
end