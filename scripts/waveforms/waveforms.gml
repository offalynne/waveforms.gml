function wave(_phase, _frequency, _waveform = WAVEFORM_FLAT)
{
    if (_frequency == 0.0) return 0.0;
    static __waveforms_struct = __waveforms();
    //if (!is_method(__waveforms_struct[$ _waveform])) show_error("No such waveform: " + string(_waveform), true); else //Optional error checking
    return __waveforms_struct[$ _waveform](_phase, _frequency);
}

function __waveforms()
{
    static __instance = new (function() constructor {
        
    global.__2pi = 2 * pi;

    self[$ WAVEFORM_TRIANGLE] = function(_p, _f) { return (-2 / _f) * (_p - _f / 2 * floor((2 * _p)/ _f + 0.5)) * power(-1.0, floor((2 * _p)/ _f + 0.5)); }    
    self[$ WAVEFORM_SAWTOOTH] = function(_p, _f) { return -(_p / _f - floor(0.5 + _p / _f)); };    
    self[$ WAVEFORM_SQUARE]   = function(_p, _f) { return ((_p mod _f) < (_f / 2))? -0.5 : 0.5; };
    self[$ WAVEFORM_SINE]     = function(_p, _f) { return sin(_p * global.__2pi / _f) / -2; };
    self[$ WAVEFORM_FLAT]     = function(_p, _f) { return 0.0 };
    
    })();
    return __instance;
};

#macro WAVEFORM_TRIANGLE  "waveform triangle"
#macro WAVEFORM_SAWTOOTH  "waveform sawtooth"
#macro WAVEFORM_SQUARE    "waveform square"
#macro WAVEFORM_SINE      "waveform sine"
#macro WAVEFORM_FLAT      "waveform flat"
