self_ID = "F-15C"
declare_plugin(self_ID,
{
image     	 = "FC3.bmp",
installed 	 = true, -- if false that will be place holder , or advertising
dirName	  	 = current_mod_path,
displayName  = _("F-15C"),
developerName = _("Belsimtek"),

fileMenuName = _("F-15C"),
update_id        = "F-15C",
registryPath     = "Eagle Dynamics\\F15",
version		 = __DCS_VERSION__.." beta",
state		 = "installed",
info		 = _("The McDonnell Douglas / Boeing F-15C Eagle is a highly maneuverable fourth-generation twin-engine all-weather tactical fighter. It has been the air superiority fighter mainstay of U.S. and NATO forces since the 1970s and will remain as such well into the 21st century.Air superiority is achieved through high maneuverability at a wide range of airspeeds and altitudes, as well as advanced weapons and avionics."),
rules = 
{	
	["Flaming Cliffs by Eagle Dynamics"] = { required = false , disabled = true }
},

Skins	= 
	{
		{
			name	= "F-15C",
			dir		= "Skins/1"
		},
	},
Missions =
	{
		{
			name		    = _("F-15C"),
			dir			    = "Missions",
            training_ids    = {EN = 'F-15C_video_EN', RU = 'F-15C_video_RU',},
		},
	},
	
LogBook =
	{
		{
			name		= _("F-15C"),
			type		= "F-15C",
		},
	},
Options =
    {
        {
            name		= _("F-15C"),
            nameId		= "F-15C",
            dir			= "Options",
            CLSID		= "{F-15C options}"
        },
    },      
	
InputProfiles =
{
    ["F-15C"] = current_mod_path .. '/Input',
},

binaries =
{
'F15CCWS',
'F15'
},


})
----------------------------------------------------------------------------------------
mount_vfs_texture_path  (current_mod_path ..  "/Cockpit/Textures/F-15C-CPT-TEXTURES")
mount_vfs_model_path    (current_mod_path ..  "/Cockpit/Shape")
mount_vfs_liveries_path (current_mod_path ..  "/Liveries")

local cfg_path = current_mod_path ..  "/FM/F15/config.lua"
dofile(cfg_path)
F15FM[1] 				= self_ID
F15FM[2] 				= 'F15'
F15FM.config_path 		= cfg_path
F15FM.old 				= true

mount_vfs_texture_path(current_mod_path ..  "/Skins/1/ME")--for simulator loading window
MAC_flyable('F-15C', current_mod_path..'/Cockpit/KneeboardRight/',nil, current_mod_path..'/Comm/F-15C.lua')
----------------------------------------------------------------------------------------
plugin_done()
