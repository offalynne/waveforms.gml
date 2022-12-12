function wave(_phase, _frequency, _waveform = WAVEFORM.FLAT)
{
    gml_pragma("forceinline");
    if (_frequency == 0.0) return 0.0;
    return _waveform(_phase, _frequency);
}

#macro WAVEFORM (__waveform())
function         __waveform()
{
    static __instance = new (function() constructor {

    TRIANGLE = function(_p, _f) { return (-2.0 / _f) * (_p - _f / 2.0 * floor((2.0 * _p)/ _f + 0.5)) * power(-1.0, floor((2.0 * _p)/ _f + 0.5)); }    
    SAWTOOTH = function(_p, _f) { return -(_p / _f - floor(0.5 + _p / _f)); };    
    SQUARE   = function(_p, _f) { return ((_p mod _f) < (_f / 2.0))? -0.5 : 0.5; };
    SINE     = function(_p, _f) { return sin(_p * 2.0 * pi / _f) / -2.0; };
    FLAT     = function(_p, _f) { return 0.0 };
    
    })();
    return __instance;
};
