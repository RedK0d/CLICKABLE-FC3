dt = 0.0001
make_default_activity(dt)

local PNT_AIRBRAKE 	= nil
local PNT_CTM_ONCE	= nil
local PNT_UNLOCK	= nil
local PNT_LOCK		= nil
local PNT_STATION	= nil
local THROTTLE_L = get_param_handle("THROTTLE_L")
local THROTTLE_R = get_param_handle("THROTTLE_R")
function post_initialize()

	PNT_AIRBRAKE 	= get_clickable_element_reference("PNT_AIRBRAKE")
	PNT_CTM_ONCE 	= get_clickable_element_reference("PNT_CTM_ONCE")
	PNT_UNLOCK 		= get_clickable_element_reference("PNT_UNLOCK")
	PNT_LOCK 		= get_clickable_element_reference("PNT_LOCK")
	PNT_STATION 	= get_clickable_element_reference("PNT_STATION")

end

function update()
	THROTTLE_L:set(get_cockpit_draw_argument_value(104))
	THROTTLE_R:set(get_cockpit_draw_argument_value(105))

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
end