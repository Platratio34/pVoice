Config = {
    revertDistance = 5, --- Distance at which all talking will revert to proximity, ignoring voice targets
    updateFrequency = 500, --- Milliseconds between target volume updates

    calls = {
        towerInnerDistance = 3000,
        towerOuterDistance = 4000,

        submixId = 'call1',
        submixBadId = 'call2'
    },

    radio = {

        submixIds = {
            'radio1',
            'radio2'
        }
    },

    submixes = {
        ['call1'] = {
            radio = true,
            effects_int = {
                [`default`] = 1,
            },
            effects = {
                [`freq_low`] = 300.0,
                [`freq_hi`] = 6000.0
            }
        },
        ['call2'] = {
            radio = true,
            effects_int = {
                [`default`] = 1,
            },
            effects = {
                [`freq_low`] = 300.0,
                [`freq_hi`] = 6000.0
            }
        },
        ['radio1'] = {
            radio = true,
            effects_int = {
                [`default`] = 1,
            },
            effects = {
                [`freq_low`] = 300.0,
                [`freq_hi`] = 6000.0
            }
        },
        ['radio2'] = {
            radio = true,
            effects_int = {
                [`default`] = 1,
            },
            effects = {
                [`freq_low`] = 300.0,
                [`freq_hi`] = 6000.0
            }
        }
    }
}