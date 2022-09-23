dt = 0.0001
make_default_activity(dt)
local  aircraft = get_aircraft_type()




local PNT_AIRBRAKE 			= nil
local PNT_CTM_ONCE			= nil
local PNT_UNLOCK			= nil
local PNT_LOCK				= nil
local PNT_STATION			= nil
local PNT_AA_MODES_STICK	= nil
local PNT_AUTO_LEVEL_STICK	= nil
local PNT_AUTO_RESET_STICK	= nil
local PNT_UNLOCK_STICK		= nil
local PNT_LOCK_STICK		= nil
local PNT_MIRROR_U			= nil
local PNT_MIRROR_L			= nil
local PNT_MIRROR_R			= nil
local PNT_GEAR				= nil
local PNT_CANOPY			= nil
local PNT_TGT_L				= nil
local PNT_TGT_R				= nil
local PNT_TGT_U				= nil
local PNT_TGT_D				= nil
local PNT_TRIM_L			= nil
local PNT_TRIM_R			= nil
local PNT_TRIM_U			= nil
local PNT_TRIM_D			= nil
local PNT_CTM_CHAFF			= nil			
local PNT_CTM_FLARE			= nil
local PNT_CTM_F15			= nil
local PNT_FLAPS_MULTI_BIS	= nil
local PNT_STICK_LOCK		= nil
local PNT_STICK_UNLOCK		= nil
local PNT_STICK_STATION		= nil
local PNT_STICK_SHOOT		= nil
local PNT_COM				= nil

--local TEST					= nil
--[[
local THROTTLE_L_PNTS 			= get_param_handle("THROTTLE_L_PNTS")
local THROTTLE_R_PNTS 			= get_param_handle("THROTTLE_R_PNTS")
local STICK_PITCH_PNTS 			= get_param_handle("STICK_PITCH_PNTS")
local STICK_ROLL_PNTS 			= get_param_handle("STICK_ROLL_PNTS")
local CANOPY_PNTS 				= get_param_handle("CANOPY_PNTS")
local GEARLEVER_PNTS			= get_param_handle("GEARLEVER_PNTS")
local CANOPYLEVER_PNTS			= get_param_handle("CANOPYLEVER_PNTS")
]]
function post_initialize()

	PNT_AIRBRAKE 			= get_clickable_element_reference("PNT_AIRBRAKE")
	PNT_CTM_ONCE 			= get_clickable_element_reference("PNT_CTM_ONCE")
	PNT_UNLOCK 				= get_clickable_element_reference("PNT_UNLOCK")
	PNT_LOCK 				= get_clickable_element_reference("PNT_LOCK")
	PNT_STATION 			= get_clickable_element_reference("PNT_STATION")
	PNT_AA_MODES_STICK		= get_clickable_element_reference("PNT_AA_MODES_STICK")
	PNT_AUTO_LEVEL_STICK	= get_clickable_element_reference("PNT_AUTO_LEVEL_STICK")
	PNT_AUTO_RESET_STICK	= get_clickable_element_reference("PNT_AUTO_RESET_STICK")
	PNT_UNLOCK_STICK		= get_clickable_element_reference("PNT_UNLOCK_STICK")
	PNT_LOCK_STICK			= get_clickable_element_reference("PNT_LOCK_STICK")
	PNT_MIRROR_U			= get_clickable_element_reference("PNT_MIRROR_U")
	PNT_MIRROR_L			= get_clickable_element_reference("PNT_MIRROR_L")
	PNT_MIRROR_R			= get_clickable_element_reference("PNT_MIRROR_R")
	PNT_GEAR				= get_clickable_element_reference("PNT_GEAR")
	PNT_CANOPY				= get_clickable_element_reference("PNT_CANOPY")
	PNT_TGT_L				= get_clickable_element_reference("PNT_TGT_L")
	PNT_TGT_R				= get_clickable_element_reference("PNT_TGT_R")
	PNT_TGT_U				= get_clickable_element_reference("PNT_TGT_U")
	PNT_TGT_D				= get_clickable_element_reference("PNT_TGT_D")
	PNT_TRIM_L				= get_clickable_element_reference("PNT_TRIM_L")
	PNT_TRIM_R				= get_clickable_element_reference("PNT_TRIM_R")
	PNT_TRIM_U				= get_clickable_element_reference("PNT_TRIM_U")
	PNT_TRIM_D				= get_clickable_element_reference("PNT_TRIM_D")
	PNT_CTM_CHAFF			= get_clickable_element_reference("PNT_CTM_CHAFF")
	PNT_CTM_FLARE			= get_clickable_element_reference("PNT_CTM_FLARE")
	PNT_CTM_F15				= get_clickable_element_reference("PNT_CTM_F15")
	PNT_FLAPS_MULTI_BIS		= get_clickable_element_reference("PNT_FLAPS_MULTI_BIS")
	PNT_STICK_LOCK			= get_clickable_element_reference("PNT_STICK_LOCK")
	PNT_STICK_UNLOCK		= get_clickable_element_reference("PNT_STICK_UNLOCK")
	PNT_STICK_STATION		= get_clickable_element_reference("PNT_STICK_STATION")
	PNT_STICK_SHOOT			= get_clickable_element_reference("PNT_STICK_SHOOT")
	PNT_COM					= get_clickable_element_reference("PNT_COM")

