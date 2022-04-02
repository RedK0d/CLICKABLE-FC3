dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
local gettext = require("i_18n")
_ = gettext.translate
local  aircraft = get_aircraft_type()
show_element_boxes = true --connector debug




elements = {}



--elements["PNT_TGT_L"]               = default_button("Target Designator Left",                              devices.CLICKABLE,  device_commands.CLIC_TGT_L         )
--elements["PNT_TGT_R"]               = default_button("Target Designator Right",                             devices.CLICKABLE,  device_commands.CLIC_TGT_R         )
--elements["PNT_TGT_U"]               = default_button("Target Designator Up",                                devices.CLICKABLE,  device_commands.CLIC_TGT_U         )
--elements["PNT_TGT_D"]               = default_button("Target Designator Down",                              devices.CLICKABLE,  device_commands.CLIC_TGT_D         )
--elements["PNT_TRIM_L"]              = default_button("Trim: Left Wing Down",                                devices.CLICKABLE,  device_commands.CLIC_TRIM_L        )
--elements["PNT_TRIM_R"]              = default_button("Trim: Right Wing Down",                               devices.CLICKABLE,  device_commands.CLIC_TRIM_R        )
--elements["PNT_TRIM_U"]              = default_button("Trim: Nose Down",                                       devices.CLICKABLE,  device_commands.CLIC_TRIM_U        )
--elements["PNT_TRIM_D"]              = default_button("Trim: Nose Up",                                       devices.CLICKABLE,  device_commands.CLIC_TRIM_D        )
elements["PNT_AUTO_BARO"]           = default_button("Autopilot - Altitude And Roll Hold",                  devices.CLICKABLE,  device_commands.CLIC_AUTO_BARO     )
elements["PNT_AUTO_RADAR"]          = default_button("Autopilot - Radar Altitude Hold",                     devices.CLICKABLE,  device_commands.CLIC_AUTO_RADAR    )
elements["PNT_AUTO_LEVEL"]          = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
elements["PNT_AUTO_NAV"]            = default_button("Autopilot - Route following",                         devices.CLICKABLE,  device_commands.CLIC_AUTO_ROUTE    )
elements["PNT_POWER"]               = default_button("Electric Power Switch",                               devices.CLICKABLE,  device_commands.CLIC_POWER         )
elements["PNT_JAM"]                 = default_button("ECM",                                                 devices.CLICKABLE,  device_commands.CLIC_JAM           )
elements["PNT_ENG_L"]               = default_button("Engine Left Start",                                   devices.CLICKABLE,  device_commands.CLIC_ENG_L_START   )
elements["PNT_ENG_R"]               = default_button("Engine Right Start",                                  devices.CLICKABLE,  device_commands.CLIC_ENG_R_START   )
elements["PNT_ENG_LO"]              = default_button("Engine Left Stop",                                    devices.CLICKABLE,  device_commands.CLIC_ENG_L_STOP    )
elements["PNT_ENG_RO"]              = default_button("Engine Right Stop",                                   devices.CLICKABLE,  device_commands.CLIC_ENG_R_STOP    )
elements["PNT_HUD_FILTER"]          = default_button("HUD Color Filter On/Off",                             devices.CLICKABLE,  device_commands.CLIC_HUD_FILTER    )
elements["PNT_HUD_BRT"]             = default_axis_limited("HUD Brightness Up/Down",                        devices.CLICKABLE,  device_commands.CLIC_HUD_BRT,nil, 0, 1,true,true)
elements["PNT_GEAR"]                = default_button("Landing Gear Up/Down",                                devices.CLICKABLE,  device_commands.CLIC_GEAR          )  
elements["PNT_GEAR"].updatable = true
elements["PNT_CANOPY"]              = default_button("Canopy Open/Close",                                   devices.CLICKABLE,  device_commands.CLIC_CANOPY        )  
elements["PNT_NAVLIGHT"]            = default_button("Navigation lights",                                   devices.CLICKABLE,  device_commands.CLIC_NAVLIGHTS     )  
elements["PNT_JETTINSON"]           = default_button("Weapons Jettison",                                    devices.CLICKABLE,  device_commands.CLIC_JETTINSON     )  
elements["PNT_JETTINSON_EMER"]      = default_button("Emergency Jettison",                                  devices.CLICKABLE,  device_commands.CLIC_JETTINSON_EMER)  
elements["PNT_HUD_COL"]             = default_button("HUD Color",                                           devices.CLICKABLE,  device_commands.CLIC_HUD_COLOR     )
elements["PNT_EMERGENCY_BRAKE"]     = default_button("Emergency Brake",                                     devices.CLICKABLE,  device_commands.CLIC_EMER_BRAKE    )     
elements["PNT_NOSE_WHEEL"]          = default_button("Nose Wheel Steerinmg",                                 devices.CLICKABLE,  device_commands.CLIC_NOSE_WHEEL    )     
elements["PNT_EJECT"]               = default_button("Eject (3 times)",                                     devices.CLICKABLE,  device_commands.CLIC_EJECT         )  
elements["PNT_RWR_MODE"]            = default_button("RWR/SPO Mode Select",                                 devices.CLICKABLE,  device_commands.CLIC_RWR_MODE      )  
elements["PNT_RWR_SOUND"]           = default_axis_limited("RWR/SPO Sound Signals Volume Up/Down",			devices.CLICKABLE,  device_commands.CLIC_RWR_SOUND,nil, 0, 1,true,true)
elements["PNT_WARNING_RST"]         = default_button("Audible Warning Reset",			                    devices.CLICKABLE,  device_commands.CLIC_WARNING_RST   )  
elements["PNT_CLOCK_F"]             = default_button("Flight Clock Start/Stop/Reset",		                devices.CLICKABLE,  device_commands.CLIC_CLOCK_F       )  
elements["PNT_CLOCK_E"]             = default_button("Elapsed Time Clock Start/Stop/Reset",		            devices.CLICKABLE,  device_commands.CLIC_CLOCK_E       )  
elements["PNT_ALTIMETER"]           = default_axis_limited("Altimeter Pressure Increase/Decrease",		    devices.CLICKABLE,  device_commands.CLIC_ALTIMETER,nil, 0, 1,true,true)
elements["PNT_WAYPOINT"]            = default_axis_limited("Next/Previous Waypoint, Airfield",              devices.CLICKABLE,  device_commands.CLIC_WAYPOINT      )  


