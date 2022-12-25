function wave(_phase, _frequency, _waveform = WAVEFORM_FLAT) { return __waveforms()[$ _waveform](_phase, _frequency); }

//Library singleton
function __waveforms(){ static __instance = new (function() constructor
{
    __2pi = 2*pi;
    var _set = function(_name, _function){ variable_struct_set(self, _name, _function) };

    //Waveforms    
    _set(WAVEFORM_TRIANGLE, function(_p, _f) { return (-2/_f)*(_p - _f/2*floor((2*_p)/_f + 0.5))*power(-1.0, floor((2*_p)/_f + 0.5)) });
    _set(WAVEFORM_SAWTOOTH, function(_p, _f) { return -(_p/_f - floor(0.5 + _p/_f)) });
    _set(WAVEFORM_SQUARE,   function(_p, _f) { return ((_p mod _f) < (_f/2))? -0.5 : 0.5 });
    _set(WAVEFORM_SINE,     function(_p, _f) { return sin(_p*__2pi/_f)/-2 });
    _set(WAVEFORM_FLAT,     function(_p, _f) { return 0.0 });    
}
)(); return __instance; };

#macro WAVEFORM_TRIANGLE  "triangle"
#macro WAVEFORM_SAWTOOTH  "sawtooth"
#macro WAVEFORM_SQUARE    "square"
#macro WAVEFORM_SINE      "sine"
#macro WAVEFORM_FLAT      "flat"
