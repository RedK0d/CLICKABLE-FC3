dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
local gettext = require("i_18n")
_ = gettext.translate
show_element_boxes = true --connector debug
--dofile(LockOn_Options.script_path.."sounds.lua")
--dofile(LockOn_Options.common_script_path..'localizer.lua')

-- local gettext = require("i_18n")
-- _ = gettext.translate



elements = {}



elements["PNT_FLAPS_UP"]            = default_button("Flaps Up",                        devices.CLICKABLE,  device_commands.CLIC_FLAPS_UP                          )
elements["PNT_FLAPS_DOWN"]          = default_button("Flaps Landing Position",          devices.CLICKABLE,  device_commands.CLIC_FLAPS_DOWN                        )
elements["PNT_LANDING_LIGHTS"]      = default_button("Gear Light Near/Far/Off",         devices.CLICKABLE,  device_commands.CLIC_LANDING_LIGHTS                    )
elements["PNT_DIRECT_CONTROL"]      = default_button("ASC Direct Control (Cobra)",      devices.CLICKABLE,  device_commands.CLIC_DIRECT_CONTROL                    )
elements["PNT_FUEL_DUMP"]           = default_2_position_tumb("Fuel Dump",                  devices.CLICKABLE,  
                                                                                                            device_commands.CLIC_FUEL_DUMP_ON)
elements["PNT_AUTO_RESET"]          = default_button("Autopilot Reset",                 devices.CLICKABLE,  device_commands.CLIC_AUTO_STOP                         )
elements["PNT_AUTO_BARO"]           = default_button("Autopilot - Altitude And Roll Hold",                  devices.CLICKABLE,  device_commands.CLIC_AUTO_BARO     )
elements["PNT_AUTO_LEVEL"]          = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
elements["PNT_AUTO_NAV"]            = default_button("Autopilot - Route following",                         devices.CLICKABLE,  device_commands.CLIC_AUTO_ROUTE    )
elements["PNT_HUD_REP"]             = default_button("HDD, HUD Repeater Mode On/Off",                       devices.CLICKABLE,  device_commands.CLIC_HUD_REPEATER  )
elements["PNT_POWER"]               = default_button("Electric Power Switch",                               devices.CLICKABLE,  device_commands.CLIC_POWER         )
elements["PNT_CTM"]                 = default_button("Countermeasures Continuously Dispense",               devices.CLICKABLE,  device_commands.CLIC_CTM           )
elements["PNT_JAM"]                 = default_button("ECM",                                                 devices.CLICKABLE,  device_commands.CLIC_JAM           )
elements["PNT_ENG_L"]               = default_button("Engine Left Start",                                   devices.CLICKABLE,  device_commands.CLIC_ENG_L_START   )
elements["PNT_ENG_R"]               = default_button("Engine Right Start",                                  devices.CLICKABLE,  device_commands.CLIC_ENG_R_START   )
elements["PNT_ENG_LO"]              = default_button("Engine Left Stop",                                    devices.CLICKABLE,  device_commands.CLIC_ENG_L_STOP    )
elements["PNT_ENG_RO"]              = default_button("Engine Right Stop",                                   devices.CLICKABLE,  device_commands.CLIC_ENG_R_STOP    )
elements["PNT_HUD_FILTER"]          = default_button("HUD Color Filter On/Off",                             devices.CLICKABLE,  device_commands.CLIC_HUD_FILTER    )
elements["PNT_GEAR"]                = default_button("Landing Gear Up/Down",                                devices.CLICKABLE,  device_commands.CLIC_GEAR          )  
elements["PNT_CANOPY"]              = default_button("Canopy Open/Close",                                   devices.CLICKABLE,  device_commands.CLIC_CANOPY        )  
elements["PNT_NAVLIGHT"]            = default_button("Navigation lights",                                   devices.CLICKABLE,  device_commands.CLIC_NAVLIGHTS     )  
elements["PNT_LIGHT"]               = default_button("Illumination Cockpit",                                devices.CLICKABLE,  device_commands.CLIC_COCKPITLIGHT  )  
elements["PNT_JETTINSON"]           = default_button("Weapons Jettison",                                    devices.CLICKABLE,  device_commands.CLIC_JETTINSON     )  
elements["PNT_JETTINSON_EMER"]      = default_button("Weapons Emergency Jettison",                          devices.CLICKABLE,  device_commands.CLIC_JETTINSON_EMER)  
elements["PNT_SCAN_RDR"]            = default_button("Radar On/Off",                                        devices.CLICKABLE,  device_commands.CLIC_RADAR_ON_OFF  )
elements["PNT_SCAN_EOS"]            = default_button("Electro-Optical System On/Off",                       devices.CLICKABLE,  device_commands.CLIC_EOS_ON_OFF    )
elements["PNT_SCAN_L"]              = default_button("Scan Zone Left",                                      devices.CLICKABLE,  device_commands.CLIC_SCAN_L        )
elements["PNT_SCAN_R"]              = default_button("Scan Zone Right",                                     devices.CLICKABLE,  device_commands.CLIC_SCAN_R        )
elements["PNT_SCAN_U"]              = default_button("Scan Zone Up",                                        devices.CLICKABLE,  device_commands.CLIC_SCAN_U        )
elements["PNT_SCAN_D"]              = default_button("Scan Zone Down",                                      devices.CLICKABLE,  device_commands.CLIC_SCAN_D        )
elements["PNT_MODE_BVR"]            = default_button("Beyond Visual Range Mode",                            devices.CLICKABLE,  device_commands.CLIC_MODE_BVR      )                        
elements["PNT_MODE_VS"]             = default_button("Close Air Combat Vertical Scan Mode",                 devices.CLICKABLE,  device_commands.CLIC_MODE_VS       )                            
elements["PNT_MODE_OPT"]            = default_button("Close Air Combat Bore Mode",                          devices.CLICKABLE,  device_commands.CLIC_MODE_BORE     )                         
elements["PNT_MODE_HMT"]            = default_button("Close Air Combat HMD Helmet Mode",                    devices.CLICKABLE,  device_commands.CLIC_MODE_HMD      )   
elements["PNT_HUD_COL"]             = default_button("HUD Color",                                           devices.CLICKABLE,  device_commands.CLIC_HUD_COLOR     )                                                                                                                                   
elements["PNT_NAVPROGRAM"]          = default_button("Navigation Modes",                                    devices.CLICKABLE,  device_commands.CLIC_NAVMODES     )                                                                                                                                   
