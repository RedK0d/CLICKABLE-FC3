
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
dofile(LockOn_Options.script_path.."dump.lua")


local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
sensor_data = get_base_data()
local dev = GetSelf()
local aircraft = get_aircraft_type()
--------------------------------------------------------------------
--Variable declaration
local mastermode        = 0
local mastermodeF15     = 0
local radarScanAreaf15  = 1
local selecter_timer    = 0  
local planeradar_timer  = 0
local chutestate 
local CLIC_MODE_AA_COUNTER
--------------------------------------------------------------------
--local test  =   get_param_handle("BASE_SENSOR_RIGHT_THROTTLE_POS")





function post_initialize()
    print_message_to_user("v1.0.1c-beta",10)
    print_message_to_user(aircraft,10)
    dispatch_action(nil,Keys.iCommandCockpitClickModeOnOff) 
    chutestate              = 0
    CLIC_MODE_AA_COUNTER    = 0
    --dump("list_cockpit_params",list_cockpit_params())
	local birth = LockOn_Options.init_conditions.birth_place

    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
    elseif birth=="GROUND_COLD" then
    end

	

end
function detect_rusian_air_to_air(aircraft)
    
    
    if aircraft=="Su-33" or aircraft=="Su-27"or aircraft=="J-11A" or aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S" then
    return true
    else
    return false
    end
    
end




function reset_mastermode(mastermode,AA)
    local   max_mastermode  = 3
        if AA == true then
            max_mastermode  = 7
        end
                
        if mastermode >max_mastermode then
               
    
                return 2
            elseif mastermode <=1 then 
                return 1
            else    
                return mastermode
        end
    
        
    
end

function reset_mastermodeF15(mastermodeF15)
    local   max_mastermodeF15  = 5
                
        if mastermodeF15 >max_mastermodeF15 then
               
    
                return 2
            elseif mastermodeF15 <2 then 
                return 2
            else    
                return mastermodeF15
        end
    
        
    
end

function reset_radarScanAreaf15(radarScanAreaf15)
    local   max_radarScanAreaf15  = 1
                
        if radarScanAreaf15 >max_radarScanAreaf15 then
               
    
                return 1
            elseif radarScanAreaf15 <0 then 
                return 0
            else    
                return radarScanAreaf15
        end
    
        
    
end   





