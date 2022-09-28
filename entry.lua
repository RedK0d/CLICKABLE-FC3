declare_plugin("RedK0d Clickable",
{
	installed 	  	= 	true,
	dirName		  	= 	current_mod_path,
	displayName   	= 	"RedK0d Clickable",
	shortName	  	= 	"RedK0d Clickable",
	fileMenuName  	= 	"RedK0d Clickable",
	version			=	"v1.1.1b-beta",
	state		  	= 	"installed",
	developerName 	= 	"RedK0d",
	info		  	= 	"RedK0d Clickable",
	
	load_immediately = true,
	binaries	 = {},
	Skins	=
	{
		{
			name	= ("RedK0d Clickable"),
			dir		= "Skins"
		},
	},
	Options =
	{
		{
			name		= ("RedK0d Clickable"),
            nameId		= "RedK0d Clickable",
            dir			= "Options",
            CLSID		= "{FC3 CLICKABLE}"
		},
	},
	
})


local path 		= current_mod_path..'/Cockpit/Scripts/'
mount_vfs_texture_path  (current_mod_path ..  "/Textures")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")

		

		
add_plugin_systems('CLICKABLE-FC3_Module','*',path,
	{
	
	--Alpha Implemented
	["J-11A"] 					= {enable_options_key_for_unit = 'J11a_enabled'},
	["Su-27"] 					= {enable_options_key_for_unit = 'Su27_enabled'},
	["Su-33"] 					= {enable_options_key_for_unit = 'Su33_enabled'},
	["Su-25T"] 					= {enable_options_key_for_unit = 'Su25t_enabled'},
	["MiG-29A"] 				= {enable_options_key_for_unit = 'Mig29a_enabled'},
	["MiG-29G"] 				= {enable_options_key_for_unit = 'Mig29g_enabled'},
	["MiG-29S"] 				= {enable_options_key_for_unit = 'Mig29s_enabled'},
	["Su-25"] 					= {enable_options_key_for_unit = 'Su25_enabled'},
	["A-10A"]					= {enable_options_key_for_unit = 'A10a_enabled'},
	["F-15C"]					= {enable_options_key_for_unit = 'F15c_enabled'},
	["TEST"]					= {enable_options_key_for_unit = 'Version'},
	}
)

plugin_done()
