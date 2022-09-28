local count = 0
local function counter()
	count = count + 1
	return count
end
-------DEVICE ID-------
devices = {}
devices["CLICKABLE_GENERIC_SYSTEM"]     			= counter()
devices["RADIO_CONTROL_SYSTEM"]     				= counter()
devices["COUNTERMEASURES_SYSTEM"]     				= counter()
devices["RADAR_CONTROL_SYSTEM"]  					= counter()
devices["LIGHT_CONTROL_SYSTEM"]  					= counter()
devices["ELEC_CONTROL_SYSTEM"]  					= counter()
devices["ENGINES_CONTROL_SYSTEM"]  					= counter()
devices["FUEL_CONTROL_SYSTEM"]  					= counter()
devices["MISC_CONTROL_SYSTEM"]  					= counter()