end

function update()
	--[[
		
	THROTTLE_L_PNTS:set(get_cockpit_draw_argument_value(104))
	THROTTLE_R_PNTS:set(get_cockpit_draw_argument_value(105))
	STICK_PITCH_PNTS:set(get_cockpit_draw_argument_value(74))
	STICK_ROLL_PNTS:set(get_cockpit_draw_argument_value(71))
	CANOPY_PNTS:set(get_cockpit_draw_argument_value(181))
	GEARLEVER_PNTS:set(get_cockpit_draw_argument_value(83))
	if aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S" then
	CANOPYLEVER_PNTS:set(get_cockpit_draw_argument_value(800))
	elseif  aircraft=="Su-25T"then
	CANOPYLEVER_PNTS:set(get_cockpit_draw_argument_value(181))
	end
	]]

    if PNT_AIRBRAKE then
		PNT_AIRBRAKE:update()
	end
	if PNT_CTM_ONCE then
		PNT_CTM_ONCE:update()
	end
	if PNT_UNLOCK then
		PNT_UNLOCK:update()
	end
	if PNT_LOCK then
		PNT_LOCK:update()
	end
	if PNT_STATION then
		PNT_STATION:update()
	end
	if PNT_AA_MODES_STICK then
		PNT_AA_MODES_STICK:update()
	end
	if PNT_UNLOCK_STICK then
		PNT_UNLOCK_STICK:update()
	end
	if PNT_LOCK_STICK then
		PNT_LOCK_STICK:update()
	end
	if PNT_AUTO_LEVEL_STICK then
		PNT_AUTO_LEVEL_STICK:update()
	end
	if PNT_AUTO_RESET_STICK then
		PNT_AUTO_RESET_STICK:update()
	end
	if PNT_MIRROR_U then
		PNT_MIRROR_U:update()
	end
	if PNT_MIRROR_L then
		PNT_MIRROR_L:update()
	end
	if PNT_MIRROR_R then
		PNT_MIRROR_R:update()
	end
	if PNT_GEAR then
		PNT_GEAR:update()
	end
	if PNT_CANOPY then
		PNT_CANOPY:update()
	end
	if PNT_TGT_L then
		PNT_TGT_L:update()
	end
	if PNT_TGT_R then
		PNT_TGT_R:update()
	end
	if PNT_TGT_U then
		PNT_TGT_U:update()
	end
	if PNT_TGT_D then
		PNT_TGT_D:update()
	end
	if PNT_TRIM_L then
		PNT_TRIM_L:update()
	end
	if PNT_TRIM_R then
		PNT_TRIM_R:update()
	end
	if PNT_TRIM_U then
		PNT_TRIM_U:update()
	end
	if PNT_TRIM_D then
		PNT_TRIM_D:update()
	end
	if PNT_CTM_CHAFF then
		PNT_CTM_CHAFF:update()
	end
	if PNT_CTM_FLARE then
		PNT_CTM_FLARE:update()
	end
	if PNT_CTM_F15 then
		PNT_CTM_F15:update()
	end
	if PNT_FLAPS_MULTI_BIS then
		PNT_FLAPS_MULTI_BIS:update()
	end
	if PNT_STICK_LOCK	 then
		PNT_STICK_LOCK:update()
	end
	if PNT_STICK_UNLOCK	 then
		PNT_STICK_UNLOCK:update()
	end
	if PNT_STICK_STATION	 then
		PNT_STICK_STATION:update()
	end
	if PNT_STICK_SHOOT		then
		PNT_STICK_SHOOT:update()
	end
	if PNT_COM	then
		PNT_COM:update()
	end
end



need_to_be_closed = false -- close lua state after initialization
