local towerSets = {} ---@type { [string]: PVoice.TowerSet }

function AddTowerSet(name, powered, towers)
    if(powered == nil) then
        powered = true
    end
    towers = towers or {}

    towerSets[name] = {
        name = name,
        powered = powered,
        towers = towers
    }
end

function AddTower(set, x, y, z, strength, active)
    if(towerSets[set] == nil) then
        error('No set with name `'..set..'` exists', 2)
    end
    local tower = { ---@type PVoice.Tower
        pos = vector3(x, y, z),
        strength = strength or 1.0,
        active = (active == nil) and true or active
    }
    table.insert(towerSets[set].towers, tower)
end