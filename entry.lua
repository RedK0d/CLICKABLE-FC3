
declare_plugin("CLICKABLE-FC3_Module",
{
	dirName		  = current_mod_path,
	displayName   = "CLICKABLE-FC3_Module",
	shortName	  = "CLICKABLE-FC3_Module",
	fileMenuName  = "CLICKABLE-FC3_Module",
	state		  = "installed",
	developerName = "RedK0d",
	info		  = "CLICKABLE-FC3_Module",
	
	load_immediately = true,
	binaries	 = {},
	Options =
	{
		{
			name		= _("CLICKABLE-FC3_Module"),
            nameId		= "CLICKABLE-FC3_Module",
            dir			= "Options",
            CLSID		= "{FC3 CLICKABLE}"
		},
	},
})
mount_vfs_texture_path  (current_mod_path ..  "/Textures")
mount_vfs_model_path    (current_mod_path ..  "/Shapes")

local path 		= current_mod_path..'/Cockpit/Scripts/'


		

		
add_plugin_systems('CLICKABLE-FC3_Module','*',path,
	{
	
	--Alpha Implemented
	["J-11A"] 				= {enable_options_key_for_unit = 'J11a_enabled'},
	["Su-27"] 				= {enable_options_key_for_unit = 'Su27_enabled'},
	["Su-33"] 				= {enable_options_key_for_unit = 'Su33_enabled'},
	["Su-25T"] 				= {enable_options_key_for_unit = 'Su25t_enabled'},
	["MiG-29A"] 			= {enable_options_key_for_unit = 'Mig29a_enabled'},
	["MiG-29G"] 			= {enable_options_key_for_unit = 'Mig29g_enabled'},
	["MiG-29S"] 			= {enable_options_key_for_unit = 'Mig29s_enabled'},
	
	--Not yet implemented
	["F-15C"]				= {enable_options_key_for_unit='dontuseit'},
	["A-10A"]				= {enable_options_key_for_unit='dontuseit'},	--Which version ?
	["A-10C"]				= {enable_options_key_for_unit='dontuseit'},	--Which version ?
	["A-10C II"]			= {enable_options_key_for_unit='dontuseit'},	--Which version ?
	["Su-25"]				= {enable_options_key_for_unit='dontuseit'},	--Which version ?
	["Su-25A"] 				= {enable_options_key_for_unit='dontuseit'},	--Which version ?

	--Excluded, list to be enlarged to avoid conflicts 	
	["AH-64D_BLK_II"]		= {enable_options_key_for_unit='dontuseit'},
	["AH-6"]				= {enable_options_key_for_unit='dontuseit'},
	["Rafale_C"]			= {enable_options_key_for_unit='dontuseit'},
	["Rafale_M"]			= {enable_options_key_for_unit='dontuseit'},
	["Rafale_B"]			= {enable_options_key_for_unit='dontuseit'},
	["Rafale_A_S"]			= {enable_options_key_for_unit='dontuseit'},
	["Bell-47"]				= {enable_options_key_for_unit='dontuseit'},
	["AV8BNA"]				= {enable_options_key_for_unit='dontuseit'},
	["SpitfireLFMkIXCW"]	= {enable_options_key_for_unit='dontuseit'},
	["SpitfireLFMkIX"]		= {enable_options_key_for_unit='dontuseit'},
	["F-5E-3"]				= {enable_options_key_for_unit='dontuseit'},
	["Mi-8MT"]				= {enable_options_key_for_unit='dontuseit'},
	["F-14"]				= {enable_options_key_for_unit='dontuseit'},
	["F-14A-135-GR"]		= {enable_options_key_for_unit='dontuseit'},
	["Yak-52"]				= {enable_options_key_for_unit='dontuseit'},
	["Bf-109K-4"]			= {enable_options_key_for_unit='dontuseit'},
	["Christen Eagle II"]	= {enable_options_key_for_unit='dontuseit'},
	["MiG-19P"]				= {enable_options_key_for_unit='dontuseit'},
	["MiG-21Bis"]			= {enable_options_key_for_unit='dontuseit'},
	["MosquitoFBMkVI"]		= {enable_options_key_for_unit='dontuseit'},
	["P-47D-30"]			= {enable_options_key_for_unit='dontuseit'},
	["P-47D-40"]			= {enable_options_key_for_unit='dontuseit'},
	["P-47D-30bl1"]			= {enable_options_key_for_unit='dontuseit'},
	["SA342L"]				= {enable_options_key_for_unit='dontuseit'},
	["SA342M"]				= {enable_options_key_for_unit='dontuseit'},
	["SA342Minigun"]		= {enable_options_key_for_unit='dontuseit'},
	["SA342Mistral"]		= {enable_options_key_for_unit='dontuseit'},
	["A-4E-C"]				= {enable_options_key_for_unit='dontuseit'},
	["F-22A"]				= {enable_options_key_for_unit='dontuseit'},
	["Hercules"]			= {enable_options_key_for_unit='dontuseit'},
	["T-45"]				= {enable_options_key_for_unit='dontuseit'},
	["A-29B"]				= {enable_options_key_for_unit='dontuseit'},
	["C-101CC"]				= {enable_options_key_for_unit='dontuseit'},
	["C-101EB"]				= {enable_options_key_for_unit='dontuseit'},
	["F-5E"]				= {enable_options_key_for_unit='dontuseit'},
	["F-86F"]				= {enable_options_key_for_unit='dontuseit'},
	["F-14B"]				= {enable_options_key_for_unit='dontuseit'},
	["F/A-18C"]				= {enable_options_key_for_unit='dontuseit'},
	["FW-190D9"]			= {enable_options_key_for_unit='dontuseit'},
	["FW-190A8"]			= {enable_options_key_for_unit='dontuseit'},
	["I-16"]				= {enable_options_key_for_unit='dontuseit'},
	["JF-17"]				= {enable_options_key_for_unit='dontuseit'},
	["Ka-50"]				= {enable_options_key_for_unit='dontuseit'},
	["L-39C"]				= {enable_options_key_for_unit='dontuseit'},
	["L-39ZA"]				= {enable_options_key_for_unit='dontuseit'},
	["M-2000C"]				= {enable_options_key_for_unit='dontuseit'},
	["Mi-24P"]				= {enable_options_key_for_unit='dontuseit'},
	["Mi-8MTV2"]			= {enable_options_key_for_unit='dontuseit'},
	["MiG-15bis"]			= {enable_options_key_for_unit='dontuseit'},
	["DH.98"]				= {enable_options_key_for_unit='dontuseit'},
	["P-51D-30-NA"]			= {enable_options_key_for_unit='dontuseit'},
	["P-51D"]				= {enable_options_key_for_unit='dontuseit'},
	["UH-1H"]				= {enable_options_key_for_unit='dontuseit'},
	["F-16C_50"]			= {enable_options_key_for_unit='dontuseit'},
	["FA-18C_hornet"]		= {enable_options_key_for_unit='dontuseit'},
	["AJS37"]				= {enable_options_key_for_unit='dontuseit'},
	["MOSQUITOFBMKVI"]		= {enable_options_key_for_unit='dontuseit'},
	["VSN_F104G"]			= {enable_options_key_for_unit='dontuseit'},
	["VSN_F104S"]			= {enable_options_key_for_unit='dontuseit'},
	["F-117"]				= {enable_options_key_for_unit='dontuseit'},
	["JAS39Gripen"]			= {enable_options_key_for_unit='dontuseit'},
	["JAS39Gripen_AG"]		= {enable_options_key_for_unit='dontuseit'},
	["Su-30MKI"]			= {enable_options_key_for_unit='dontuseit'},
	["Su-30MKA"]			= {enable_options_key_for_unit='dontuseit'},
	["Su-30MKM"]			= {enable_options_key_for_unit='dontuseit'},
	["Su-30SM"]				= {enable_options_key_for_unit='dontuseit'},
	["Su-30M2"]				= {enable_options_key_for_unit='dontuseit'},
	["Su-30MKK"]			= {enable_options_key_for_unit='dontuseit'},
	["J-16"]				= {enable_options_key_for_unit='dontuseit'},
	["UH-60L"]				= {enable_options_key_for_unit='dontuseit'},
	["F-86F Sabre"]			= {enable_options_key_for_unit='dontuseit'},
	["A-10C_2"]				= {enable_options_key_for_unit='dontuseit'},
	["TF-51D"]				= {enable_options_key_for_unit='dontuseit'},

	
	}
)

plugin_done()
