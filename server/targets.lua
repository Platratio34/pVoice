local targets = {} ---@type { [string]: PVoice.Target }

function GetOrCreateTarget(id)
    if targets[id] then
        return targets[id]
    end
    local target = Target.new(id)
    targets[id] = target
    return target
end