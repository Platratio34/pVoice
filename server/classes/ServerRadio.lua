---@class PVoice.ServerRadio
---@field id string
---@field player PVoice.ServerPlayer
---@field txPower number
---@field rxSensitivity number
---@field protected _mode string
---@field protected _txFreq number?
---@field protected _rxFreq number?
---@field protected _txTarget string?
---@field protected _rxTarget string?
---@field protected _tx boolean
---@field protected _rx boolean
ServerRadio = {}

---Create a new radio handler
---@param id string Radio ID. Should be unique between resources
---@param player PVoice.ServerPlayer Player holding the radio
---@param mode string Radio mode. Often one of `am`, `fm`, or `dmr`
---@param tx number|nil Transmit frequency of the radio. Set to `nil` to disable transmit
---@param rx number|nil Receive frequency of the radio. Set to `nil` to disable receive
---@return PVoice.ServerRadio
function ServerRadio.new(id, player, mode, tx, rx)
    local o = {}
    setmetatable(o, { __index = ServerRadio })
    o:__init__(id, player, mode, tx, rx)
    return o
end

---@package
function ServerRadio:__init__(id, player, mode, tx, rx)
    self.id = id
    self.player = player
    self:setFreq(mode, tx, rx)
    self.txPower = 10
    self.rxSensitivity = 1
end

---Set the frequency and mode of the radios
---@param mode string Radio mode. Often one of `am`, `fm`, or `dmr`
---@param tx number|nil Transmit frequency of the radio. Set to `nil` to disable transmit
---@param rx number|nil Receive frequency of the radio. Set to `nil` to disable receive
function ServerRadio:setFreq(mode, tx, rx)
    self._mode = mode
    self._txFreq = tx
    self._rxFreq = rx
    self:_updateTargets()
    self:_updateState()
end

---@protected
function ServerRadio:_updateTargets()
    local nTxTargetId = self._mode .. ':' .. (self._txFreq or '')
    AddRadioTarget(self._txTarget, self._txFreq)
    local nRxTargetId = self._mode .. ':' .. (self._rxFreq or '')
    AddRadioTarget(self._rxTarget, self._rxFreq)

    if self._txFreq then                                 -- we have a new tx frequency
        local last = self._txTarget
        self._txTarget = nTxTargetId
        if self._txTarget then                           -- we had a tx frequency
            ---@cast last -?
            if not self._txTarget == nTxTargetId then -- they don't match
                if self._tx then
                    self.player:setTalking(last, false, self.id)
                    self.player:setTalking(self._txTarget, true, self.id)
                end
            end
        elseif self._tx then -- we didn't have a tx frequency
            self.player:setTalking(self._txTarget, true, self.id)
        end
    end

    if self._rxFreq then -- we have a new rx frequency
        local last = self._rxTarget
        self._rxTarget = nRxTargetId
        if self._rxTarget then -- we had a rx frequency
            ---@cast last -?
            if not self._rxTarget == nRxTargetId then -- they don't match
                if self._rx then
                    self.player:setListen(last, false, self.id)
                    self.player:setListen(self._rxTarget, true, self.id)
                end
            end
        elseif self._rx then  -- we didn't have a rx frequency, but we were listening
            self.player:setListen(self._rxTarget, true, self.id)
        end
    end
end

---Set the transmit state of the radio
---@param tx boolean Transmit state
---@return boolean changed If the state of the radio changed. Returns `false` if transmit is disabled
function ServerRadio:setTalk(tx)
    if not self._txTarget then
        return false
    end

    if self._tx == tx then
        return true
    end
    self.player:setTalking(self._txTarget, tx, self.id)

    self._tx = tx
    return true
end

---Set the receive state of the radio
---@param rx boolean Receive state
---@return boolean changed If the state of the radio changed. Returns `false` if receive is disabled
function ServerRadio:setListen(rx)
    if not self._rxTarget then
        return false
    end

    if self._rx == rx then
        return true
    end
    self.player:setListen(self._rxTarget, rx, self.id)

    self._rx = rx
    return true
end

---@protected
function ServerRadio:_updateState()
    self.player:send(Events.radio.update, self.id, self._mode, self._txFreq, self._rxFreq)
end

---Dispose of the radio, removing it from the player and clearing any active targets
function ServerRadio:dispose()
    self.player.radios[self.id] = nil
    if self._tx then
        self.player:setTalking(self._txTarget, false, self.id)
    end
    if self._rx then
        self.player:setListen(self._rxTarget, false, self.id)
    end
    self.player:send(Events.removeRadio, self.id)
end

---Get the receive target id
---@return string? rxTarget Receive target. May be `nil` if receive is disabled
function ServerRadio:getRxTarget()
    return self._rxTarget
end