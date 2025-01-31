---@class PVoice.IDValueSet
---@field set { [string]: number }
IDValueSet = {}

---Create a new ID set
---@return PVoice.IDValueSet
function IDValueSet.new()
    local o = {}
    setmetatable(o, { __index = IDValueSet })
    return o
end

---Check if the set is empty
---@return boolean empty
function IDValueSet:empty()
    for _,_ in pairs(self.set) do
        return false
    end
    return true
end

---Set the state of an ID in the set
---@param id string ID to modify the state of
---@param state? number State to set. Defaults to `true`
function IDValueSet:setValue(id, state)
    self.set[id] = state
end

---Remove an ID from the set
---@param id string ID to remove
function IDValueSet:unset(id)
    self.set[id] = nil
end