
declare_plugin("SU-27-CLICKABLE_Module",
{
	dirName		  = current_mod_path,
	displayName   = "SU-27-CLICKABLE_Module",
	shortName	  = "SU-27-CLICKABLE_Module",
	fileMenuName  = "SU-27-CLICKABLE_Module",
	state		  = "installed",
	developerName = "RedK0d",
	info		  = "SU-27-CLICKABLE_Module",
	
	load_immediately = true,
	binaries	 = {},
	Options =
	{
		{
			name		= _("SU-27-CLICKABLE_Module"),
            nameId		= "SU-27-CLICKABLE_Module",
            dir			= "Options",
            CLSID		= "{SU 27 CLICKABLE}"
		},
	},
})
mount_vfs_texture_path  (current_mod_path ..  "/Textures")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")

local path = current_mod_path..'/Cockpit/Scripts/'
 


		
add_plugin_systems('SU-27-CLICKABLE_Module','*',path,
	{
	
	
	["J-11A"] = {enable_options_key_for_unit = 'J11a_enabled'},
	--["MiG-29A"] = {enable_options_key_for_unit = 'Mig29a_enabled'},
	--["MiG-29G"] = {enable_options_key_for_unit = 'Mig29g_enabled'},
	--["MiG-29S"] = {enable_options_key_for_unit = 'Mig29s_enabled'},
	--["Su-25"] = {enable_options_key_for_unit = 'Su25_enabled'},
	--["Su-25T"] = {enable_options_key_for_unit = 'Su25t_enabled'},
	["Su-27"] = {enable_options_key_for_unit = 'Su27_enabled'},
	--["Su-33"] = {enable_options_key_for_unit = 'Su33_enabled'},
	
	
	
	}
)
plugin_done()