function SetCommand(command,value)
   
    --print_message_to_user(value)
    
    local AA    = detect_rusian_air_to_air(aircraft)

    if command == device_commands.CLIC_RBOOM and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneAirRefuel)
        
    end

    if command == device_commands.CLIC_WHEELBRAKE   then  
        dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOn) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOff)	
        end
    end
    

    if command == device_commands.CLIC_GRID and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneModeGrid)
        
    end

            if command == device_commands.CLIC_ASP    then 
        dispatch_action(nil,Keys.iCommandPlaneHUDFilterOnOff)
    end
    if command == device_commands.CLIC_TRIM_L   then 
        dispatch_action(nil,Keys.iCommandPlaneTrimLeft)
        if value ~=1 then
        dispatch_action(nil,Keys.iCommandPlaneTrimStop)	
        end
    end
    if command == device_commands.CLIC_TRIM_R   then 
        dispatch_action(nil,Keys.iCommandPlaneTrimRight)
        if value ~=1 then
        dispatch_action(nil,Keys.iCommandPlaneTrimStop)	
        end
    end
    if command == device_commands.CLIC_TRIM_U   then 
        dispatch_action(nil,Keys.iCommandPlaneTrimDown)
        if value ~=1 then
        dispatch_action(nil,Keys.iCommandPlaneTrimStop)	
        end
    end
    if command == device_commands.CLIC_TRIM_D   then 
        dispatch_action(nil,Keys.iCommandPlaneTrimUp)
        if value ~=1 then
        dispatch_action(nil,Keys.iCommandPlaneTrimStop)	
        end
    end



    if command == device_commands.CLIC_TGT_L   then 
        dispatch_action(nil,Keys.iCommandPlaneRadarLeft)
        if value ~=1 then
        dispatch_action(nil,Keys.iCommandPlaneRadarStop)	
        end
    end

    if command == device_commands.CLIC_TGT_R   then  
        dispatch_action(nil,Keys.iCommandPlaneRadarRight) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandPlaneRadarStop)	
        end
    end

    if command == device_commands.CLIC_TGT_U   then  
        dispatch_action(nil,Keys.iCommandPlaneRadarUp) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandPlaneRadarStop)	
        end
    end
    
    if command == device_commands.CLIC_TGT_D   then  
        dispatch_action(nil,Keys.iCommandPlaneRadarDown) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandPlaneRadarStop)	
        end
    end

    if command == device_commands.CLIC_NAVMODES and value ~=0 then
        dispatch_action(nil,Keys.iCommandPlaneModeNAV)
    end


    if command ==  device_commands.CLIC_STATION and value == 1  then
        dispatch_action(nil,Keys.iCommandPlaneChangeWeapon) 
    end 

    if command ==  device_commands.CLIC_LOCK and value == 1  then
        dispatch_action(nil,Keys.iCommandPlaneChangeLock) 
    end 

    if command ==  device_commands.CLIC_LOCK_REL and value == 1  then
        dispatch_action(nil,Keys.iCommandSensorReset) 
    end  

    if command ==  device_commands.CLIC_CTM_ONCE and value == 1  then
        dispatch_action(nil,Keys.iCommandPlaneDropSnarOnce) 
    end    

    if command ==  device_commands.CLIC_AIRBRAKE and value == 1  then
        dispatch_action(nil,Keys.iCommandPlaneAirBrake) 
    end

    if command ==  device_commands.CLIC_WAYPOINT and  value >0 then
        dispatch_action(nil,Keys.iCommandPlaneChangeTarget) 
    elseif command ==  device_commands.CLIC_WAYPOINT and  value <0 then
        dispatch_action(nil,Keys.iCommandPlaneUFC_STEER_DOWN) 
    end

    if command == device_commands.CLIC_MODE  and  value >0 then
        mastermode = mastermode +1
        
    elseif  command == device_commands.CLIC_MODE  and  value <0 then
        mastermode = mastermode -1
        
    end
    mastermode = reset_mastermode(mastermode,AA)
   

    if command == device_commands.CLIC_MODE_AA  and value ==1 then
        CLIC_MODE_AA_COUNTER = CLIC_MODE_AA_COUNTER +1
        if mastermode == 8 then
            dispatch_action(nil,Keys.iCommandPlaneModeGrid)
            
        end
        mastermode = 0

        if CLIC_MODE_AA_COUNTER == 1 then
            dispatch_action(nil,Keys.iCommandPlaneModeBVR)
        end
        if CLIC_MODE_AA_COUNTER == 2 then
            dispatch_action(nil,Keys.iCommandPlaneModeVS)
            CLIC_MODE_AA_COUNTER = 0
        end
        
    end


    if command == device_commands.CLIC_MODE then
        

        if AA == true then
            
            if      mastermode == 2 then
            dispatch_action(nil,Keys.iCommandPlaneModeBVR)
            elseif  mastermode == 3 then
            dispatch_action(nil,Keys.iCommandPlaneModeVS)
            elseif  mastermode == 4 then
            dispatch_action(nil,Keys.iCommandPlaneModeBore)
            elseif  mastermode == 5 then
            dispatch_action(nil,Keys.iCommandPlaneModeHelmet)
            elseif  mastermode == 6 then
            dispatch_action(nil,Keys.iCommandPlaneModeFI0)
            elseif  mastermode == 7 then
            dispatch_action(nil,Keys.iCommandPlaneModeGround)
            end      
        else 
            
            if      mastermode == 2 then
                dispatch_action(nil,Keys.iCommandPlaneModeFI0)
            elseif  mastermode == 3 then
                dispatch_action(nil,Keys.iCommandPlaneModeGround)
            end 
            if command == device_commands.CLIC_LASER and  value ==1  then
                dispatch_action(nil, Keys.iCommandPlaneLaserRangerOnOff)
            end
            if command == device_commands.CLIC_TV_NIGHT and  value == 1 then
                dispatch_action(nil, Keys.iCommandPlaneNightTVOnOff)
            end
            if command == device_commands.CLIC_ZOOM and value >0 then
                dispatch_action(nil,Keys.iCommandPlaneZoomIn)
            elseif command == device_commands.CLIC_ZOOM and  value <0 then
                dispatch_action(nil,Keys.iCommandPlaneZoomOut) 
            end
        end


    end
    --One-button parachute control
    if command == device_commands.CLIC_CHUTE        and  value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneParachute)
    end
    --Two-button parachute control
    if aircraft=="Su-27"or aircraft=="J-11A" or aircraft=="MiG-29A"or aircraft=="MiG-29G"or aircraft=="MiG-29S" or aircraft=="Su-25T" then
        
        if command == device_commands.CLIC_CHUTE_DEP then	
            if value == 1 then
                if chutestate == 0 then
                    dispatch_action(true, Keys.iCommandPlaneParachute)
                    chutestate = 1
                end
            end
        elseif command == device_commands.CLIC_CHUTE_REL then	
            if value == 1 then
                if chutestate == 1 then
                    dispatch_action(true, Keys.iCommandPlaneParachute)
                    chutestate = -1
                end
            end
        end

    end
    
    if command == device_commands.CLIC_RADAR_FREQ  and  value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneChangeRadarPRF)
    end 

    
    if command == device_commands.CLIC_FLAPS_MULTI and  value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneFlaps)
    end 
    if command == device_commands.CLIC_FLAPS_UP then
        dispatch_action(nil,Keys.iCommandPlaneFlapsOff)    
    end 
             
    if command == device_commands.CLIC_FLAPS_DOWN or command == device_commands.CLIC_FLAPS_LAND then
    dispatch_action(nil,Keys.iCommandPlaneFlapsOn)    
    end         
    if command == device_commands.CLIC_LANDING_LIGHTS and value ==1 then
    dispatch_action(nil,Keys.iCommandPlaneHeadLightOnOff)   
    end   
    
    if command == device_commands.CLIC_ASC_DC and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneCobra)   
    end    
    if command == device_commands.CLIC_FUEL_DUMP_ON  then
        dispatch_action(nil,Keys.iCommandPlaneFuelOn)
    end
    if command == device_commands.CLIC_FUEL_DUMP_OFF      then
        dispatch_action(nil,Keys.iCommandPlaneFuelOff)
    end  
    if command == device_commands.CLIC_AUTO_GCA and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneSAUHRadio)
        
    end
    if command == device_commands.CLIC_AUTO_DAMPER    then
        dispatch_action(nil,Keys.iCommandPlaneStabHbarBank)
    end         
        
    if command == device_commands.CLIC_AUTO_STOP    then
        dispatch_action(nil,Keys.iCommandPlaneStabCancel)
    end         
    if command == device_commands.CLIC_AUTO_BARO and value ==1 then
    dispatch_action(nil,Keys.iCommandPlaneStabHbarBank)
    end  
    
    if command == device_commands.CLIC_AUTO_RADAR and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneStabHrad)
        end  
             
    if command == device_commands.CLIC_AUTO_LEVEL and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneStabHorizon) 
    end      
    if command == device_commands.CLIC_AUTO_ROUTE  and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneRouteAutopilot) 
    end  
    if command == device_commands.CLIC_AUTO_ALT  and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneStabTangBank) 
    end      
    if command == device_commands.CLIC_HUD_REPEATER and value ==1 then
        dispatch_action(nil,Keys.iCommandPlaneRightMFD_OSB1) 
    end     
    if command == device_commands.CLIC_POWER  and value ==1 then
        dispatch_action(nil,Keys.iCommandPowerOnOff) 
    end            
    if command == device_commands.CLIC_ENG_L_START  and value ==1 then  
        dispatch_action(nil,Keys.iCommandLeftEngineStart) 
    end    
    if command == device_commands.CLIC_ENG_R_START  and value ==1 then  
        dispatch_action(nil,Keys.iCommandRightEngineStart) 
    end
    if command == device_commands.CLIC_ENG_L_STOP   then  
        dispatch_action(nil,Keys.iCommandLeftEngineStop)  
    end  
    if command == device_commands.CLIC_ENG_R_STOP    then  
        dispatch_action(nil,Keys.iCommandRightEngineStop)  
    end   
 
    if command == device_commands.CLIC_CTM and value ==1 then 
        dispatch_action(nil,Keys.iCommandPlaneDropSnar) 
    end    
    if command == device_commands.CLIC_CTM_CHAFF and value ==1 then 
        dispatch_action(nil,Keys.iCommandPlaneDropChaffOnce) 
    end 
    if command == device_commands.CLIC_CTM_FLARE and value ==1 then 
        dispatch_action(nil,Keys.iCommandPlaneDropFlareOnce) 
    end
    if command == device_commands.CLIC_JAM_IR and value ==1 then 
        dispatch_action(nil,Keys.iCommandActiveIRJamming) 
    end  
    if command == device_commands.CLIC_JAM and value ==1 then 
        dispatch_action(nil,Keys.iCommandActiveJamming) 
    end

    if command == device_commands.CLIC_HUD_FILTER  and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneHUDFilterOnOff) 
    end 

    if command == device_commands.CLIC_GEAR   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneGear) 
    end     
    if command == device_commands.CLIC_CANOPY   and value ==1 then 
          
        dispatch_action(nil,Keys.iCommandPlaneFonar)

    end 
    if command == device_commands.CLIC_NAVLIGHTS   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneLightsOnOff) 
    end  
    if command == device_commands.CLIC_COCKPITLIGHT   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneCockpitIllumination) 
    end 
    if command == device_commands.CLIC_JETTINSON_TANK   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneJettisonFuelTanks) 
    end 
    if command == device_commands.CLIC_JETTINSON   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons) 
    end
    if command == device_commands.CLIC_JETTINSON_EMER   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons) 
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
        dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
    end
    if command == device_commands.CLIC_RADAR_ON_OFF   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneRadarOnOff) 
    end
 
    if command == device_commands.CLIC_TV   and value ==1 then  
        dispatch_action(nil,Keys.iCommandPlaneEOSOnOff) 
    end

    if command == device_commands.CLIC_SCAN_L   then 
        dispatch_action(nil,Keys.iCommandSelecterLeft)
		if value ~=1 then
    	dispatch_action(nil,Keys.iCommandSelecterStop)	
		end
    end

    if command == device_commands.CLIC_SCAN_R   then  
        dispatch_action(nil,Keys.iCommandSelecterRight) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandSelecterStop)	
        end
    end

    if command == device_commands.CLIC_SCAN_U   then  
        dispatch_action(nil,Keys.iCommandSelecterUp) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandSelecterStop)	
        end
    end
    
    if command == device_commands.CLIC_SCAN_D   then  
        dispatch_action(nil,Keys.iCommandSelecterDown) 
        if value ~=1 then
            dispatch_action(nil,Keys.iCommandSelecterStop)	
        end
    end

    

    if command == device_commands.CLIC_HUD_COLOR and value == 1 then
        dispatch_action(nil,Keys.iCommandBrightnessILS)
        
    end

    if command == device_commands.CLIC_HUD_BRT and value >0 then
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)



    elseif command == device_commands.CLIC_HUD_BRT and  value <0 then
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  


    end
    if command == device_commands.CLIC_MIRROR and value == 1 then
        dispatch_action(nil,Keys.iCommandToggleMirrors)
        
    end

    if command == device_commands.CLIC_ENG_INLET and value == 1 then
        dispatch_action(nil,Keys.iCommandPlane_HOTAS_ChinaHatForward)
        
    end

    if command == device_commands.CLIC_NOSE_WHEEL and value == 1 then
        dispatch_action(nil,Keys.iCommandPlane_HOTAS_NoseWheelSteeringButton)
        
    end

    if command == device_commands.CLIC_EJECT and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneEject)
        
    end

    if command == device_commands.CLIC_RWR_MODE and value == 1 then
        dispatch_action(nil,Keys.iCommandChangeRWRMode)
        
    end

    if command == device_commands.CLIC_RWR_SOUND and value >0 then
        dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeUp)
        dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeUp)
    elseif command == device_commands.CLIC_RWR_SOUND and  value <0 then
        dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeDown) 
        dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeDown)  
    end

    if command == device_commands.CLIC_WARNING_RST and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneResetMasterWarning)
        
    end

    if command == device_commands.CLIC_DSP_ZOOMIN and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneZoomIn)
        
    end
    if command == device_commands.CLIC_DSP_ZOOMOUT and value == 1 then
        dispatch_action(nil,Keys.iCommandPlaneZoomOut)
        
    end
    if command == device_commands.CLIC_CLOCK_F and value == 1 then
        dispatch_action(nil,Keys.iCommandFlightClockReset)
        
    end
    if command == device_commands.CLIC_CLOCK_E and value == 1 then
        dispatch_action(nil,Keys.iCommandClockElapsedTimeReset)
        
    end
    if command == device_commands.CLIC_ALTIMETER and value >0 then
        dispatch_action(nil,Keys.iCommandAltimeterPressureIncrease)
        dispatch_action(nil,Keys.iCommandAltimeterPressureIncrease)
        dispatch_action(nil,Keys.iCommandAltimeterPressureIncrease)
    elseif command == device_commands.CLIC_ALTIMETER and  value <0 then
        dispatch_action(nil,Keys.iCommandAltimeterPressureDecrease) 
        dispatch_action(nil,Keys.iCommandAltimeterPressureDecrease) 
        dispatch_action(nil,Keys.iCommandAltimeterPressureDecrease) 
    end


    --Brake control specific to Flankers and derivatives
    if aircraft=="Su-33" or aircraft=="Su-27"or aircraft=="J-11A" then

        

        if command == device_commands.CLIC_EMER_BRAKE and value == 1 then
            dispatch_action(nil,Keys.iCommandPlaneWheelParkingBrake)
            
        end
    end
    --Su-33 Specifics   
    if aircraft=="Su-33" then
        if command == device_commands.CLIC_AUTOTHRUST and value == 1 then
            dispatch_action(nil,Keys.iCommandPlaneAUTOnOff)
            
        end

        if command == device_commands.CLIC_AUTOTHRUST_I and value == 1 then
            dispatch_action(0,Keys.iCommandPlaneAUTIncrease,1.0)
        elseif value == 0 then
            dispatch_action(0,Keys.iCommandPlaneAUTIncrease,0.0)
                
            
        end

        if command == device_commands.CLIC_AUTOTHRUST_D and value == 1 then
            dispatch_action(0,Keys.iCommandPlaneAUTIncrease,-1.0)
        elseif value == 0 then
            dispatch_action(0,Keys.iCommandPlaneAUTIncrease,0.0)
            
        end

        if command == device_commands.CLIC_ASC_REFUEL and value == 1 then
            dispatch_action(nil,Keys.iCommandPlane_ADF_Mode_change)
            
        end

        if command == device_commands.CLIC_AFTERURN_S and value == 1 then
            dispatch_action(nil,Keys.iCommandPlane_P_51_WarEmergencyPower)
            
        end

        if command == device_commands.CLIC_RLIGHTS and value == 1 then
            dispatch_action(nil,Keys.iCommandPlane_ADF_Test)
            
        end

        if command == device_commands.CLIC_TAILHOOK and value == 1 then
            dispatch_action(nil,Keys.iCommandPlaneHook)
            
        end

        if command == device_commands.CLIC_WINGSF and value == 1 then
            dispatch_action(nil,Keys.iCommandPlanePackWing)
            
        end
    end
    

    if command == device_commands.CLIC_RIPPLE_INT and value >0 then
        dispatch_action(nil,Keys.iCommandChangeRippleInterval)



    elseif command == device_commands.CLIC_RIPPLE_INT and  value <0 then
        dispatch_action(nil,Keys.iCommandChangeRippleIntervalDown)  

    end

    if command == device_commands.CLIC_RIPPLE_QT  and value == 1 then
        dispatch_action(nil,Keys.iCommandChangeRippleQuantity)
        
    end

    if command == device_commands.CLIC_RIPPLE_QTA10  then
        dispatch_action(nil,Keys.iCommandChangeRippleQuantity)
        
    end

    if command == device_commands.CLIC_CUTBURST and value == 1 then
        dispatch_action(nil,Keys.iCommandChangeGunRateOfFire)
        
    end

    if command == device_commands.CLIC_PRS_SGL  then
        dispatch_action(nil,Keys.iCommandChangeReleaseMode)
        
    end
    if command ==  device_commands.CLIC_RADAR_EL  then
            selecter_timer = 0.3
            if      value   ==1 then
            dispatch_action(nil,Keys.iCommandSelecterUp) 
                 
            elseif  value   ==0 then
            dispatch_action(nil,Keys.iCommandSelecterDown)        
        end
    end
    if command ==   device_commands.CLIC_TARGET_UD then
        planeradar_timer = 0.15
        if      value   ==1 then
        dispatch_action(nil,Keys.iCommandPlaneRadarUp) 
             
        elseif  value   ==0 then
        dispatch_action(nil,Keys.iCommandPlaneRadarDown)        
        end
    end
    if command ==   device_commands.CLIC_TARGET_LR then
        planeradar_timer = 0.20
        if      value   ==1 then
        dispatch_action(nil,Keys.iCommandPlaneRadarLeft) 
             
        elseif  value   ==0 then
        dispatch_action(nil,Keys.iCommandPlaneRadarRight)        
        end
    end 
    


    if command == device_commands.CLIC_RIPPLE_INT and value >0 then
        dispatch_action(nil,Keys.iCommandChangeRippleInterval)



    elseif command == device_commands.CLIC_RIPPLE_INT and  value <0 then
        dispatch_action(nil,Keys.iCommandChangeRippleIntervalDown)  

    end
    --F-15C Specifics
    if aircraft=="F-15C" then
                if command == device_commands.CLIC_FIRE and value == 1 then
                    dispatch_action(nil,Keys.iCommandPlanePickleOn)
                else
                    dispatch_action(nil,Keys.iCommandPlanePickleOff)
                end

                if command == device_commands.CLIC_LANDING_LIGHTS_F15 then
                    dispatch_action(nil,Keys.iCommandPlaneHeadLightOnOff)   
                end  
                if command == device_commands.CLIC_PARKING_BRAKES_F15_ON and value == 1 then
                    dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOn)
                end
                if command == device_commands.CLIC_PARKING_BRAKES_F15_OFF and value == 1 then 
                    dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOff)
                end
            end
            -- Master Combat Mode Controls
            -- To be reworked to implement the Navigation mod which has two sub mods, which causes problems.
                if command == device_commands.CLIC_MODE_F15  and  value >0 then
                    mastermodeF15 = mastermodeF15 +1
                    
                elseif  command == device_commands.CLIC_MODE_F15  and  value <0 then
                    mastermodeF15 = mastermodeF15 -1
                    
                end
                if command == device_commands.CLIC_MODE_F15 then
                    if          mastermodeF15 == 2 then
                        dispatch_action(nil,Keys.iCommandPlaneModeBVR)
                        elseif  mastermodeF15 == 3 then
                        dispatch_action(nil,Keys.iCommandPlaneModeVS)
                        elseif  mastermodeF15 == 4 then
                        dispatch_action(nil,Keys.iCommandPlaneModeBore)
                        elseif  mastermodeF15 == 5 then
                        dispatch_action(nil,Keys.iCommandPlaneModeFI0)
                    end 
                mastermodeF15 = reset_mastermodeF15(mastermodeF15)
                end
           
            

                     
            
    
    
        
    
            --Radar Controls
                if command == device_commands.CLIC_ZOOM_F15 and value >0 then
                    dispatch_action(nil,Keys.iCommandPlaneZoomIn)
                elseif command == device_commands.CLIC_ZOOM_F15 and  value <0 then
                    dispatch_action(nil,Keys.iCommandPlaneZoomOut) 
                end
                if command == device_commands.CLIC_RADAR_FREQ_F15 then
                    dispatch_action(nil,Keys.iCommandPlaneChangeRadarPRF)
                end
                if command == device_commands.CLIC_RADAR_ON_OFF_F15  then  
                    dispatch_action(nil,Keys.iCommandPlaneRadarOnOff) 
                end
                if command == device_commands.CLIC_RADAR_AZ and value >0 then

                    radarScanAreaf15 = radarScanAreaf15 +1
                    
                elseif command == device_commands.CLIC_RADAR_AZ and  value <0 then
                    radarScanAreaf15 = radarScanAreaf15 -1
                     
                end
                if command == device_commands.CLIC_RADAR_AZ then
                    if      radarScanAreaf15    ==  1 then
                        dispatch_action(nil,Keys.iCommandIncreaseRadarScanArea)                 
                    elseif  radarScanAreaf15    ==  0 then
                        dispatch_action(nil,Keys.iCommandDecreaseRadarScanArea) 
                    end
                end
            radarScanAreaf15 = reset_radarScanAreaf15(radarScanAreaf15)
            
    end


 
    





function update()
--print_message_to_user(mastermodeF15)

    if selecter_timer > 0 then
        selecter_timer = selecter_timer - update_time_step
        if selecter_timer <= 0 then
            selecter_timer = 0
            dispatch_action(nil,Keys.iCommandSelecterStop)
        end
    end
    if planeradar_timer > 0 then
        planeradar_timer = planeradar_timer - update_time_step
        if planeradar_timer <= 0 then
            planeradar_timer = 0
            dispatch_action(nil,Keys.iCommandPlaneRadarStop)
        end
    end
end

need_to_be_closed = false -- close lua state after initialization


