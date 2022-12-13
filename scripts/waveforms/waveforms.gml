function wave(_phase, _frequency, _waveform = WAVEFORM_FLAT)
{
    gml_pragma("forceinline");
    if (_frequency == 0.0) return 0.0;
    return _waveform(_phase, _frequency);
}

#macro WAVEFORM_TRIANGLE (__waveform()).__triangle
#macro WAVEFORM_SAWTOOTH (__waveform()).__sawtooth
#macro WAVEFORM_SQUARE   (__waveform()).__square
#macro WAVEFORM_SINE     (__waveform()).__sine
#macro WAVEFORM_FLAT     (__waveform()).__flat

function __waveform()
{
    static __instance = new (function() constructor {

    __triangle = function(_p, _f) { return (-2.0 / _f) * (_p - _f / 2 * floor((2.0 * _p)/ _f + 0.5)) * power(-1.0, floor((2.0 * _p)/ _f + 0.5)); }    
    __sawtooth = function(_p, _f) { return -(_p / _f - floor(0.5 + _p / _f)); };    
    __square   = function(_p, _f) { return ((_p mod _f) < (_f / 2))? -0.5 : 0.5; };
    __sine     = function(_p, _f) { return sin(_p * 2.0 * pi / _f) / -2.0; };
    __flat     = function(_p, _f) { return 0.0 };
    
    })();
    return __instance;
};
