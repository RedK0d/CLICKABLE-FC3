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
local 		version 			= 	get_plugin_option_value("RedK0d Clickable", "Version", "local")
local 		io, os, error 		= 	io, os, error
local 		cdata				= 	{
			patreon				=	"Patreon",
			paypal				=	"Paypal",
			shop				=	"Shop",
			nothanks			=	"No",
			support				=	"[ RedK0d Clickable "..version.." ]",
			supporttext			=	"If you like this mod, please support it. 3 possibilities to support.",
			picture				= 	Picture.new(get_dcs_plugin_path("RedK0d Clickable").."\\Skins\\icon 76x76.png"),
									}
									

local 		handler 		= 	MsgWindow.user(cdata.supporttext, cdata.support,cdata.picture,cdata.patreon,cdata.paypal,cdata.shop, cdata.nothanks)
local 		users_params 	= 	get_dcs_plugin_path("RedK0d Clickable").."\\Cockpit\\Scripts\\UTILS\\users_params.txt"
local 		t 				= 	os.date("*t")
function 						handler:onChange(buttonText)
	local file = io.open(users_params, 'w')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
	
	if 		buttonText 			== 	cdata.patreon 			then
			fileContent[1]  =  	'Patreon Visit'
			fileContent[2]	=	t.yday
			os.open_uri("www.patreon.com/RedK0d")
	elseif 	buttonText 			== 	cdata.paypal 			then
			fileContent[1]  =  	'Paypal Visit'
			fileContent[2]	=	t.yday
			os.open_uri("www.paypal.com/donate/?hosted_button_id=8RA626VEJD2SC")
	elseif 	buttonText 			== 	cdata.shop 				then
			fileContent[1]  =  	'Shop Visit'
			fileContent[2]	=	t.yday
			os.open_uri("https://redk0d.myshopify.com/")
	elseif 	buttonText 			== 	cdata.nothanks			then
			fileContent[1]  =  	'No'
	end
	file = io.open(users_params, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function 						handler:onClose()
		local file = io.open(users_params, 'w')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
			fileContent[1]  =  	'No'
	file = io.open(users_params, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function 						read_users_params()
	local file = io.open(users_params, 'r')
	if 	not file 							then
	handler:show()
	else
   		local fileContent = {}
   		for line in file:lines() do
       	table.insert (fileContent, line)
   		end
   	io.close(file)
		if 	fileContent[1]  ==  	'No' or
			fileContent[1]  ==  	nil		then
			handler:show()		
		end
		if 	tonumber(fileContent[2]) +7	<=		t.yday  					then
			handler:show()
		end
		if 	t.yday						<		tonumber(fileContent[2]) 	then
			handler:show()
		end
	end
end
read_users_params()

