dofile(LockOn_Options.script_path.."clickable_defs.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."devices.lua")
local gettext = require("i_18n")
_ = gettext.translate
local  aircraft = get_aircraft_type()
--show_param_handles_list()   
--[[
    -RADIO,-BASE,ECS_READY,FCS_READY,ENCS_READY,MCS_READY,LICS_READY,TEST,ENG_STARTER_L
]]

show_element_boxes			= false
show_element_parent_boxes	= false
show_tree_boxes				= false
show_other_pointers			= false
show_indicator_borders		= false
enable_commands_log         = false
use_click_and_pan_mode      = false
local rotvalue      = (100/15)/10
elements = {}

--[[
    Non extended animation
elements["TMB_FUEL_EMERG_TRANS"]                = default_button("Fuel Tanks Jettison",                         devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_JETTINSON_TANK,434)
elements["TMB_FUEL_EXT_TRANS"]                  = default_button("Fuel Tanks Jettison",                         devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_JETTINSON_TANK2,433)
elements["TMB_FUEL_OPEN/CLOSE"]                 = default_button("Refueling port",                              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_RPORT) 

]]



elements["RADAR_SPL-MODE"]                      = default_axis_limited("Radar Spl Modes",                       devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_SPL_MODE,0,0,100/15,false, false, {0,1})
elements["RADAR_MODE_SEL"]                      = default_axis_limited("Radar Master Modes Select",             devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_MODE_SEL,0,0,100/15,false, false, {0,1})
elements["RADAR_AZ_SCAN"]                       = default_axis_limited("Radar Scan Zone Increase/Decrease",     devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_AZ_SCAN       )
elements["RADAR_EL_SCAN"]                       = default_axis_limited("Radar Scan Zone Up/Down",               devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_EL_SCAN,0,0,100/15,false, false, {0,1})
elements["RADAR_EL_SCAN"].cycle = false
elements["RADAR_RANGE"]                         = default_axis_limited("Radar Display Zoom In/Out",             devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_RANGE,0,0,100/15,false, false, {0,1})
elements["RADAR_RANGE"].cycle = false
elements["RADAR_POWER"]                         = default_axis_limited("Radar Power",                           devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_RADAR_POWER,0,0,100/15,false, false, {0,1})
elements["STEER_MODE"]                          = default_axis_limited("Navigation Modes",                      devices.RADAR_CONTROL_SYSTEM,       device_commands.CLIC_NAVMODES      )  
elements["CMD_MODE"]                            = default_axis_limited("Countermeasures Dispenser Mode",        devices.COUNTERMEASURES_SYSTEM,     device_commands.CMD_MODE,482,0, rotvalue,false,false,{0,0.4})

elements["MIRROR_2"]                            = default_button("Toggle Mirrors",                              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_MIRROR        )
elements["MIRROR_1"]                            = default_button("Toggle Mirrors",                              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_MIRROR        )
elements["MIRROR_3"]                            = default_button("Toggle Mirrors",                              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_MIRROR        )
elements["HUD_SET_SYMBOL_BRIGHTNESS"]           = default_axis_limited("HUD Brightness Up/Down",                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_HUD_BRT,  340, 0.0, 0.075,{0,1})
elements["HUD_SET_SYMBOL_BRIGHTNESS"].cycle     = false
elements["HUD_SET_STBY-RTCL_BRIGHTNESS"]        = default_axis_limited("HUD Brightness Up/Down",                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._341,  341, 0.0, 0.075, {0,1})
elements["HUD_SET_STBY-RTCL_BRIGHTNESS"].cycle  = false
elements["HUD_SET_RTCL-DEPR"]                   = default_axis_limited("HUD Color",                             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_HUD_COLOR_F15,342, 0.0, 0.5, {0,1})
elements["HUD_SET_STBY-RTCL_BRIGHTNESS"].cycle  = false
elements["RDR_SYM-BRT"]                         = default_axis_limited("Radar Symbology Brightness/nNot in use",devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._343,343, 0, 0.66)
elements["CONT_BRT_OFF"]                        = default_axis_limited("Contrast Brightness/Off/nNot in use",   devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._344,344, 0, 0.66)
elements["RWR_INT"]                             = default_button_axis("RWR\n(Click):Mode Select\n(Scroll):Signals Volume Up/Down",
                                                                                                                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_RWR_MODE,
                                                                                                                                                    device_commands.CLIC_RWR_SOUND,nil,345)  
elements["RWR_INT"].relative  = {false,true}
elements["RWR_INT"].stop_action    = nil
elements["EMERG_VENT"]                          = default_button_tumb("Emergency Vent\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._346,device_commands._346,346)
elements["PULL"]                                = default_button_tumb("Pull\nNot in use",                       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._347,device_commands._347,347)
elements["TMB_OXY_EMERG-NORM-TEST"]             = default_3_position_tumb("Oxygen Flow\nNot in use",            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._360,  360)
elements["OXYGEN_Norm-100%"]                    = default_3_position_tumb("Oxygen Flow Adjustment\nNot in use", devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._361,  361)
elements["OXYGEN_SUPPLY"]                       = default_3_position_tumb("Oxygen Supply\nNot in use",          devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._362,  362)

elements["HEADING_SET"]                         = default_axis_limited("Heading Set/nNot in use",               devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._271,271, 0, 0.66,false,false,{0,1})
elements["COURSE_SET"]                          = default_axis_limited("Next/Previous Waypoint, Airfield",      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_WAYPOINT,272, 0, 0.66,false,true,{0,1})
elements["Attitude_reference_selector"]         = default_axis_limited("Attitude Reference Selector/nNot in use",  
                                                                                                                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._273,273, 0, 0.66)
elements["Pitch_trim_knob"]                     = default_axis_limited("Pitch/Trim /snNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._274,274, 0, 0.66)
elements["MFD_0"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._300,300, 1)
elements["MFD_1"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._301,301, 1)
elements["MFD_2"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._302,302, 1)
elements["MFD_3"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._303,303, 1)
elements["MFD_4"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._304,304, 1)
elements["MFD_5"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._305,305, 1)
elements["MFD_6"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._306,306, 1)
elements["MFD_7"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._307,307, 1)
elements["MFD_8"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._308,308, 1)
elements["MFD_9"]                               = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._309,309, 1)
elements["MFD_10"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._310,310, 1)
elements["MFD_11"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._311,311, 1)
elements["MFD_12"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._312,312, 1)
elements["MFD_13"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._313,313, 1)
elements["MFD_14"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._314,314, 1)
elements["MFD_15"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._315,315, 1)
elements["MFD_16"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._316,316, 1)
elements["MFD_17"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._317,317, 1)
elements["MFD_18"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._318,318, 1)
elements["MFD_19"]                              = default_button("",                                            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._319,319, 1)
elements["MFD_SEL-JETT"]                        = default_button_axis("Weapons Jettison\n(Click):Jettison\n(Scroll):Selector",
                                                                                                                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_JETTINSON,device_commands._320,nil,320)  
elements["MFD_SEL-JETT"].class     = {class_type.BTN, class_type.LEV}
elements["MFD_SEL-JETT"].relative  = {false,true}
elements["MFD_SEL-JETT"].arg_lim   = {{0, 1}, {-0.33, 0.33}}
elements["MFD_SEL-JETT"].stop_action    = nil
elements["MFD_SEL-JETT"].gain                = {1.0, 0.66} 
elements["MFD_SEL-JETT"].cycle      = false                                                                                                                        
elements["MFD_DAY-NIGHT"]                       = default_axis_limited("MFD Off/Day/Night \nNot in use",        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._321,  321, 0.0, 0.666666,false,false,{0.066,0.2})
elements["MFD_BRT+"]                            = default_button("MFD BRT +\nNot in use",                       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._322,322, 1)
elements["MFD_BRT-"]                            = default_button("MFD BRT +\nNot in use",                       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._322,322, -1)                                                                                                                                                                                                                              
elements["MFD_CTRS+"]                           = default_button("MFD CTRS +\nNot in use",                      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._323,323, 1)
elements["MFD_CTRS-"]                           = default_button("MFD CTRS -\nNot in use",                      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._323,323, -1)                                                                                                                                                                                                                              
elements["TMB_CONT_MAN-AUTO"]                   = default_2_position_tumb("CONT Man/Auto\nNot in use",          devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._326,326, inversed_)
elements["TMB_HUD_SET_BRT"]                     = default_2_position_tumb("BRT Auto/Man\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._327,327, inversed_)
elements["TMB_HUD_SET_SYM"]                     = default_2_position_tumb("SYM Norm/Rej\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._328,328, inversed_)
elements["TMB_HUD_SET_RTCL"]                    = default_2_position_tumb("RTCL Dstb/Caged\nNot in use",        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._329,329, inversed_)
elements["TMB_HUD_SET_CAMERA"]                  = default_2_position_tumb("CAMERA Trig/Run*\nNot in use",       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._330,330, inversed_) 
elements["TMB_HUD_SET_DAY-NIGHT"]               = default_2_position_tumb("Video Record\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._331,331, inversed_)                                                                                                        
elements["TMB_VIDEO_RECORD_ON-OFF"]             = default_2_position_tumb("Video Record\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._332,332, inversed_)
elements["TMB_CAMERA_HUD-VSD"]                  = default_2_position_tumb("Camera Hud\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._333,333, inversed_)
elements["FUEL_QTY"]                            = default_button_axis("Fuel Indicator\n(Click):Quantity Test\n(Scroll):Quantity Selector",
                                                                                                                devices.CLICKABLE_GENERIC_SYSTEM,   Keys.iCommandPlaneFSQuantityIndicatorTest,
                                                                                                                                                    Keys.iCommandPlaneFSQuantityIndicatorSelectorMAIN)
elements["FUEL_QTY"].class     = {class_type.TUMB, class_type.LEV}
elements["FUEL_QTY"].relative  = {false,true}
elements["FUEL_QTY"].arg_lim   = {{0, 1}, {0, 1}}
elements["FUEL_QTY"].stop_action    = {Keys.iCommandPlaneFSQuantityIndicatorSelectorMAIN, 0}
elements["STEER_MODE"]                          = default_axis_limited("Navigation Modes",                      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_NAVMODES      )  
      
elements["CHANNEL_FP"]                          = default_axis_limited("Radio Channel Selector\nNot in use",    devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RCHAN,334, 0, 0.1,false,true)
elements["MAIN_FREQ-1"]                         = default_axis_limited("Radio Main Freq-1 Selector\nNot in use",devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RFREQ_1,335, 0, 0.1,false,true,{0,1})
elements["MAIN_FREQ-2"]                         = default_axis_limited("Radio Main Freq-2 Selector\nNot in use",devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RFREQ_2,336, 0, 0.1,false,true,{0,1})
elements["MAIN_FREQ-3"]                         = default_axis_limited("Radio Main Freq-3 Selector\nNot in use",devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RFREQ_3,337, 0, 0.1,false,true,{0,1})
elements["VOL_FP"]                              = default_axis_limited("Radio Vol \nNot in use",                devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RVOL,  338, 0.0, 0.3,false,false,{0.66,1})
elements["VOL_FP"].cycle                        = false
elements["UHF-1_SELECTOR"]                      = default_axis_limited("UHF-1 Selector\nNot in use",    
                                                                                                                devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RUHF,  339, 0.0, 0.66,true,false,{0,0.5})
                                                                                                        
elements["TMB_ANTI-ICE_WINDSHIELD"]             = default_2_position_tumb("Anti Ice \nWindShield\nNot in use",  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._371,371)
elements["TMB_ANTI-ICE_PITOT_HEAT"]             = default_2_position_tumb("Anti Ice \nPitot Heat\nNot in use",  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._372,372)
elements["TMB_ANTI-ICE_ENG_HEAT"]               = default_3_position_tumb("Anti Ice \nEngine Heat\nNot in use", devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._373,373)
elements["TMB_ANTI-FOG"]                        = default_3_position_tumb("Anti Fog \nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._374,374) 
elements["BTN_ECS_OXY_TEST"]                    = default_button("Oxygen Test\nNot in use",                     devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._375,375) 
elements["NAV_CONTROL_MARK"]                    = default_button("Nav Control\nMark\nNot in use",               devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._377,377)
elements["NAV_CONTROL_OFLY_FRZ"]                = default_button("Nav Control\nOfly Frz\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._378,378)                                                                                                         
elements["NAV_CONTROL_UPDATE"]                  = default_button("Nav Control\nUpdate\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._379,379)                                                                                                         
elements["NAV_CONTROL_SEL-O/S"]                 = default_button("Nav Control\nSel\nO/S\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._380,380)                                                                                                         
elements["NAV_CONTROL_1"]                       = default_button("Nav Control\n1\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._381,381)                                                                                                         
elements["NAV_CONTROL_2"]                       = default_button("Nav Control\n2\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._382,382)                                                                                                         
elements["NAV_CONTROL_3"]                       = default_button("Nav Control\n3\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._383,383)
elements["NAV_CONTROL_4"]                       = default_button("Nav Control\n4\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._384,384)
elements["NAV_CONTROL_5"]                       = default_button("Nav Control\n5\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._385,385)
elements["NAV_CONTROL_6"]                       = default_button("Nav Control\n6\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._386,386)
elements["NAV_CONTROL_7"]                       = default_button("Nav Control\n7\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._387,387)
elements["NAV_CONTROL_8"]                       = default_button("Nav Control\n8\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._388,388)
elements["NAV_CONTROL_9"]                       = default_button("Nav Control\n9\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._389,389)
elements["NAV_CONTROL_0"]                       = default_button("Nav Control\n0\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._390,390)
elements["NAV_CONTROL_CLR"]                     = default_button("Nav Control\nClear\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._391,391)
elements["NAV_CONTROL_ENTER"]                   = default_button("Nav Control\nEnter\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._392,392)
elements["NAV_CONTROL_RDY"]                     = default_button("Nav Control\nRdy\nNot in use",                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._393,393)
elements["NAV_CONTROL_INT"]                     = default_axis_limited("Nav Control\nInt\nNot in use",          devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._394,394,0, 0.1,false,true,{0,1})                                                                                                      
elements["TMB_TEWS_ICS_ON-OFF"]                 = default_2_position_tumb("Tews\nIcs\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._400,400)
elements["TMB_TEWS_SET-1"]                      = default_2_position_tumb("Tews\nSet-1\nNot in use",            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._401,401)
elements["TMB_TEWS_SET-2"]                      = default_2_position_tumb("Tews\nSet-2\nNot in use",            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._402,402)
elements["TMB_TEWS_SET-3"]                      = default_2_position_tumb("Tews\nSet-3\nNot in use",            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._403,403)
elements["TMB_TEWS_RWR"]                        = default_2_position_tumb("Tews\nRwr\nOn/Off\nNot in use",      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._404,404)
elements["TMB_TEWS_EWWS_ON-OFF"]                = default_2_position_tumb("Tews\nEwws\nOn/Off\nNot in use",     devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._405,405)
elements["TMB_TEWS_EWWS_TONE-DEFEAT"]           = default_2_position_tumb("Tews\nEwws\nTone/Defeat\nNot in use",devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._406,406)
elements["TMB_CABIN_TEMP_CONTR_AUTO-OFF-MAN"]   = default_3_position_tumb("Temp \nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._407,407) 
elements["TMB_INTERIOR_LT-TEST"]                = default_2_position_tumb("Interior\nLT Test \nNot in use",     devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._408,408) 
--Verif post_initialize args start
elements["TMB_CMD_DISP_SEL"]                    = default_3_position_tumb("COUNTERMEASURES_SYSTEM\nDisp Sel",   devices.COUNTERMEASURES_SYSTEM,     device_commands.CMD_SEL,410) 
elements["TMB_COMPASS_N-S"]                     = default_2_position_tumb("Compass\nN-S\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._413,413)
elements["COMPASS_FAST-ERECT"]                  = default_button("Compass\nFast Erect\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._414,414)
elements["COMPASS_TO-SYNC"]                     = default_axis_limited("Compass\nSync\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._415,415,0, 0.1,false,true,{0,1})                                                                                                      
elements["COMPASS_LAT"]                         = default_axis_limited("Compass\nLat\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._416,416,0, 0.1,false,true,{0,1})                                                                                                      
elements["COMPASS_COMP-DG-SLAVED"]              = default_axis_limited("Compass\nConfig\nNot in use",           devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._417,417,0, 0.66,false,false,{0,0.2})

elements["TMB_CAS_T/O"]                         = default_button("T/O Trim",                                    devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_TAKEOFFTRIMF15 )
elements["TMB_EW_ICS"]                          = default_3_position_tumb("Ics\nNot in use",                    devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._436,436) 
elements["TMB_EW_PODS"]                         = default_2_position_tumb("Pods\nNot in use",                   devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._437,437) 
elements["TMB_IFF_MASTER"]                      = default_3_position_tumb("Iff Master\nNot in use",             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._440,440) 
elements["TMB_IFF_MODE-4_A-B-OUT"]              = default_3_position_tumb("Iff Mode 4\nA B Out\nNot in use",    devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._441,441) 
elements["TMB_IFF_MODE-4_HOLD-NORM-ZERO"]       = default_3_position_tumb("Iff Mode 4\nHold Norm Zero\nNot in use",
                                                                                                                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._442,442)
elements["TMB_IFF_MC"]                          = default_2_position_tumb("Iff Mc\nNot in use",                 devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._443,443)
elements["TMB_IFF_MC"].arg_lim                  = {{-1, 1}, {-1, 1}}                                                                                                                
elements["TMB_IFF_M3/A"]                        = default_2_position_tumb("Iff M3/A\nNot in use",               devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._444,444)
elements["TMB_IFF_M3/A"].arg_lim                = {{-1, 1}, {-1, 1}}                                                                                                                
elements["TMB_IFF_M2"]                          = default_2_position_tumb("Iff M2\nNot in use",                 devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._445,445)
elements["TMB_IFF_M2"].arg_lim                  = {{-1, 1}, {-1, 1}}    
elements["TMB_IFF_M1"]                          = default_2_position_tumb("Iff M1\nNot in use",                 devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._446,446)
elements["TMB_IFF_M1"].arg_lim                  = {{-1, 1}, {-1, 1}}    
elements["TMB_IFF_AUDIO-REC"]                   = default_3_position_tumb("Iff Audio Rec\nNot in use",          devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._447,447)
elements["TMB_IFF_SEL"]                         = default_3_position_tumb("Iff Sel\nNot in use",                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._448,448)
elements["TMB_THROTTLE"]                        = default_3_position_tumb("Not in use",                         devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._449,449)
elements["TMB_ILS_TCN_X-Y"]                     = default_2_position_tumb("ILS TCN X-Y\nNot in use",            devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._450,450)
elements["TMB_ILS_TCN_X-Y"].arg_lim             = {{-1, 1}, {-1, 1}} 
elements["TMB_RADIO-2_TRANSMIT"]                = default_button("Radio Transmit\nNot in use",                  devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RCOMMENU,452, 1)
elements["TMB_RADIO-2_DIS_FREQ"]                = default_2_position_tumb("Radio Dis Freq\nNot in use",         devices.RADIO_CONTROL_SYSTEM,       device_commands._453,453)
elements["TMB_RADIO-2_DIS_FREQ"].arg_lim        = {{-1, 1}, {-1, 1}} 
elements["TMB_RADIO-2_CHAN_SET"]                = default_2_position_tumb("Radio Chan Set\nNot in use",         devices.RADIO_CONTROL_SYSTEM,       device_commands._454,454)
elements["TMB_RADIO-2_CHAN_SET"].arg_lim        = {{-1, 1}, {-1, 1}}
elements["TMB_VOL_R1_ADF"]                      = default_2_position_tumb("Radio R1 Adf\nNot in use",           devices.RADIO_CONTROL_SYSTEM,       device_commands._455,455)
elements["TMB_VOL_R1_ADF"].arg_lim              = {{-1, 1}, {-1, 1}}  
elements["TMB_VOL_RADIO_1"]                     = default_2_position_tumb("Radio 1 G Rec/Tone\nNot in use",     devices.RADIO_CONTROL_SYSTEM,       device_commands._456,456)
elements["TMB_VOL_RADIO_1"].arg_lim             = {{-1, 1}, {-1, 1}}  
elements["TMB_VOL_R1_ANT"]                      = default_2_position_tumb("Radio 1 Ant Upper/Lower\nNot in use",devices.RADIO_CONTROL_SYSTEM,       device_commands._457,457)
elements["TMB_VOL_R1_ANT"].arg_lim              = {{-1, 1}, {-1, 1}} 
elements["TMB_VOL_R2_ANT"]                      = default_2_position_tumb("Radio 2 Ant Upper/Lower\nNot in use",devices.RADIO_CONTROL_SYSTEM,       device_commands._458,458)
elements["TMB_VOL_R2_ANT"].arg_lim              = {{-1, 1}, {-1, 1}}   
elements["VOL_TEWS_LAUNCH_DISABLE"]             = default_button("TEWS\nVol Launch Disable\nNot in use",        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._459,459)
elements["TMB_ISC_RADIO"]                       = default_3_position_tumb("Ics\nRadio Override\nNot in use",    devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._460,460) 
elements["TMB_POWER"]                           = default_2_position_tumb("Power\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._461,461)
elements["TMB_POWER"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_DELAY"]                           = default_2_position_tumb("Delay\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._462,462)
elements["TMB_DELAY"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_RSET-RCALL"]                      = default_2_position_tumb("Rcall\nNot in use",                  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._463,463)
elements["TMB_RSET-RCALL"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["AVIONICS_INITIATE"]                   = default_button("Avionics Initiate\nNot in use",               devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._464,464)
elements["AVIONICS_CC_RSET"]                    = default_button("Avionics CC Rset\nNot in use",                devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._465,465)
elements["TMB_GND_PWR_1"]                       = default_3_position_tumb("Electric Power Switch",              devices.ELEC_CONTROL_SYSTEM,        device_commands.GND_EPS    ,466) 
elements["TMB_GND_PWR_2"]                       = default_2_position_tumb("Power 2\nNot in use",                devices.ELEC_CONTROL_SYSTEM,        device_commands.GND_PWR_2,467) 
elements["TMB_GND_PWR_2"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_GND_PWR_3"]                       = default_2_position_tumb("Power 3\nNot in use",                devices.ELEC_CONTROL_SYSTEM,        device_commands.GND_PWR_3,468) 
elements["TMB_GND_PWR_3"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_GND_PWR_4"]                       = default_2_position_tumb("Power 4\nNot in use",                devices.ELEC_CONTROL_SYSTEM,        device_commands.GND_PWR_4,469) 
elements["TMB_GND_PWR_4"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_GND_PWR_CC"]                      = default_2_position_tumb("Power CC\nNot in use",               devices.ELEC_CONTROL_SYSTEM,        device_commands.GND_PWR_CC,470) 
elements["TMB_GND_PWR_CC"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["NAV_CONTROL_DATA_SELECT"]             = default_axis_limited("Nav Control\nData Select\nNot in use",  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._471,471,0, 0.66,true,false,{-0.1,0.7})
elements["NAV_CONTROL_MODE"]                    = default_axis_limited("Nav Control\nMode\nNot in use",         devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._472,472,0, 0.66,true,false,{-0.2,0.7})
elements["TEMP_COLD/HOT"]                       = default_axis_limited("Temp\nCabin Temp Control\nNot in use",  devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._473,473,0, 0.66/10,false,false,{0,0.1})
elements["TEMP_AIR_SOURCE"]                     = default_axis_limited("Temp\nAir Source\nNot in use",          devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._474,474,0, rotvalue,false,false,{0,1})
elements["INTERIOR_L-CONSOLE"]                  = default_axis_limited("Interior\nL Console\nNot in use",       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._475,475,0, rotvalue,false,false,{0,1})
elements["INTERIOR_R-CONSOLE"]                  = default_axis_limited("Interior\nR Console\nNot in use",       devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._476,476,0, rotvalue,false,false,{0,1})
elements["INTERIOR_AUX-INST"]                   = default_axis_limited("Interior\nAux Inst\nNot in use",        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._477,477,0, rotvalue,false,false,{0,1})
elements["INTERIOR_FLT-INST"]                   = default_axis_limited("Illumination Cockpit",                  devices.LIGHT_CONTROL_SYSTEM,       device_commands.LIGHT_COCKPIT,478, 0, 1,false,false,{0.1,0.6})
elements["INTERIOR_ENG-INST"]                   = default_axis_limited("Interior\nEng Inst\nNot in use",        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._479,479,0, rotvalue,false,false,{0,1})
elements["INTERIOR_WARNING_CAUTION"]            = default_axis_limited("Interior\nWarning\nNot in use",         devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._480,480,0, rotvalue,false,false,{0,0.2})
elements["INTERIOR_STORM_FLOOD"]                = default_axis_limited("Interior\nStrom Flood\nNot in use",     devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._481,481,0, rotvalue,false,false,{0,1})
elements["ILS_TCN_VOL"]                         = default_axis_limited("Ils/Tcn\nVol\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._483,483,0, rotvalue/2,false,false,{0,1})
elements["ILS_TCN_VOL"]                         = default_axis_limited("Ils/Tcn\nVol\nNot in use",              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._483,483,0, rotvalue/2,false,false,{0,1})
elements["EXT_LT_POSITION"]                     = default_axis_limited("Position Lights",                       devices.LIGHT_CONTROL_SYSTEM,       device_commands.LIGHT_POS,484,0, rotvalue,false,false,{0,0.7})
elements["EXT_LT_FORMATION"]                    = default_axis_limited("Formation Lights",                      devices.LIGHT_CONTROL_SYSTEM,       device_commands.LIGHT_FORM,485,0, rotvalue,false,false,{0,0.6})
elements["RADIO-2_MODE"]                        = default_axis_limited("Radio Mode Selector \nNot in use",      devices.RADIO_CONTROL_SYSTEM,       device_commands.CLIC_RMODE,  486, 0.0, 0.66,true,false,{-0.20,0.20})
elements["TMB_MISC_TAXI-LIGHT"]                 = default_button("Ldg/Off/Taxi Light",                          devices.LIGHT_CONTROL_SYSTEM,       device_commands.LIGHT_LDG_TAXI)
elements["TMB_EXT-LT_ANTI-COLLISION"]           = default_2_position_tumb("Anti Collision Lights",              devices.LIGHT_CONTROL_SYSTEM,       device_commands.LIGHT_ANTICOL,451)
elements["TMB_EXT-LT_ANTI-COLLISION"].arg_lim   = {{-1, 1}, {-1, 1}} 
elements["TMB_INTERIOR_STBY_INST"]              = tricked_button_tumb_2arg("Interior\nStby Inst",               devices.LIGHT_CONTROL_SYSTEM,       device_commands._409,device_commands._180,409,180)                  --Function to be reviewed, only found way to implement both arguments in the same function, buggy on the right click.
elements["TBM_Wheels"]                          = default_button("Landing Gear Up/Down",                        devices.CLICKABLE_GENERIC_SYSTEM,   device_commands.CLIC_GEAR          )  
elements["TBM_Wheels"].updatable = true
elements["MODE_OP-LD-RV"]                       = default_axis_limited("Mode\nNot in use",                      devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._495,495,0, rotvalue,false,false,{0,0.2})
elements["SELECTOR"]                            = default_axis_limited("Selector \nNot in use",                 devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._496,496,0, rotvalue/10,false,false,{0,1})       --Code the test system, find the lighting arguments
elements["A/G"]                                 = default_button("A/G\nNot in use",                             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._505,505)
elements["ADI"]                                 = default_button("ADI\nNot in use",                             devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._506,506)
elements["VI"]                                  = default_button("VI\nNot in use",                              devices.CLICKABLE_GENERIC_SYSTEM,   device_commands._507,507)

--elements["TMB_ENGINE_GEN_L"]                    = default_2_position_tumb("Left Engine Genenerator",            devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_GEN_L,364)
--elements["TMB_ENGINE_GEN_R"]                    = default_2_position_tumb("Right Engine Genenerator",           devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_GEN_R,365)
--elements["TMB_ENGINE_CONTR_L"]                  = default_2_position_tumb("Left Engine Control",                devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_ECC_L,366)
--elements["TMB_ENGINE_CONTR_L"].arg_lim          = {{-1, 1}, {-1, 1}}
--elements["TMB_ENGINE_CONTR_R"]                  = default_2_position_tumb("Right Engine Control",               devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_ECC_R,367)
--elements["TMB_ENGINE_CONTR_R"].arg_lim          = {{-1, 1}, {-1, 1}}
--elements["TMB_ENGINE_EMERG_GEN"]                = default_3_position_tumb("Emergency Engine Genenerator",       devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_GEN_E,368)
--elements["TMB_ENGINE_EXT_PWR"]                  = default_3_position_tumb("Engine External Power",              devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_EXT_PWR,369)
--elements["TMB_ENGINE_STARTER"]                  = default_2_position_tumb("Engine Starter",                     devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_STARTER,370)
--elements["TMB_ENGINE_STARTER"].arg_lim          = {{-1, 1}, {-1, 1}}
elements["L_ENG_MASTER"]                        = default_animated_lever("Left Engine Start",                  devices.ENGINES_CONTROL_SYSTEM,     Keys.iCommandLeftEngineStart)
elements["R_ENG_MASTER"]                        = default_animated_lever("Right Engine Start",                 devices.ENGINES_CONTROL_SYSTEM,     Keys.iCommandRightEngineStart)
--elements["JET_FUEL_STARTER"]                    = default_2_position_tumb("Jet Fuel Starter",                   devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_JFS,503)
--elements["TMB_ENG_START_L"]                     = default_3_position_tumb("Engine Left\nFuel Flow\nNot in use",            devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_FF_L,411)
--elements["TMB_ENG_START_L"].arg_lim             = {{-1, 1}, {-1, 1}} 
--elements["TMB_ENG_START_R"]                     = default_3_position_tumb("Engine Right\nFuel Flow\nNot in use",            devices.ENGINES_CONTROL_SYSTEM,     device_commands.ENG_FF_R,412) 
--elements["TMB_ENG_START_R"].arg_lim             = {{-1, 1}, {-1, 1}}
--elements["TMB_FUEL_CONF_TANK"]                  = default_3_position_tumb("Fuel Control Panel\nTank",           devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_TANK,429) 
--elements["TMB_FUEL_CONF_TANK"].arg_lim          = {{-1, 1}, {-1, 1}}
--elements["TMB_FUEL_CTR"]                        = default_3_position_tumb("Fuel Control Panel\nCenter",         devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_CENTER,430) 
--elements["TMB_FUEL_CTR"].arg_lim                = {{-1, 1}, {-1, 1}}
--elements["TMB_FUEL_WING"]                       = default_3_position_tumb("Fuel Control Panel\nWing",           devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_WINGS,431) 
--elements["TMB_FUEL_WING"].arg_lim               = {{-1, 1}, {-1, 1}}
--elements["TMB_FUEL_DUMP/NORM"]                  = default_2_position_tumb("Fuel Control Panel\nDump",           devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_DUMP,432) 
--elements["TMB_FUEL_DUMP/NORM"].arg_lim          = {{-1, 1}, {-1, 1}}
--elements["TMB_FUEL_EXT_TRANS"]                  = default_2_position_tumb("Fuel Control Panel\nExternal Transfer",
--                                                                                                                devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_EXTTR,433)
--elements["TMB_FUEL_EXT_TRANS"].arg_lim          = {{-1, 1}, {-1, 1}} 
--elements["TMB_FUEL_EMERG_TRANS"]                = default_2_position_tumb("Fuel Control Panel\nTank Emergency Tranfert",
--                                                                                                              devices.FUEL_CONTROL_SYSTEM,        device_commands.FUEL_EMERTR,434)
--elements["TMB_FUEL_EMERG_TRANS"].arg_lim        = {{-1, 1}, {-1, 1}} 
elements["TMB_FUEL_OPEN/CLOSE"]                 = default_button("Refueling port",                     devices.CLICKABLE_GENERIC_SYSTEM,        device_commands.CLIC_RPORT) 
--elements["TMB_MISC_ANTI-SKID"]                  = default_2_position_tumb("Misc\nAnti Skid",                    devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_ANTISKID,424)
--elements["TMB_MISC_ANTI-SKID"].arg_lim          = {{-1, 1}, {-1, 1}} 
--elements["TMB_MISC_INLET-RAMP-R"]               = default_2_position_tumb("Misc\nInlet Ramp Right",             devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_INLET_R,425)
--elements["TMB_MISC_INLET-RAMP-R"].arg_lim       = {{-1, 1}, {-1, 1}} 
--elements["TMB_MISC_INLET-RAMP-L"]               = default_2_position_tumb("Misc\nInlet Ramp Left",              devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_INLET_L,426)
--elements["TMB_MISC_INLET-RAMP-L"].arg_lim       = {{-1, 1}, {-1, 1}}
--elements["TMB_MISC_ROLL-RATIO"]                 = default_2_position_tumb("Misc\nRoll Ratio",                   devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_ROLL,427)
--elements["TMB_MISC_ROLL-RATIO"].arg_lim         = {{-1, 1}, {-1, 1}}
elements["TMB_Master_Arm"]                      = default_2_position_tumb("Master Arm",                         devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_MASTERARM,124)
elements["TMB_Master_Arm"].arg_lim              = {{-1, 1}, {-1, 1}}
elements["EMERGENCY_BRAKE"]                     = default_2_position_tumb("Emergency Brakes",                   devices.MISC_CONTROL_SYSTEM,        device_commands.MISC_EBRAKES,502)
elements["EMERGENCY_BRAKE"].arg_lim             = {{-1, 1}, {-1, 1}}
                                                                                                                                                  