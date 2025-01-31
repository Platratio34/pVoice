Events = {
    setTalking = 'pvoice:set_taking', --- C => S: (`source: string, talking: boolean`)
    stopTalking = 'pvoice:stop_talking', --- S => C: (`nil`)

    updateVolumes = 'pvoice:update_volumes', --- S => C: (`volumes: { [ServerPlayer]: number }`)

    radio = {
        set_state = 'pvoice:radio:set_state', --- C => S: (`radioId: string, tx: boolean, rx: boolean`)
        update = 'pvoice:radio:update', --- S => C: (`radioId: string, mode: string, txFreq: number, rxFreq: number`)
        remove = 'pvoice:radio:remove', --- S => C: (`radioId: string`)
        
        setRxActive = 'pvoice:radio:rx_active', --- S => C: (`radioId: string, active: boolean`)
    }
}