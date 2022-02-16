
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









need_to_be_closed  = true -- close lua state after initialization