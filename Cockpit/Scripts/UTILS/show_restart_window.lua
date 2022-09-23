
dofile(LockOn_Options.script_path.."devices.lua")
local 		version 		= 	get_plugin_option_value("RedK0d Clickable", "Version", "local")
local 		update_time_step	= 	5 
local 		bin_dir				=	lfs.realpath(lfs.currentdir().."bin\\")
make_default_activity(update_time_step)

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
local 		MsgWindow 			= 	require("MsgWindow")
local 		Picture				= 	require('Picture')
local 		dxgui				= 	require('dxgui')
local 		Skin				= 	require('Skin')
local 		cdata				= 	{
			instructions		= 	"\n\nTo complete installation, please click OK and restart DCS",
			title				= 	"[ RedK0d Clickable "..version.." ]",
			yes					= 	"OK",
			picture				= 	Picture.new(get_dcs_plugin_path("RedK0d Clickable").."\\Skins\\icon 76x76.png"),
									}
local 		function 				notallfeatures()
	local 	handler 			= 	MsgWindow.error(cdata.instructions2,cdata.title,cdata.ok)
			handler:show()
end									
local 		handler 			= 	MsgWindow.user(cdata.instructions, cdata.title,cdata.picture,cdata.yes)
function 							handler:onChange(buttonText)
    if 		buttonText 			== 	cdata.yes 			then
			handler:close()
			
			os.execute("taskkill /F /im DCS.EXE")
	elseif 	buttonText == cdata.no then
			handler:close()
            notallfeatures()
    end
end
function 						handler:onClose()
			os.execute("taskkill /F /im DCS.EXE")

end

    		handler:show()


 


