
dofile(LockOn_Options.script_path.."devices.lua")
local 		update_time_step	= 	5 
make_default_activity(update_time_step)
local entry = get_dcs_plugin_path("RedK0d Clickable").."\\entry.lua"
package.path 					=	package.path
									.. ';./Scripts/?.lua;'
									.. './Scripts/Common/?.lua;'
									.. './Scripts/UI/?.lua;'
									.. './Scripts/UI/F10View/?.lua;'
									.. './dxgui/bind/?.lua;'
									.. './dxgui/loader/?.lua;'
									.. './dxgui/skins/skinME/?.lua;'
									.. './dxgui/skins/common/?.lua;'
									.. './MissionEditor/modules/?.lua;'
									.. './Mods/tech/CombinedArms/UI/?.lua;'
local   	TIMER              	=   0
local 		optionsEditor 		= 	require('optionsEditor')
local 		update_time_step 	= 	5 
local 		F15c_extended 		= 	get_plugin_option_value("RedK0d Clickable", "F15c_extended", "local")
local 		version
local 		aircraft 			= get_aircraft_type()
function check_entry_version()
    local file = io.open(entry, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
     		version =string.match(fileContent[8],'............',15)
	return 	version
end
function 				dev_install()
dofile(LockOn_Options.script_path.."UTILS\\dev_install.lua")
end
check_entry_version()
optionsEditor.setOption("plugins.RedK0d Clickable.Version",version)
dev_install()
function post_initialize()
		TIMER = 5
		print_message_to_user("[ RedK0d Clickable ] \n[ "..version.." ]\n[ " .. aircraft .." ]",10)
end
need_to_be_closed = false 

function update()
	
    if                  TIMER     >   0                                                               then
                        TIMER     =   TIMER - update_time_step
        if              TIMER     <=  0                                                               then
                        TIMER     =   0
						dofile(LockOn_Options.script_path.."UTILS\\show_support_window.lua")
					end
      
    end
end