if  aircraft=="Su-25T" then
elements["PNT_AUTO_ALT"]            = default_button("Autopilot - Attitude Hold",                           devices.CLICKABLE,  device_commands.CLIC_AUTO_ALT      )
elements["PNT_FLAPS_MULTI"]         = default_button("Flaps Up/Down",                                       devices.CLICKABLE,  device_commands.CLIC_FLAPS_MULTI   )
elements["PNT_FLAPS_LAND"]          = default_button("Flaps Landing Position",                              devices.CLICKABLE,  device_commands.CLIC_FLAPS_LAND    )
elements["PNT_JETTINSON_TANK"]      = default_button("Fuel Tanks Jettison",                                 devices.CLICKABLE,  device_commands.CLIC_JETTINSON_TANK)
elements["PNT_JAM_IR"]              = default_button("IR Jamming",                                          devices.CLICKABLE,  device_commands.CLIC_JAM_IR        )
elements["PNT_RIPPLE_INT"]          = default_axis_limited("Ripple Interval Increase/Decrease",             devices.CLICKABLE,  device_commands.CLIC_RIPPLE_INT    )
elements["PNT_RIPPLE_QT"]           = default_button("Ripple Quantity Select/SPPU select",                  devices.CLICKABLE,  device_commands.CLIC_RIPPLE_QT     )
elements["PNT_CUT_BURST"]           = default_button("Cut Of Burst select",                                 devices.CLICKABLE,  device_commands.CLIC_CUTBURST      )
elements["PNT_CHUTE_DEP"]           = default_button("Parachute Deployment",                                devices.CLICKABLE,  device_commands.CLIC_CHUTE_DEP     )  
elements["PNT_CHUTE_REL"]           = default_button("Parachute Release",                                   devices.CLICKABLE,  device_commands.CLIC_CHUTE_REL     )
--elements["PNT_AIRBRAKE"]            = default_button("Airbrake",                                            devices.CLICKABLE,  device_commands.CLIC_AIRBRAKE      )
--elements["PNT_CTM_ONCE"]            = default_button("Countermeasures Release",                             devices.CLICKABLE,  device_commands.CLIC_CTM_ONCE      )
--elements["PNT_UNLOCK"]              = default_button("Target Unlock",                                       devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
--elements["PNT_LOCK"]                = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )
--elements["PNT_LOCK_STICK"]          = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )
--elements["PNT_AUTO_LEVEL_STICK"]    = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
--elements["PNT_AUTO_RESET_STICK"]    = default_button("Autopilot Reset",                                     devices.CLICKABLE,  device_commands.CLIC_AUTO_STOP     )
elements["PNT_MIRROR_L"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_R"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_LANDING_LIGHTS"]      = default_button("Gear Light Near/Far/Off",                             devices.CLICKABLE,  device_commands.CLIC_LANDING_LIGHTS)
elements["PNT_LASER"]               = default_button("Laser Ranger On/Off",                                 devices.CLICKABLE,  device_commands.CLIC_LASER        )
elements["PNT_TV"]                  = default_button("LLTV On/Off",                                         devices.CLICKABLE,  device_commands.CLIC_TV            )
elements["PNT_TV_NIGHT"]            = default_button("LLTV Night Vision On/Off",                            devices.CLICKABLE,  device_commands.CLIC_TV_NIGHT      )
elements["PNT_RADAR"]               = default_button("ELINT Pod On/Off",                                    devices.CLICKABLE,  device_commands.CLIC_RADAR_ON_OFF  )
elements["PNT_NAVPROGRAM"]          = default_button("Navigation Modes",                                    devices.CLICKABLE,  device_commands.CLIC_NAVMODES      )  
elements["PNT_ZOOM"]                = default_axis_limited("Display Zoom In/Out",                           devices.CLICKABLE,  device_commands.CLIC_ZOOM,nil, 0, 1,true,true)
elements["PNT_MODE"]                = default_axis_limited("Master Modes Select",                           devices.CLICKABLE,  device_commands.CLIC_MODE)

