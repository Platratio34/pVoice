---@meta

---@class PVoice.Channel
---@field name string
---@field mChannel integer
---@field mTarget integer
---@field __init__ fun(name: string, ...)

---@class PVoice.Tower
---@field pos Vector3
---@field active boolean
---@field strength number

---@class PVoice.TowerSet
---@field name string
---@field powered boolean
---@field towers PVoice.Tower[]