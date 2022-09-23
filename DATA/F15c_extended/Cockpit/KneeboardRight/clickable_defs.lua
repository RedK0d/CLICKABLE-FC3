cursor_mode = 
{
    CUMODE_CLICKABLE = 0,
    CUMODE_CLICKABLE_AND_CAMERA = 1,
    CUMODE_CAMERA = 2
}

clickable_mode_initial_status = cursor_mode.CUMODE_CAMERA
use_pointer_name = true
anim_speed_default = 16

function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

function default_button(hint_,device_,command_,arg_,arg_val_,arg_lim_)

	local   arg_val_ = arg_val_ or 1
	local   arg_lim_ = arg_lim_ or {0,1}

	return  {	
				class 				= {class_type.BTN},
				hint  				= hint_,
				device 				= device_,
				action 				= {command_},
				stop_action 		= {command_},
				arg 				= {arg_},
				arg_value			= {arg_val_}, 
				arg_lim 			= {arg_lim_},
				use_release_message = {false},
				updatable 	= true, 
			}
end


-- not in use
function default_1_position_tumb(hint_, device_, command_, arg_, arg_val_, arg_lim_)
    local arg_val_ = arg_val_ or 1
    local arg_lim_ = arg_lim_ or {0, 1}
    return {
        class = {class_type.TUMB},
        hint = hint_,
        device = device_,
        action = {command_},
        arg = {arg_},
        arg_value = {arg_val_},
        arg_lim = {arg_lim_},
        updatable = true,
        use_OBB = true
    }
end