end

if  aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S" then
elements["PNT_JETTINSON_TANK"]      = default_button("Fuel Tanks Jettison",                                 devices.CLICKABLE,  device_commands.CLIC_JETTINSON_TANK)
elements["PNT_FLAPS_MULTI"]         = default_button("Flaps Up/Down",                                       devices.CLICKABLE,  device_commands.CLIC_FLAPS_MULTI   )
elements["PNT_JETTINSON_EMER_BIS"]  = default_button("Emergency Jettison",                                  devices.CLICKABLE,  device_commands.CLIC_JETTINSON_EMER)  
elements["PNT_SCAN_RDR"]            = default_button("Radar On/Off",                                        devices.CLICKABLE,  device_commands.CLIC_RADAR_ON_OFF  )  
elements["PNT_RADAR_FREQ"]          = default_axis_limited("Radar Pulse Repeat Frequency Select",           devices.CLICKABLE,  device_commands.CLIC_RADAR_FREQ    )  
elements["PNT_SCAN_EOS"]            = default_button("Electro-Optical System On/Off",                       devices.CLICKABLE,  device_commands.CLIC_EOS_ON_OFF    ) 
elements["PNT_RADAR_MODE"]          = default_button("Radar RWS/TWS Mode Select",                           devices.CLICKABLE,  Keys.iCommandPlaneRadarChangeMode  )
elements["PNT_RADAR_MODE"].stop_action        = nil
elements["PNT_CTM_CHAFF"]           = default_button("Countermeasures Chaff Dispense",                      devices.CLICKABLE,  device_commands.CLIC_CTM_CHAFF     )
elements["PNT_CTM_FLARE"]           = default_button("Countermeasures Flares Dispense",                     devices.CLICKABLE,  device_commands.CLIC_CTM_FLARE     )
elements["PNT_AUTO_DAMPER"]         = default_button("Autopilot - Damper",                                  devices.CLICKABLE,  device_commands.CLIC_AUTO_DAMPER   )
elements["PNT_AUTO_ATT_HOLD"]       = default_button("Autopilot - Attitude Hold",                           devices.CLICKABLE,  device_commands.CLIC_AUTO_ALT      )
elements["PNT_AUTO_ALT_HOLD"]       = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
elements["PNT_AUTO_GCA"]            = default_button("Autopilot - Ground Collision Avoidance",              devices.CLICKABLE,  device_commands.CLIC_AUTO_GCA      )
--elements["PNT_AIRBRAKE"]            = default_button("Airbrake",                                            devices.CLICKABLE,  device_commands.CLIC_AIRBRAKE      )

