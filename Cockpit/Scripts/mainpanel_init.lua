
local  aircraft = get_aircraft_type()

if      aircraft=="Su-27"or aircraft=="J-11A"   then
    shape_name		   = "SU-27-CLICKABLE"
elseif  aircraft=="Su-33"                       then
    shape_name		   = "SU-33-CLICKABLE"
end









need_to_be_closed  = true -- close lua state after initialization