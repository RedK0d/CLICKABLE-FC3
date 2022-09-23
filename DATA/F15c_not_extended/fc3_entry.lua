
if MAC then 
	return
end

self_ID = "Flaming Cliffs by Eagle Dynamics"
declare_plugin(self_ID,
{
image     	 = "FC3.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("Flaming Cliffs 3"),

fileMenuName = _("FC3"),
update_id        = "FC3",
registryPath	 = "Eagle Dynamics\\FC3",
version		 = __DCS_VERSION__,
state		 = "installed",
info		 = _("Flaming Cliffs 3 (FC3) is the continuation of the Flaming Cliffs series that features the F-15C, A-10A, Su-27, Su-33, MiG-29A, MiG-29S, Su-25T, and Su-25. Each aircraft provides an easy learning curve for new players and focuses on a broad range of aircraft rather than a detailed single aircraft. This 3rd version of Flaming Cliffs offers a new F-15C cockpit, improved flight dynamics, expanded combat area, new AI units, improved AI, a new F-15C campaign and a dozen single missions, and countless improvements to the series."),

Skins	= 
	{
		{
			name	= _("FC3"),
			dir		= "Skins/1"
		},
	},
Missions =
	{
		{
			name		    = _("Flaming Cliffs"),
			dir			    = "Missions",
            training_ids    = {EN = 'FC3_video_EN', RU = 'FC3_video_RU',},
		},
	},
	
LogBook =
	{
		{
			name		= _("F-15C"),
			type		= "F-15C",
		},
		{
			name		= _("A-10A"),
			type		= "A-10A",
		},
		{
			name		= _("MiG-29A"),
			type		= "MiG-29A",
		},
		{
			name		= _("MiG-29G"),
			type		= "MiG-29G",
		},
		{
			name		= _("MiG-29S"),
			type		= "MiG-29S",
		},
		{
			name		= _("Su-25"),
			type		= "Su-25",
		},
		{
			name		= _("Su-27"),
			type		= "Su-27",
		},
		{
			name		= _("Su-33"),
			type		= "Su-33",
		},
		{
			name		= _("J-11A"),
			type		= "J-11A",
		},	
	},


Options =
	{
		{
			name		= _("FC3"),
			nameId		= "FC3",
			dir			= "Options",
		},
	},
	
InputProfiles =
{
    ["a-10a"] = current_mod_path .. '/Input/a-10a',
    ["F-15C"] = current_mod_path .. '/Input/f-15c',
    ["mig-29"] = current_mod_path .. '/Input/mig-29',
    ["mig-29c"] = current_mod_path .. '/Input/mig-29c',
    ["mig-29g"] = current_mod_path .. '/Input/mig-29g',
    ["su-25"] = current_mod_path .. '/Input/su-25',
    ["su-27"] = current_mod_path .. '/Input/su-27',
    ["su-33"] = current_mod_path .. '/Input/su-33',
	["J-11A"] = current_mod_path .. '/Input/j-11a',

},

binaries 	 =
{
'FC3',
'A10A',
'F15',
'Su27',
'Su33',
'MiG29'
},


})
----------------------------------------------------------------------------------------

mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/F-15C-CPT-TEXTURES")
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/A-10A-CPT-TEXTURES")
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/SU-25-CPT-TEXTURES")
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/SU-27S-CPT-TEXTURES")
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/SU-33-CPT-TEXTURES")
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/MIG-29-13-CPT-TEXTURES")
mount_vfs_model_path    (current_mod_path ..  "/Cockpit/Shape")
mount_vfs_liveries_path (current_mod_path ..  "/Liveries")

local cfg_path = current_mod_path ..  "/FM/F15/config.lua"
dofile(cfg_path)
F15FM[1] 				= self_ID
F15FM[2] 				= 'F15'
F15FM.config_path 		= cfg_path
F15FM.old 				= true

mount_vfs_texture_path(current_mod_path ..  "/Skins/1/ME")--for simulator loading window

make_flyable('A-10A'	, current_mod_path..'/Cockpit/A10A/', {self_ID,'A10A',old = true}, current_mod_path..'/Comm/A-10A.lua')
make_flyable('F-15C'	, current_mod_path..'/Cockpit/KneeboardRight/',F15FM, current_mod_path..'/Comm/F-15C.lua')
make_flyable('MiG-29A'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'MiG29',old = true}, current_mod_path..'/Comm/MiG-29A.lua')
make_flyable('MiG-29G'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'MiG29',old = true}, current_mod_path..'/Comm/MiG-29G.lua')
make_flyable('MiG-29S'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'MiG29',old = true}, current_mod_path..'/Comm/MiG-29S.lua')
make_flyable('Su-25'	, current_mod_path..'/Cockpit/KneeboardRight/', nil, current_mod_path..'/Comm/Su-25.lua')
make_flyable('Su-27'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'Su27',old = true}, current_mod_path..'/Comm/Su-27.lua')
make_flyable('Su-33'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'Su33',old = true}, current_mod_path..'/Comm/Su-33.lua')
make_flyable('J-11A'	, current_mod_path..'/Cockpit/KneeboardLeft/', {self_ID,'Su27',old = 3	 }, current_mod_path..'/Comm/Su-27.lua')
----------------------------------------------------------------------------------------
plugin_done()