function default_2_position_tumb(hint_, device_, command_, arg_,inversed_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default
    local val = 1
    if inversed_ then
        val = -1
    end
    return {
        class           = {class_type.BTN, class_type.BTN},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        arg             = {arg_, arg_},
        arg_value       = {val, -val},
        arg_lim         = {{0, 1}, {0, 1}},
        updatable       = true,
        use_OBB         = true,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil
    }
end



-- default_3_position_tumb = bouton 3 positions -1,0,1 souris gauche ou souris droite indiff�remment
function default_3_position_tumb(hint_, device_, command_, arg_, cycled_, inversed_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default
    local cycled = false

    local val = 1
    if inversed_ then
        val = -1
    end

    if cycled_ ~= nil then
        cycled = cycled_
    end

    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        arg             = {arg_, arg_},
        arg_value       = {val, -val},
        arg_lim         = {{-1, 1}, {-1, 1}},
        updatable       = true,
        use_OBB         = true,
        cycle           = cycled,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil
    }
end


function springloaded_3_1_pos_tumb(hint_,device_,command1_,command2_,arg_,animation_speed_,val1_,val2_,val3_)
	local	animation_speed_ = animation_speed_ or anim_speed_default
	local	val1 = val1_ or -1.0
	local	val2 = val2_ or 0.0
	local	val3 = val3_ or 1.0
	return  {
				class			= {class_type.BTN,class_type.BTN},
				hint			= hint_,
				device			= device_,
				action			= {command1_,command2_},
				stop_action		= {command1_,command2_},
				arg				= {arg_,arg_},
				arg_value		= {val1,val3},
				arg_lim			= {{val1,val2},{val2,val3}},
				updatable		= true,
				use_OBB			= true,
				use_release_message = {true,true},
				animated		= {true,true},
			    animation_speed	= {animation_speed_,animation_speed_},
				sound			= {{SOUND_SW1}, {SOUND_SW1}},
				side			= {{BOX_SIDE_Z_top},{BOX_SIDE_Z_bottom}}
			}
end

function default_3_1_position_tumb(hint_, device_, command_, arg_, cycled_, inversed_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default
    local cycled = false

    local val = 1
    if inversed_ then
        val = -1
    end

    if cycled_ ~= nil then
        cycled = cycled_
    end

    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        stop_action     = {nil, command_},
        arg             = {arg_, arg_},
        arg_value       = {val, -val},
        arg_lim         = {{-1, 1}, {-1, 1}},
        updatable       = true,
        use_OBB         = true,
        use_release_message = true,
        cycle           = cycled,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil
    }
end

function springloaded_3_pos_tumb(hint_, device_, command_, arg_, inversed_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default
    local val = 1
    if inversed_ then
        val = -1
    end

    return {
        class               = {class_type.BTN, class_type.TUMB},
        hint                = hint_,
        device              = device_,
        action              = {command_, command_},
        stop_action         = {command_, command_},
        arg                 = {arg_, arg_},
        arg_value           = {val, -val},
        arg_lim             = {{-1, 1}, {-1, 1}},
        updatable           = true,
        use_OBB             = true,
        use_release_message = true,
        animated            = {true, true},
        animation_speed     = {animation_speed_, animation_speed_},
        sound               = sound_ and {{sound_, sound_}} or nil
    }
end

-- rotary axis with no end stops. suitable for continuously rotating knobs
function default_axis(hint_, device_, command_, arg_, default_, gain_, updatable_, relative_)
    local default = default_ or 1
    local gain = gain_ or 0.1
    local updatable = updatable_ or false
    local relative = relative_ or false

    return {
        class       = {class_type.LEV},
        hint        = hint_,
        device      = device_,
        action      = {command_},
        arg         = {arg_},
        arg_value   = {default},
        arg_lim     = {{0, 1}},
        updatable   = updatable,
        use_OBB     = true,
        gain        = {gain},
        relative    = {relative}
    }
end

function default_axis_limited(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_, arg_lim_)
	
	
	local default = default_ or 0
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	--[[
	local relative = false
	if relative_ ~= nil then
		relative = relative_
	end
	]]

	return  {	
				class 		= {class_type.LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {arg_lim_},
				updatable 	= updatable, 
				use_OBB 	= true,--false,
				gain		= {gain},
				relative    = {relative},
				cycle     	= false,
			}
end


function default_movable_axis(hint_,device_,command_,arg_, default_, gain_,updatable_,relative_)
	
	local default = default_ or 1
	local gain = gain_ or 0.1
	local updatable = updatable_ or false
	local relative  = relative_ or false
	
	return  {	
				class 		= {class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_},
				arg 	  	= {arg_},
				arg_value 	= {default}, 
				arg_lim   	= {{0,1}},
				updatable 	= updatable, 
				use_OBB 	= true,
				gain		= {gain},
				relative    = {relative}, 				
			}
end

-- not in use. this multiple position switch is cyclable.
function multiposition_switch(hint_, device_, command_, arg_, count_, delta_, inversed_, min_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default

    local min_ = min_ or 0
    local delta_ = delta_ or 0.5

    local inversed = 1
    if inversed_ then
        inversed = -1
    end

    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        arg             = {arg_, arg_},
        arg_value       = {-delta_ * inversed, delta_ * inversed},
        arg_lim         = {
                            {min_, min_ + delta_ * (count_ - 1)},
                            {min_, min_ + delta_ * (count_ - 1)}
                        },
        updatable       = true,
        use_OBB         = true,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil
    }
end

function multiposition_switch_limited(hint_, device_, command_, arg_, count_, delta_, inversed_, min_, sound_, animation_speed_)
    local animation_speed_ = animation_speed_ or anim_speed_default

    local min_ = min_ or 0
    local delta_ = delta_ or 0.5

    local inversed = 1
    if inversed_ then
        inversed = -1
    end

    return {
        class           = {class_type.TUMB, class_type.TUMB},
        hint            = hint_,
        device          = device_,
        action          = {command_, command_},
        arg             = {arg_, arg_},
        arg_value       = {-delta_ * inversed, delta_ * inversed},
        arg_lim         = {
                            {min_, min_ + delta_ * (count_ - 1)},
                            {min_, min_ + delta_ * (count_ - 1)}
                        },
        updatable       = true,
        use_OBB         = true,
        cycle           = false,
        animated        = {true, true},
        animation_speed = {animation_speed_, animation_speed_},
        sound           = sound_ and {{sound_, sound_}} or nil
    }
end

-- rotary axis with push button
function default_button_axis(hint_, device_, command_1, command_2, arg_1, arg_2, limit_1, limit_2)
    local limit_1_ = limit_1 or {0, 1.0}
    local limit_2_ = limit_2 or {0, 1.0}
    return {
        class               = {class_type.BTN, class_type.LEV},
        hint                = hint_,
        device              = device_,
        action              = {command_1, command_2},
        stop_action         = {command_1, 0},
        arg                 = {arg_1, arg_2},
        arg_value           = {1, 0.5},
        arg_lim             = {limit_1_, limit_2_},
        animated            = {false, true},
        animation_speed     = {1, 1},
        gain                = {1.0, 0.5},
        relative            = {false, false},
        updatable           = true,
        use_OBB             = true,
        use_release_message = {true, false}
    }
end

-- NOT IN USE
function default_animated_lever(hint_, device_, command_, arg_, animation_speed_,arg_lim_,arg_value_)
    local arg_lim = arg_lim_ or {0.0,1.0}
    local arg_value = arg_value_ or 1.0
    return  {	
        class  = {class_type.TUMB, class_type.TUMB},
        hint   	= hint_, 
        device 	= device_,
        action 	= {command_, command_},
        arg 		= {arg_, arg_},
        arg_value 	= {arg_value, -arg_value},
        arg_lim 	= {arg_lim, arg_lim},
        updatable  = true, 
        gain 		= {0.1, 0.1},
        animated 	= {true, true},
        animation_speed = {animation_speed_, animation_speed_}
    }
end
-- default_button_tumb = bouton � deux commandes
-- bouton gauche commande 1
-- bouton droit commande 2
-- stop_action = {command1_,0}, => le bouton gauche revient au 0, alors que le bouton droit non/ the left button returns to 0, while the right button does not
-- stop_action = {command1_,command2_}, => le bouton gauche et le bouton droit reviennent au 0/ left button and right button return to 0
function default_button_tumb(hint_, device_, command1_, command2_, arg_,style)
	if style == 1 or style == nil then
		stop_action_ = {command1_,0}
	elseif style == 2 then -- speedbrake
		stop_action_ = {command1_,command2_}
	elseif style == 3 then -- speedbrake
		stop_action_ = {command2_,0}
	elseif style == 4 then -- speedbrake
		stop_action_ = {command1_,0,command2_,0}
	end
	return  {	
				class 		= {class_type.TUMB,class_type.TUMB},
				hint  		= hint_,
				device 		= device_,
				action 		= {command1_,command2_},
				stop_action = stop_action_,
				arg 	  	= {arg_,arg_},
				arg_value 	= {1,1},
				arg_lim   	= {{0,1},{0,1}},
				updatable 	= true, 
				use_OBB 	= true,
				use_release_message = {true,false}
			}
end
--Function to be reviewed, only found way to implement both arguments in the same function, buggy on the right click.
function tricked_button_tumb_2arg(hint_, device_, command_1, command_2, arg_1, arg_2, limit_1, limit_2)
    local limit_1_ = limit_1 or 1.0
    local limit_2_ = limit_2 or 1.0
    return {
                class 		= {class_type.TUMB,class_type.MOVABLE_LEV},
				hint  		= hint_,
				device 		= device_,
				action 		= {command_1,command_2},
				stop_action = {nil},
				arg 	  	= {arg_1,arg_2},
				arg_value 	= {1,nil},
				arg_lim   	= {{0,1},{0,0}},
				updatable 	= true,
                relative    = true, 
				use_OBB 	= true,
				use_release_message = {false,false}
    }
end