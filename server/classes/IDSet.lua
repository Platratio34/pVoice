---@class PVoice.IDSet
---@field set { [string]: boolean }
IDSet = {}

---Create a new ID set
---@return PVoice.IDSet
function IDSet.new()
    local o = {}
    setmetatable(o, { __index = IDSet })
    return o
end

---Check if the set is empty
---@return boolean empty
function IDSet:empty()
    for _,_ in pairs(self.set) do
        return false
    end
    return true
end

---Set the state of an ID in the set
---@param id string ID to modify the state of
---@param state? boolean State to set. Defaults to `true`
function IDSet:add(id, state)
    if state == nil then
        state = true
    end
    self.set[id] = true
end

---Remove an ID from the set
---@param id string ID to remove
function IDSet:remove(id)
    self.set[id] = nil
end