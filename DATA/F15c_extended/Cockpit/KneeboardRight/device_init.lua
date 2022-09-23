dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."supported.lua")																					--Call lua file to detect current aircraft
dofile(LockOn_Options.common_script_path.."tools.lua")

attributes = {
	"support_for_cws",
}

if      supported == true  then																										--Mod launching logic.
	MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua", {} }
	creators = {}
	creators[devices.CLICKABLE_GENERIC_SYSTEM] 		        = {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/clickable.lua"}	
	creators[devices.RADIO_CONTROL_SYSTEM]	 		        = {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/radio_control.lua"}	
	creators[devices.COUNTERMEASURES_SYSTEM]	        	= {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/cmd_control.lua"}	
	creators[devices.RADAR_CONTROL_SYSTEM]		        	= {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/radar_control.lua"}	
	creators[devices.LIGHT_CONTROL_SYSTEM] 		       		= {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/light_control.lua"}	
	creators[devices.ELEC_CONTROL_SYSTEM] 		       		= {"avSimpleElectricSystem"     ,LockOn_Options.script_path.."SYSTEMS/elec_control.lua"}	
	creators[devices.ENGINES_CONTROL_SYSTEM]	       		= {"avLuaDevice"     			,LockOn_Options.script_path.."SYSTEMS/engines_control.lua"}	
	creators[devices.FUEL_CONTROL_SYSTEM]	       			= {"avLuaDevice"     			,LockOn_Options.script_path.."SYSTEMS/fuel_control.lua"}	
	creators[devices.MISC_CONTROL_SYSTEM]	       			= {"avLuaDevice"     			,LockOn_Options.script_path.."SYSTEMS/misc_control.lua"}	
end
---------------------------------------------
dofile(LockOn_Options.common_script_path.."KNEEBOARD/declare_kneeboard_device.lua")
---------------------------------------------

