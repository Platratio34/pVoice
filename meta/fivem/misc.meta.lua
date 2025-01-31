---@meta

---Use this to export functions so they can be called from other resources.
---@param exportedName string The function name you want to export.
---@param fn function The function to execute when the export get called.
function exports(exportedName, fn) end

---**CLIENT**
---
---Returns all player indices for 'active' physical players known to the client.
---@return Player[] players
function GetActivePlayers() end

---
---@param player Player
---@return Entity ped
function GetPlayerPed(player) end

---**SERVER**
---
---Gets the current coordinates for a specified entity. This native is used server side when using OneSync.
---@param entity Entity The entity to get the coordinates from.
---@return Vector3 pos The current entity coordinates.
function GetEntityCoords(entity) end

---Marks the event safe for network use. Aka, allows you to trigger the eventName event on the client, from a server side script.
---If you do not provide a callback function use `AddEventHandler` to listen for the event after registering it.
---@param eventName string
---@param callback? function The function to run when the event is called.
function RegisterNetEvent(eventName, callback) end

---Use this to listen for events, see the events page for more info.
---@param eventName string The name of the event you want to listen to.
---@param callback function The function to run when the event is called.
function AddEventHandler(eventName, callback) end

---**SEVER**
---
---Triggers an event on the specified client(s), and passes on any additional arguments.
---@param eventName string A string representing the event name to call on the client.
---@param playerId ServerPlayer The ID of the player to call the event for. Specify `-1` for all clients.
---@param ... any Any additional data that should be passed along.
function TriggerClientEvent(eventName, playerId, ...) end

---**CLIENT**
---
---Triggers an event on the server
---@param eventName string A string representing the name of the event to trigger. This is the identifier for the event you want to invoke.
---@param ... any Any additional data that should be passed along with the event. This can be one or more variables or values that the event handler will process.
function TriggerServerEvent(eventName, ...) end

---**CLIENT**
---
---Get the server ID of a local player
---@param player Player Local player ID
---@return ServerPlayer serverId
function GetPlayerServerId(player) end