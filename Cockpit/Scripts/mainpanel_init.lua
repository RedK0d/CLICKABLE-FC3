
local  aircraft = get_aircraft_type()

if      aircraft=="Su-27"or aircraft=="J-11A"   then
    shape_name		   = "SU-27-CLICKABLE"
elseif  aircraft=="Su-33"                       then
    shape_name		   = "SU-33-CLICKABLE"
elseif  aircraft=="Su-25T"                       then
    shape_name		   = "SU-25T-CLICKABLE"
elseif  aircraft=="Su-25"                       then
    shape_name		   = "SU-25-CLICKABLE"
elseif  aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S"      then
    shape_name		   = "MIG-29-CLICKABLE"
end

local controllers = LoRegisterPanelControls()

THROTTLE_L						= CreateGauge("parameter")
THROTTLE_L.arg_number			= 1
THROTTLE_L.input				= {0,1}
THROTTLE_L.output				= {-1,0}
THROTTLE_L.parameter_name		= "THROTTLE_L"

THROTTLE_R						= CreateGauge("parameter")
THROTTLE_R.arg_number			= 2
THROTTLE_R.input				= {0,1}
THROTTLE_R.output				= {-1,0}
THROTTLE_R.parameter_name		= "THROTTLE_R"






need_to_be_closed  = true -- close lua state after initialization