--elements["PNT_CTM_ONCE"]            = default_button("Countermeasures Release",                             devices.CLICKABLE,  device_commands.CLIC_CTM_ONCE      )
--elements["PNT_UNLOCK"]              = default_button("Target Unlock",                                       devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
--elements["PNT_LOCK"]                = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )
--elements["PNT_UNLOCK_STICK"]        = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
--elements["PNT_AUTO_LEVEL_STICK"]    = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
--elements["PNT_AUTO_RESET_STICK"]    = default_button("Autopilot Reset",                                     devices.CLICKABLE,  device_commands.CLIC_AUTO_STOP     )
elements["PNT_MIRROR_U"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_L"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_R"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_CHUTE_DEP"]           = default_button("Parachute Deployment",                                devices.CLICKABLE,  device_commands.CLIC_CHUTE_DEP     )  
elements["PNT_CHUTE_REL"]           = default_button("Parachute Release",                                   devices.CLICKABLE,  device_commands.CLIC_CHUTE_REL     )  
elements["PNT_CHUTE_REL_BIS"]       = default_button("Parachute Release",                                   devices.CLICKABLE,  device_commands.CLIC_CHUTE_REL     )  
elements["PNT_DSP_ZOOMIN"]          = default_button("Display Zoom In",			                            devices.CLICKABLE,  device_commands.CLIC_DSP_ZOOMIN    )  
elements["PNT_DSP_ZOOMOUT"]         = default_button("Display Zoom Out",		                            devices.CLICKABLE,  device_commands.CLIC_DSP_ZOOMOUT   )  
elements["PNT_LIGHT"]               = default_button("Illumination Cockpit",                                devices.CLICKABLE,  device_commands.CLIC_COCKPITLIGHT  )  
elements["PNT_CTM"]                 = default_button("Countermeasures Continuously Dispense",               devices.CLICKABLE,  device_commands.CLIC_CTM           )
elements["PNT_NAVPROGRAM"]          = default_axis_limited("Navigation Modes",                              devices.CLICKABLE,  device_commands.CLIC_NAVMODES      )  
elements["PNT_MODE"]                = default_axis_limited("Master Modes Select",                           devices.CLICKABLE,  device_commands.CLIC_MODE)
end
    

if  aircraft=="Su-33" or aircraft=="Su-27"or aircraft=="J-11A"   then
elements["PNT_AUTO_RESET"]          = default_button("Autopilot Reset",                                     devices.CLICKABLE,  device_commands.CLIC_AUTO_STOP     )
elements["PNT_FUEL_DUMP"]           = default_2_position_tumb("Fuel Dump",                                  devices.CLICKABLE,  device_commands.CLIC_FUEL_DUMP_ON  )
elements["PNT_FLAPS_UP"]            = default_button("Flaps Up",                                            devices.CLICKABLE,  device_commands.CLIC_FLAPS_UP      )
elements["PNT_FLAPS_DOWN"]          = default_button("Flaps Landing Position",                              devices.CLICKABLE,  device_commands.CLIC_FLAPS_DOWN    )
elements["PNT_SCAN_RDR"]            = default_button("Radar On/Off",                                        devices.CLICKABLE,  device_commands.CLIC_RADAR_ON_OFF  )
elements["PNT_SCAN_EOS"]            = default_button("Electro-Optical System On/Off",                       devices.CLICKABLE,  Keys.iCommandPlaneEOSOnOff,nil, 0, 1,true,true)
elements["PNT_SCAN_EOS"].stop_action        = nil
elements["PNT_RADAR_MODE"]          = default_button("Radar RWS/TWS Mode Select",                           devices.CLICKABLE,  Keys.iCommandPlaneRadarChangeMode    )
elements["PNT_RADAR_MODE"].stop_action        = nil
elements["PNT_RADAR_FREQ"]          = default_button("Radar Pulse Repeat Frequency Select",                 devices.CLICKABLE,  device_commands.CLIC_RADAR_FREQ    )  
elements["PNT_DIRECT_CONTROL"]      = default_button("ASC Direct Control (Cobra)",                          devices.CLICKABLE,  device_commands.CLIC_ASC_DC        )
--elements["PNT_AIRBRAKE"]            = default_button("Airbrake",                                            devices.CLICKABLE,  device_commands.CLIC_AIRBRAKE      )
--elements["PNT_CTM_ONCE"]            = default_button("Countermeasures Release",                             devices.CLICKABLE,  device_commands.CLIC_CTM_ONCE      )
--elements["PNT_UNLOCK"]              = default_button("Target Unlock",                                       devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
--elements["PNT_LOCK"]                = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )
--elements["PNT_STATION"]             = default_button("Weapon Change",                                       devices.CLICKABLE,  device_commands.CLIC_STATION       )
--elements["PNT_AUTO_LEVEL_STICK"]    = default_button("Autopilot - Transition To Level Flight Control",      devices.CLICKABLE,  device_commands.CLIC_AUTO_LEVEL    )
--elements["PNT_AUTO_RESET_STICK"]    = default_button("Autopilot Reset",                                     devices.CLICKABLE,  device_commands.CLIC_AUTO_STOP     )
elements["PNT_MIRROR_U"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_L"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_R"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_RWR_SOUND_BIS"]       = default_axis_limited("RWR/SPO Sound Signals Volume Up/Down",			devices.CLICKABLE,  device_commands.CLIC_RWR_SOUND,nil, 0, 1,true,true)
elements["PNT_DSP_ZOOMIN"]          = default_button("Display Zoom In",			                            devices.CLICKABLE,  device_commands.CLIC_DSP_ZOOMIN    )  
elements["PNT_DSP_ZOOMOUT"]         = default_button("Display Zoom Out",		                            devices.CLICKABLE,  device_commands.CLIC_DSP_ZOOMOUT   )  
elements["PNT_HUD_REP"]             = default_button("HDD, HUD Repeater Mode On/Off",                       devices.CLICKABLE,  device_commands.CLIC_HUD_REPEATER  )
elements["PNT_ENG_INLET"]           = default_button("Engine Inlet Grids Auto/Off",                         devices.CLICKABLE,  device_commands.CLIC_ENG_INLET     )  
elements["PNT_SCAN_L"]              = default_button("Scan Zone Left",                                      devices.CLICKABLE,  device_commands.CLIC_SCAN_L        )
elements["PNT_SCAN_R"]              = default_button("Scan Zone Right",                                     devices.CLICKABLE,  device_commands.CLIC_SCAN_R        )
elements["PNT_SCAN_U"]              = default_button("Scan Zone Up",                                        devices.CLICKABLE,  device_commands.CLIC_SCAN_U        )
elements["PNT_SCAN_D"]              = default_button("Scan Zone Down",                                      devices.CLICKABLE,  device_commands.CLIC_SCAN_D        )
elements["PNT_LIGHT"]               = default_button("Illumination Cockpit",                                devices.CLICKABLE,  device_commands.CLIC_COCKPITLIGHT  )  
elements["PNT_CTM"]                 = default_button("Countermeasures Continuously Dispense",               devices.CLICKABLE,  device_commands.CLIC_CTM           )
elements["PNT_LANDING_LIGHTS"]      = default_button("Gear Light Near/Far/Off",                             devices.CLICKABLE,  device_commands.CLIC_LANDING_LIGHTS)
elements["PNT_NAVPROGRAM"]          = default_axis_limited("Navigation Modes",                              devices.CLICKABLE,  device_commands.CLIC_NAVMODES      )  
elements["PNT_MODE"]                = default_axis_limited("Master Modes Select",                           devices.CLICKABLE,  device_commands.CLIC_MODE)

                                                                                                                              




end
if  aircraft=="Su-27"or aircraft=="J-11A"   then
elements["PNT_CHUTE_DEP"]           = default_button("Parachute Deployment",                                devices.CLICKABLE,  device_commands.CLIC_CHUTE_DEP    )  
elements["PNT_CHUTE_REL"]           = default_button("Parachute Release",                                   devices.CLICKABLE,  device_commands.CLIC_CHUTE_REL    )  
--elements["PNT_AA_MODES_STICK"]      = default_button("AA Modes Select",                                     devices.CLICKABLE,  device_commands.CLIC_MODE_AA       )



end
--[Su-33] Specifics
if  aircraft=="Su-33"                       then
elements["PNT_AUTO_GCA"]            = default_button("Autopilot - Ground Collision Avoidance",              devices.CLICKABLE,  device_commands.CLIC_AUTO_GCA      )                                                                                                                                  
elements["PNT_AUTO_THRUST"]         = default_button("Autothrust",                                          devices.CLICKABLE,  device_commands.CLIC_AUTOTHRUST    )                                                                                                                                  
elements["PNT_AUTO_THRUSTI"]        = default_button("Autothrust - Increase Velocity",                      devices.CLICKABLE,  device_commands.CLIC_AUTOTHRUST_I  )                                                                                                                                  
elements["PNT_AUTO_THRUSTD"]        = default_button("Autothrust - Decrease Velocity",                      devices.CLICKABLE,  device_commands.CLIC_AUTOTHRUST_D  )                                                                                                                                  
elements["PNT_ASC_REFUELING"]       = default_button("ASC Refueling Mode",                                  devices.CLICKABLE,  device_commands.CLIC_ASC_REFUEL    )  
elements["PNT_FUEL_PROBE"]          = default_button("Refueling Boom",                                      devices.CLICKABLE,  device_commands.CLIC_RBOOM         )  
elements["PNT_REFUELING_LIGHTS"]    = default_button("Aerial Refueling Lights",                             devices.CLICKABLE,  device_commands.CLIC_RLIGHTS       ) 
elements["PNT_TAIL_HOOK"]           = default_button("Tail Hook",                                           devices.CLICKABLE,  device_commands.CLIC_TAILHOOK      ) 
elements["PNT_TAIL_HOOK_EMER"]      = default_button("Emergency Tail Hook",                                 devices.CLICKABLE,  device_commands.CLIC_TAILHOOK      )
elements["PNT_WINGS_F"]             = default_button("Folding Wings",                                       devices.CLICKABLE,  device_commands.CLIC_WINGSF        )
elements["PNT_AA_MODES_STICK"]      = default_button("AA Modes Select",                                     devices.CLICKABLE,  device_commands.CLIC_MODE_AA       )

end
--[Su-25] Specifics
if  aircraft=="Su-25"                       then
elements["PNT_RIPPLE_INT"]          = default_axis_limited("Ripple Interval Increase/Decrease",             devices.CLICKABLE,  device_commands.CLIC_RIPPLE_INT    )
elements["PNT_RIPPLE_QT"]           = default_button("Ripple Quantity Select/SPPU select",                  devices.CLICKABLE,  device_commands.CLIC_RIPPLE_QT     )
elements["PNT_CUT_BURST"]           = default_button("Cut Of Burst select",                                 devices.CLICKABLE,  device_commands.CLIC_CUTBURST      )
elements["PNT_LANDING_LIGHTS"]      = default_button("Gear Light Near/Far/Off",                             devices.CLICKABLE,  device_commands.CLIC_LANDING_LIGHTS)
elements["PNT_JETTINSON_TANK"]      = default_button("Fuel Tanks Jettison",                                 devices.CLICKABLE,  device_commands.CLIC_JETTINSON_TANK)
elements["PNT_CHUTE"]               = default_button("Parachute Deployment/Release",                        devices.CLICKABLE,  device_commands.CLIC_CHUTE         )  
--elements["PNT_CTM_CHAFF"]           = default_button("Countermeasures Chaff Dispense",                      devices.CLICKABLE,  device_commands.CLIC_CTM_CHAFF     )
--elements["PNT_CTM_FLARE"]           = default_button("Countermeasures Flares Dispense",                     devices.CLICKABLE,  device_commands.CLIC_CTM_FLARE     )
elements["PNT_FLAPS_MULTI"]         = default_button("Flaps Up/Down",                                       devices.CLICKABLE,  device_commands.CLIC_FLAPS_MULTI   )
elements["PNT_FLAPS_LAND"]          = default_button("Flaps Landing Position",                              devices.CLICKABLE,  device_commands.CLIC_FLAPS_LAND    )
elements["PNT_ASP-17"]              = default_axis_limited("ASP-17 Glass Up/Down",                          devices.CLICKABLE,  device_commands.CLIC_ASP           )
--elements["PNT_FLAPS_MULTI_BIS"]     = default_button("Flaps Up/Down",                                       devices.CLICKABLE,  device_commands.CLIC_FLAPS_MULTI   )
--elements["PNT_AIRBRAKE"]            = default_button("Airbrake",                                            devices.CLICKABLE,  device_commands.CLIC_AIRBRAKE      )
elements["PNT_NAVPROGRAM"]          = default_button("Navigation Modes",                                    devices.CLICKABLE,  device_commands.CLIC_NAVMODES      )  
elements["PNT_CTM_ONCE"]            = default_button("Countermeasures Dispense",                            devices.CLICKABLE,  device_commands.CLIC_CTM_ONCE      )
elements["PNT_CTM"]                 = default_button("Countermeasures Continuously Dispense",               devices.CLICKABLE,  device_commands.CLIC_CTM           )
elements["PNT_LASER"]               = default_button("Laser Ranger On/Off",                                 devices.CLICKABLE,  device_commands.CLIC_LASER        )
elements["PNT_LASER_FRONT"]         = default_button("Laser Ranger On/Off",                                 devices.CLICKABLE,  Keys.iCommandPlaneLaserRangerOnOff         )
elements["PNT_LASER_FRONT"].stop_action        = nil
elements["PNT_GRID"]                = default_button("Gunsight Reticle Switch",                             devices.CLICKABLE,  device_commands.CLIC_GRID          )
elements["PNT_MIRROR_L"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )
elements["PNT_MIRROR_R"]            = default_button("Toggle Mirrors",                                      devices.CLICKABLE,  device_commands.CLIC_MIRROR        )


elements["PNT_TARGET_UD"]           = default_axis_limited("Target Designator Up/Down",                     devices.CLICKABLE,  device_commands.CLIC_TARGET_UD,0,0,100/15,false, false, {-1,1})
elements["PNT_TARGET_UD"].cycle = false
elements["PNT_TARGET_LR"]           = default_axis_limited("Target Designator Left/Right",                  devices.CLICKABLE,  device_commands.CLIC_TARGET_LR,0,0,100/15,false, false, {-1,1})
elements["PNT_TARGET_LR"].cycle = false
elements["PNT_MODE"]                = default_axis_limited("Master Modes Select",                           devices.CLICKABLE,  device_commands.CLIC_MODE)
elements["PNT_UNLOCK"]              = default_button("Target Unlock",                                       devices.CLICKABLE,  device_commands.CLIC_LOCK_REL      )
elements["PNT_LOCK"]                = default_button("Target Lock",                                         devices.CLICKABLE,  device_commands.CLIC_LOCK          )

end

