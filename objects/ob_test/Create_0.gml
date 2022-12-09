draw_test = function()
{
    static _x  = 0;    // test x
    static _p  = 8;    // test period
    static _sp = 60;   // test speed
    static _bg = true; // draw mode
    
    var _names = //variable_struct_get_names(WAVEFORM);
                 ["SQUARE", "SINE", "FLAT", "TRIANGLE", "SAWTOOTH"];
    
    var _len     = array_length(_names);
    var _cleared = false;
    
    if (keyboard_check_pressed(ord("A")) || device_mouse_check_button_pressed(1, mb_left) || gamepad_button_check_pressed(0, gp_face1))
    {
        // change draw mode
        if (_bg) _x = 0;
        _bg = !_bg;
        _cleared = true;
        draw_clear(0);
    }

    if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_left))
    {
        // adjust period        
        if (!_bg)
        {
            // force-clear screen buffer
            _cleared = true;
            draw_clear(0);
            _x = 0;
        }
            
        if (keyboard_check_pressed(vk_left))  _p -= 2;
        if (keyboard_check_pressed(vk_right)) _p += 2;
        _p  = clamp(_p, 1, room_width/20);
    }    
    
    var _period = room_width / _p;

    if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(vk_up))
    {
        // adjust speed
        if (keyboard_check_pressed(vk_down)) _sp /= 2;
        if (keyboard_check_pressed(vk_up))   _sp *= 2;
        _sp = clamp(_sp, 16, 2048);
    }    
    
    game_set_speed(_sp, gamespeed_fps);

    var _bar = room_height / (_len + 1);
    var _mouse_bar = (mouse_y div _bar) - 1;

    if (_bg)
    {
        //force clear screen buffer
        draw_clear(0);
        draw_set_color(c_white);
    }

    // draw readout
    var _str = "";
    _str += "Mode (A)                = " + string(_bg) + "\n";
    _str += "Frequency (Left, Right) = " + string(_p)  + "\n";
    _str += "Speed (Up, Down)        = " + string(game_get_speed(gamespeed_fps));

    // draw background
    var _c = draw_get_color();
    draw_set_color(0);
    draw_rectangle(0, 0, string_width(_str) + 20, string_height(_str) + 20, false);

    draw_set_color(c_silver);
    draw_text(10, 10, _str);
    draw_set_color(_c);


    if (!_bg)
    {
        draw_set_color(c_dkgray);
    }
    else
    {
        draw_set_alpha(0.05);
    }

    var _i = 0;
    if (_bg || _cleared) 
    {
        // draw grid
        _i = 1;
        repeat(room_width / _period)
        {
            // period grid
            draw_line(_i * _period, _bar, _i * _period, room_height);
            ++_i;
        }
        
        var _a = draw_get_alpha();
        _i = 2;
        repeat(_len * 2)
        {
            // period grid
            draw_set_alpha((_i & 1)? _a / 2.5 : _a); 
            draw_line(0, _i * _bar / 2, room_width, _i * _bar / 2);
            ++_i;
        }
    }

    if (!_bg) draw_set_color(_c);
    
    _x++; // update position

    if ((_x >= room_width) && !_bg)
    {
        // change colour per cycle
        draw_set_color(make_color_hsv(color_get_hue(draw_get_color()) + 64, 255, 200));
    }

    _x = _x mod room_width; // wrap position

    _i = 0;
    repeat(_len)
    {
        var _mouse_on = (_mouse_bar == _i);
        
        // draw fillbar
        draw_set_alpha(0.033);
        if (_bg)
        {
            draw_rectangle(0, _bar * (_i + 1), room_width, _bar * (_i + 2), false);
        }
        else
        {        
            var _dy = _bar * (_i + 1.5) + wave(_x - 1, _period, variable_instance_get(WAVEFORM, _names[_i])) * _bar;
        }
        
        var _y  = _bar * (_i + 1.5) + wave(_x, _period, variable_instance_get(WAVEFORM, _names[_i])) * _bar;
        
        if (_bg)
        {
            if (_mouse_on) draw_set_alpha(0.25);
            draw_rectangle(0, _y, room_width, _bar * (_i + 2), false);
        }
    
        draw_set_alpha(1);
        if (!_bg)
        {
            // draw waveform label shadow
            var _c = draw_get_color();
            draw_set_color(0);
    
            _ii = 0;
            repeat(6)
            {
                draw_text(10 + lengthdir_x(2, 60*_ii), _bar * (_i + 1) + 25 + lengthdir_y(2, 60*_ii), _names[_i]);
                ++_ii;
            }
        
            draw_set_color(_c);    
        }
    
        // draw waveform label
        draw_set_color(c_white);
        var _a = draw_get_alpha();
        draw_set_alpha((_mouse_on)? 1 : 0.5);
        draw_text(10, _bar * (_i + 1) + 25, _names[_i]);
        draw_set_color(_c);
        draw_set_alpha(_a);
        
        if (_bg)
        {
            // draw circle
            draw_set_alpha((_mouse_on)? 1 : 0.125);
            draw_circle(_x div 1, _y div 1, (_mouse_on? 4 : 6), false);
            draw_set_alpha(1);
        }
        else
        {
            // draw point
            draw_line(_x - 1, _dy, _x, _y);
        }
    
        ++_i;
    }
}