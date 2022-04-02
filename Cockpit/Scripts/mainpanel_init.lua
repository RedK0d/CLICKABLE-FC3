
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
--[[
local controllers = LoRegisterPanelControls()

if   aircraft=="Su-33"or   aircraft=="Su-27"or aircraft=="J-11A" or aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S" or aircraft=="Su-25T" or aircraft=="Su-25" then
THROTTLE_L_PNTS						= CreateGauge("parameter")
THROTTLE_L_PNTS.arg_number			= 1
THROTTLE_L_PNTS.input				= {0,1}
THROTTLE_L_PNTS.output				= {-1,0}
THROTTLE_L_PNTS.parameter_name		= "THROTTLE_L_PNTS"

THROTTLE_R_PNTS						= CreateGauge("parameter")
THROTTLE_R_PNTS.arg_number			= 2
THROTTLE_R_PNTS.input				= {0,1}
THROTTLE_R_PNTS.output				= {-1,0}
THROTTLE_R_PNTS.parameter_name		= "THROTTLE_R_PNTS"

STICK_PITCH_PNTS						= CreateGauge("parameter")
STICK_PITCH_PNTS.arg_number			= 3
STICK_PITCH_PNTS.input				= {-1,1}
STICK_PITCH_PNTS.output				= {-1,1}
STICK_PITCH_PNTS.parameter_name		= "STICK_PITCH_PNTS"

STICK_ROLL_PNTS						= CreateGauge("parameter")
STICK_ROLL_PNTS.arg_number			= 4
STICK_ROLL_PNTS.input				= {-1,1}
STICK_ROLL_PNTS.output				= {-1,1}
STICK_ROLL_PNTS.parameter_name		= "STICK_ROLL_PNTS"

CANOPY_PNTS						    = CreateGauge("parameter")
CANOPY_PNTS.arg_number			    = 5
CANOPY_PNTS.input				    = {-1,1}
CANOPY_PNTS.output				    = {-1,1}
CANOPY_PNTS.parameter_name		    = "CANOPY_PNTS"

GEARLEVER_PNTS						= CreateGauge("parameter")
GEARLEVER_PNTS.arg_number			= 6
GEARLEVER_PNTS.input				= {-1,1}
GEARLEVER_PNTS.output				= {-1,1}
GEARLEVER_PNTS.parameter_name		= "GEARLEVER_PNTS"

CANOPYLEVER_PNTS						= CreateGauge("parameter")
CANOPYLEVER_PNTS.arg_number			= 7
CANOPYLEVER_PNTS.input				= {-1,1}
CANOPYLEVER_PNTS.output				= {-1,1}
CANOPYLEVER_PNTS.parameter_name		= "CANOPYLEVER_PNTS"


end
]]


need_to_be_closed  = true -- close lua state after initialization

