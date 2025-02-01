---@meta

---Adds an output for the specified audio submix.
---@param submixId integer The input submix.
---@param outputSubmixId integer The output submix. Use 0 for the master game submix.
function AddAudioSubmixOutput(submixId, outputSubmixId) end

---**CLIENT**
---
---Creates an audio submix with the specified name, or gets the existing audio submix by that name
---@param name string The audio submix name.
---@return integer submixId A submix ID, or `-1` if the submix could not be created.
function CreateAudioSubmix(name) end

---**CLIENT**
---
---Sets a floating-point parameter for a submix effect.
---@param submixId integer The submix.
---@param effectSlot integer The effect slot for the submix. It is expected that the effect is set in this slot beforehand.
---@param paramIndex Hash The parameter index for the effect.
---@param paramValue number The parameter value to set.
function SetAudioSubmixEffectParamFloat(submixId, effectSlot, paramIndex, paramValue) end

---**CLIENT**
---
---Sets a integer  parameter for a submix effect.
---@param submixId integer The submix.
---@param effectSlot integer The effect slot for the submix. It is expected that the effect is set in this slot beforehand.
---@param paramIndex Hash The parameter index for the effect.
---@param paramValue integer The parameter value to set.
function SetAudioSubmixEffectParamInt(submixId, effectSlot, paramIndex, paramValue) end

---**CLIENT**
---
---Assigns a RadioFX effect to a submix effect slot.
---@param submixId integer The submix.
---@param effectSlot integer The effect slot for the submix.
function SetAudioSubmixEffectRadioFx(submixId, effectSlot) end

---**CLIENT**
---
---Sets the volumes for the sound channels in a submix effect. Values can be between 0.0 and 1.0.
---Channel 5 and channel 6 are not used in voice chat but are believed to be center and LFE channels.
---Output slot starts at 0 for the first ADD_AUDIO_SUBMIX_OUTPUT call then incremented by 1 on each subsequent call.
---
---@param submixId integer The submix.
---@param outputSlot integer The output slot index.
---@param frontLeft number The volume for the front left channel.
---@param frontRight number The volume for the front right channel.
---@param rearLeft number The volume for the rear left channel.
---@param rearRight number The volume for the rear right channel.
---@param channel5 number The volume for channel 5.
---@param channel6 number The volume for channel 6.
function SetAudioSubmixOutputVolumes(submixId, outputSlot, frontLeft, frontRight, rearLeft, rearRight, channel5, channel6) end