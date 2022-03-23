dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.common_script_path.."tools.lua")

layoutGeometry = {}
attributes = {
	--"support_for_cws",
}
MainPanel = {"ccMainPanel",LockOn_Options.script_path.."mainpanel_init.lua", {} }

creators = {}

creators[devices.CLICKABLE]	 		        = {"avLuaDevice"                ,LockOn_Options.script_path.."SYSTEMS/clickable.lua"}	
--creators[devices.PNT_UPD] 					= {"avLuaDevice"				,LockOn_Options.script_path.."SYSTEMS/PNT_update.lua"}

indicators  = {}

