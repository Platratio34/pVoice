---@meta

---**CLIENT**
---
---Starts listening to the specific channel, when available
---@param channel integer A game voice channel ID
function MumbleAddVoiceChannelListen(channel) end

---**CLIENT**
---
---Adds the specified channel to the target list for the specified Mumble voice target ID.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
---@param channel integer A game voice channel ID.
function MumbleAddVoiceTargetChannel(targetId, channel) end

---Adds the specified player to the target list for the specified Mumble voice target ID.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
---@param serverId ServerPlayer The player's server id.
function MumbleAddVoiceTargetPlayerByServerId(targetId, serverId) end

---**CLIENT**
---
---Clears the target list for the specified Mumble voice target ID.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
function MumbleClearVoiceTarget(targetId) end

---**CLIENT**
---
---Clears channels from the target list for the specified Mumble voice target ID.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
function MumbleClearVoiceTargetChannels(targetId) end

---**CLIENT**
---
---Clears players from the target list for the specified Mumble voice target ID.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
function MumbleClearVoiceTargetPlayers(targetId) end

---**CLIENT**
---
---This native will return true if the user successfully connected to the voice server.
---If the user disabled the voice-chat setting it will return false.
---
---@return boolean connected If the player is connected to a mumble server.
function MumbleIsConnected() end

---**CLIENT**
---
---Stops listening to the specified channel.
---@param channel integer A game voice channel ID.
function MumbleRemoveVoiceChannelListen(channel) end

---**CLIENT**
---
---Removes the specified voice channel from the user's voice targets.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
---@param channel integer The game voice channel ID to remove from the target.
function MumbleRemoveVoiceTargetChannel(targetId, channel) end

---Removes the specified player from the user's voice targets.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive).
---@param serverId ServerPlayer The player's server id to remove from the target.
function MumbleRemoveVoiceTargetPlayerByServerId(targetId, serverId) end

---**CLIENT**
---
---Sets the voice channel in Mumble
---@param channel integer A game voice channel ID.
function MumbleSetVoiceChannel(channel) end

---**CLIENT**
---
---Sets the current Mumble voice target ID to broadcast voice to.
---@param targetId integer A Mumble voice target ID, ranging from 1..30 (inclusive). 0 disables voice targets, and 31 is server loopback.
function MumbleSetVoiceTarget(targetId) end

---**CLIENT**
---
---Set the Mumble state
---@param state boolean Voice chat state.
function MumbleSetActive(state) end

---Overrides the output volume for a particular player with the specified server id and player name on Mumble.
---This will also bypass 3D audio and distance calculations. `-1.0` to reset the override.
---@param serverId ServerPlayer The player's server id.
---@param volume number The volume, ranging from 0.0 to 1.0 (or above).
function MumbleSetVolumeOverrideByServerId(serverId, volume) end

---Sets the audio submix ID for a specified player using Mumble 'Native Audio' functionality.
---@param serverId ServerPlayer The player's server ID.
---@param submixId integer The submix ID.
function MumbleSetSubmixForServerId(serverId, submixId) end