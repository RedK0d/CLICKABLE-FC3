
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
sensor_data                 = get_base_data()
local dev                   = GetSelf()
local aircraft              = get_aircraft_type()
--------------------------------------------------------------------
--  Update Connectors Position              Step 1/3
local connector = {}
connector["TMB_FUEL_OPEN/CLOSE"]            = nil
connector["TBM_Wheels"]                     = nil
connector["MIRROR_1"]                       = nil
connector["MIRROR_2"]                       = nil
connector["MIRROR_3"]                       = nil

--------------------------------------------------------------------
--  Variables Declaration
local mastermodeF15     = 0

function reset_mastermodeF15(mastermodeF15)
    local       max_mastermodeF15   =   5
                
        if      mastermodeF15       >   max_mastermodeF15   then          
                return  2
        elseif  mastermodeF15 <2 then 
                return  2
        else    
                return  mastermodeF15
        end 
end

function post_initialize()
    --print_message_to_user(aircraft,15)
    --print_message_to_user("DEV.CLICKABLE_GENERIC_SYSTEM",0.2)

        --dispatch_action(nil,Keys.iCommandCockpitClickModeOnOff) 
    --show_param_handles_list()
	local birth = LockOn_Options.init_conditions.birth_place
--------------------------------------------------------------------------------------------------------
--  Update Connectors Position              Step 2/3
    connector["TMB_FUEL_OPEN/CLOSE"] 			= get_clickable_element_reference("TMB_FUEL_OPEN/CLOSE")
    connector["TBM_Wheels"] 			        = get_clickable_element_reference("TBM_Wheels")
    connector["MIRROR_1"] 			            = get_clickable_element_reference("MIRROR_1")
    connector["MIRROR_2"] 			            = get_clickable_element_reference("MIRROR_2")
    connector["MIRROR_3"] 			            = get_clickable_element_reference("MIRROR_3")

--------------------------------------------------------------------------------------------------------
    
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
      
    dev:performClickableAction(device_commands.CLIC_HUD_BRT, 0.75, false) 
    dev:performClickableAction(device_commands.CLIC_HUD_BRT_2, 0.75, false) 
    dev:performClickableAction(device_commands._321, 0.20, false)
    dev:performClickableAction(device_commands._361, -1, false)       
    dev:performClickableAction(device_commands._404, 1, false)       
    dev:performClickableAction(device_commands._405, 1, false)       
    dev:performClickableAction(device_commands._406, 1, false)       
    dev:performClickableAction(device_commands._407, 1, false)
    dev:performClickableAction(device_commands.CLIC_LENG, 1, false)
    dev:performClickableAction(device_commands.CLIC_RENG, 1, false)
    elseif birth=="GROUND_COLD" then
    dev:performClickableAction(device_commands.CLIC_LENG, -1, false)
    dev:performClickableAction(device_commands.CLIC_RENG, -1, false)
    end

	

end












