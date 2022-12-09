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

    TRIANGLE = function(_phase, _frequency) { return (-2.0 / _frequency) * (_phase - _frequency / 2.0 * floor((2.0 * _phase)/ _frequency + 0.5)) * power(-1.0, floor((2.0 * _phase)/ _frequency + 0.5)); }    
    SAWTOOTH = function(_phase, _frequency) { return -(_phase / _frequency - floor(0.5 + _phase / _frequency)); };    
    SQUARE   = function(_phase, _frequency) { return ((_phase mod _frequency) < (_frequency / 2.0))? -0.5 : 0.5; };
    SINE     = function(_phase, _frequency) { return sin(_phase * 2.0 * pi / _frequency) / -2.0; };
    FLAT     = function(_phase, _frequency) { return 0.0 };
    
    })();
    return __instance;
};