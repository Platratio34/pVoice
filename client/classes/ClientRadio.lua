---@class PVoice.ClientRadio
---@field id string
---@field private _mode string
---@field private _txFreq number?
---@field private _rxFreq number?
---@field private _tx boolean
---@field private _rx boolean
---@field rxActive boolean
ClientRadio = {}

---Create a new radio wrapper
---@param id string Radio ID, used to internal reference
---@param mode string Radio mode. Often one of `am`, `fm`, or `dmr`
---@param txFreq number Transmit frequency, set to `-1` to disable
---@param rxFreq number Receive frequency, set to `-1` to disable
---@return PVoice.ClientRadio radio
function ClientRadio.new(id, mode, txFreq, rxFreq)
    local o = {}
    setmetatable(o, { __index = ClientRadio })
    o:__init__(id, mode, txFreq, rxFreq)
    return o
end

---Internal initializer
---@param id string
---@param mode string
---@param txFreq number
---@param rxFreq number
---@package
function ClientRadio:__init__(id, mode, txFreq, rxFreq)
    self.id = id
    self._mode = mode
    self._txFreq = txFreq
    self._rxFreq = rxFreq

    self._tx = false
    self._rx = false

    self._rxActive = false
end

---Get the current frequencies used by the radio
---@return number txFreq Transmit frequency, or `-1` if transmit is disabled
---@return number rxFreq Receive frequency, or `-1` if receive is disabled
function ClientRadio:getFreq()
    return self._txFreq, self._rxFreq
end

---Get the mode of the radio.
---Often one of `am`, `fm`, or `dmr`
---@return string mode
function ClientRadio:getMode()
    return self._mode
end

---Set the frequencies of the radio
---@param tx number|nil New transmit frequency, set to `nil` to disable
---@param rx number|nil New receive frequency, set to `nil` to disable
---@param mode string New radio mode. Often one of `am`, `fm`, or `dmr`
function ClientRadio:setFreq(tx, rx, mode)
    self._txFreq = tx
    self._rxFreq = rx
    self._mode = mode
end

---Get the transmit state of the radio
---@return boolean tx
function ClientRadio:getTx()
    return self._tx
end

---Get the receive state of the radio
---@return boolean rx
function ClientRadio:getRx()
    return self._rx
end

---Check if the radio is receiving anything right now
---@return boolean rxActive
function ClientRadio:getRxActive()
    return self._rxActive
end