function SetCommand(command,value)
   
    if          command     ==  device_commands.CLIC_MIRROR                             and     
                value       ==  1                                                       then
                                dispatch_action(nil,Keys.iCommandToggleMirrors)
        
    end
    if          command     ==  device_commands.CLIC_LENG                               then 
        if      value       ==  1                                                       then  
                                dispatch_action(nil,Keys.iCommandLeftEngineStart)
        elseif  value       ==  -1                                                      then
                                dispatch_action(nil,Keys.iCommandLeftEngineStop)
        end
             
    end
    if          command     ==  device_commands.CLIC_RENG                               then 
        if      value       ==  1                                                       then  
                                dispatch_action(nil,Keys.iCommandRightEngineStart)
        elseif  value       ==  -1                                                      then
                                dispatch_action(nil,Keys.iCommandRightEngineStop)
        end
             
    end    
    if          command     ==  device_commands.CLIC_GEAR                               and 
                value       ==  1                                                       then  
                                dispatch_action(nil,Keys.iCommandPlaneGear) 
    end  
    if          command     ==  device_commands.CLIC_RADAR_ON_OFF_F15                   then  
                                dispatch_action(nil,Keys.iCommandPlaneRadarOnOff) 
    end
    if          command     ==  device_commands.CLIC_JETTINSON_TANK                     and
                value       ==  1                                                       or
                command     ==  device_commands.CLIC_JETTINSON_TANK2                    and
                value       ==  1                                                       then  
                                dispatch_action(nil,Keys.iCommandPlaneJettisonFuelTanks) 
    end
    if          command     ==  device_commands.CLIC_MODE_F15                           and  
                value       >   0                                                       then
                                mastermodeF15   =   mastermodeF15   +   1
        
    elseif      command     ==  device_commands.CLIC_MODE_F15                           and     
                value       <   0                                                       then
                                mastermodeF15   =   mastermodeF15   -   1
        
    end
    if          command     ==  device_commands.CLIC_MODE_F15                           then
        if                      mastermodeF15   ==  2                                   then
                                dispatch_action(nil,Keys.iCommandPlaneModeBVR)
            elseif              mastermodeF15   ==  3                                   then
                                dispatch_action(nil,Keys.iCommandPlaneModeVS)
            elseif              mastermodeF15   ==  4                                   then
                                dispatch_action(nil,Keys.iCommandPlaneModeBore)
            elseif              mastermodeF15   ==  5                                   then
                                dispatch_action(nil,Keys.iCommandPlaneModeFI0)
        end 
                                mastermodeF15   = reset_mastermodeF15(mastermodeF15)
    end
    if          command     ==  device_commands.CLIC_RPORT                              and
                value       ==  1                                                       then
                                dispatch_action(nil,Keys.iCommandPlaneAirRefuel)    
    end
     
    if          command     ==  device_commands.CLIC_TAKEOFFTRIMF15                     then
        if      value       ==  1                                                       then
                                dispatch_action(nil,Keys.iCommandPlaneTrimOn)
        elseif  value       ==  0                                                       then
                                dispatch_action(nil,Keys.iCommandPlaneTrimOff)
        end
            
    end   
    if      command ==  device_commands.CLIC_RWR_MODE       and 
            value   ==  1                                   then
                    dispatch_action(nil,Keys.iCommandChangeRWRMode)
    end
    if      command ==  device_commands.CLIC_RWR_SOUND      and 
            value   >   0                                 then
                    dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeUp)
    elseif  command ==  device_commands.CLIC_RWR_SOUND      and
            value   <   0                                 then
                    dispatch_action(nil,Keys.iCommandPlaneThreatWarnSoundVolumeDown) 
    end
   
    if command == device_commands.CLIC_NAVMODES and value ~=0 then
        dispatch_action(nil,Keys.iCommandPlaneModeNAV)
    end
    
    if      command ==  device_commands.CLIC_WAYPOINT           and  
                        value >0                                then
                        dispatch_action(nil,Keys.iCommandPlaneChangeTarget) 
    elseif  command ==  device_commands.CLIC_WAYPOINT           and  
                        value <0                                then
                        dispatch_action(nil,Keys.iCommandPlaneUFC_STEER_DOWN) 
    end

    if      get_cockpit_draw_argument_value(320)>0              and
            get_cockpit_draw_argument_value(320)<0.29           then
                                
                if command ==   device_commands.CLIC_JETTINSON  then
                    
                                if  value ==1                   then
                                dispatch_action(nil,Keys.iCommandPlaneJettisonWeapons)
                                end

                end
    elseif  get_cockpit_draw_argument_value(320)<-0.29           then
                                
                if command ==   device_commands.CLIC_JETTINSON  then

                                if value ==1                       then
                                dispatch_action(nil,Keys.iCommandPlaneJettisonFuelTanks)
                                end

                end
    end
        

    if command == device_commands.CLIC_HUD_BRT and value >0.5 or device_commands.CLIC_HUD_BRT_2 and value >0.5 then

        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)
        dispatch_action(nil,Keys.iCommandHUDBrightnessUp)



    elseif command == device_commands.CLIC_HUD_BRT and value <0.5 or device_commands.CLIC_HUD_BRT_2 and  value <0.5 then
 
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  
        dispatch_action(nil,Keys.iCommandHUDBrightnessDown)  


    end
    if command == device_commands.CLIC_HUD_COLOR_F15  then
        dispatch_action(nil,Keys.iCommandBrightnessILS)
        
    end
        
    

end


 
    




function update()
    
--------------------------------------------------------------------
--  Update Connectors Position              Step 3/3
    if  connector["TMB_FUEL_OPEN/CLOSE"]	                    then
		connector["TMB_FUEL_OPEN/CLOSE"]:update()
	end
    if  connector["TBM_Wheels"]	                                then
		connector["TBM_Wheels"]:update()
	end
    if  connector["MIRROR_1"]	                                then
		connector["MIRROR_1"]:update()
	end
    if  connector["MIRROR_2"]	                                then
		connector["MIRROR_2"]:update()
	end
    if  connector["MIRROR_3"]	                                then
		connector["MIRROR_3"]:update()
	end
--------------------------------------------------------------------
end

need_to_be_closed = false -- close lua state after initialization



