local channels = {} ---@type { [string]: PVoice.Channel }

local function getChannel(name)
    return channels[name]
end

local function createChannel(name, type)
    
end

---@class PVoice.ProximityChannel : PVoice.Channel
local ProximityChannel = {}

---@class PVoice.IntercomChannel : PVoice.Channel
local IntercomChannel = {}

---@class PVoice.RadioChannel : PVoice.Channel
---@field mode string
---@field freq number
local RadioChannel = {}

---@class PVoice.DuplexRadioChannel : PVoice.RadioChannel
---@field rFreq number
---@field towerSet string
local DuplexRadioChannel = {}

function AddChannel(name)

end