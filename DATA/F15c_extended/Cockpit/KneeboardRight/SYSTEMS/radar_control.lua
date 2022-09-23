
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local update_time_step      = 0.005 
make_default_activity(update_time_step) 
sensor_data                 = get_base_data()
local dev                   = GetSelf()
local aircraft              = get_aircraft_type()
--------------------------------------------------------------------
--Variable declaration
local   radar_mode      =   0       --  1:LRS   2:VS    3:SRS   
local   radar_stat      =   0       --  -1:Off   0.5:Stby  1:Opr 
local   radar_spl       =   0       --  0:Off   1:Flood   
local   scan_area       =   1
local   r_timer         =   0
local   s_timer         =   0
--------------------------------------------------------------------
-- 
local RADAR_POWER 			= get_param_handle("RADAR_POWER")
local RADAR_MODE_SEL 		= get_param_handle("RADAR_MODE_SEL")
local RADAR_SPL_MODE 		= get_param_handle("RADAR_SPL_MODE")

function post_initialize()
    --print_message_to_user("DEV.RADAR_CONTROL_SYSTEM",0.2)
	local birth = LockOn_Options.init_conditions.birth_place
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then


    elseif birth=="GROUND_COLD" then

    end

	

end
local function  reset_scan_area(scan_area)
    local       max_scan_area   =   1          
        if      scan_area       >   max_scan_area       then   
                return 1
        elseif  scan_area       <   0                   then 
                return 0
        else    
                return scan_area
        end   
end   







dev:listen_command(Keys.iCommandPlaneRadarOnOff)
dev:listen_command(Keys.iCommandPlaneModeNAV)	                   
dev:listen_command(Keys.iCommandPlaneModeBVR)	                    
dev:listen_command(Keys.iCommandPlaneModeVS)	                        
dev:listen_command(Keys.iCommandPlaneModeBore)	                    
dev:listen_command(Keys.iCommandPlaneModeFI0)	                  
dev:listen_command(Keys.iCommandPlaneRadarChangeMode)    
dev:listen_command(Keys.iCommandPlaneChangeRadarPRF)  
dev:listen_command(Keys.iCommandRefusalTWS)  



function SetCommand(command,value)
    if                      command     ==  device_commands.CLIC_RADAR_SPL_MODE                     then
                            radar_spl   =   value                               
        if                  radar_spl   ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeFI0)
        end
        if                  radar_spl   ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBore)
        end
        
    end
    if                      command     ==  device_commands.CLIC_RADAR_MODE_SEL                     then
        if                  value       ==  1                                                       then
                            radar_mode  =   radar_mode   +   1
        elseif              value       ==  0                                                       then
                            radar_mode  =   radar_mode   -   1                                   
        end
        if                  radar_mode  >   3                                                       then
                            radar_mode  =   3
        end
        if                  radar_mode  <   0                                                       then
                            radar_mode  =   0
        end 
        if                  radar_mode  ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBVR)          
        end  
        if                  radar_mode  ==  2                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeVS)          
        end
        if                  radar_mode  ==  3                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneModeBore)          
        end
    end
    if                      command     ==  device_commands.CLIC_RADAR_POWER                        then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)
    end
    if                      radar_stat  ==  0                                                       then
        if                  command     ==  Keys.iCommandPlaneRadarOnOff                            then
                            radar_stat  =   1                                
        end
    elseif                  radar_stat  ==  1                                                       then
        if                  command     ==  Keys.iCommandPlaneRadarOnOff                            then
                            radar_stat  =   0                              
        end
    end
    if                      command     ==  Keys.iCommandPlaneModeBVR                               then
        
                            radar_mode  =   1
                            radar_spl   =   0
        if                  radar_stat  ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)
        end                                                   
                            
    end
    if                      command     ==  Keys.iCommandPlaneModeVS                                then
                            radar_mode  =   2
                            radar_spl   =   0
        if                  radar_stat  ==  0                                                       then
                            radar_stat  =   1
        end                            
    end
    if                      command     ==  Keys.iCommandPlaneModeBore                              then
                            radar_mode  =   3
                            radar_spl   =   0
    
        if                  radar_stat  ==  0                                                       then
                            radar_stat  =   1
        end
    end
    if                      command     ==  Keys.iCommandPlaneModeFI0                               then
                            radar_mode  =   3
                            radar_spl   =   1
        if                  radar_stat  ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneRadarOnOff)
                            
        end                              
    end
    if                      command     ==  device_commands.CLIC_RADAR_EL_SCAN                      then
                            s_timer     =   0.3
        if                  value       ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandSelecterUp) 
        elseif              value       ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandSelecterDown)        
        end
    end
    if                      command     ==  device_commands.CLIC_RADAR_RANGE                        then
        if                  value       ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneZoomIn) 
        elseif              value       ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandPlaneZoomOut)        
        end
    end
    if                      command     == device_commands.CLIC_RADAR_AZ_SCAN                       and 
                            value       >   0                                                       then
                            scan_area   = scan_area +1
    elseif                  command     == device_commands.CLIC_RADAR_AZ_SCAN                       and  
                            value       <   0                                                       then
                            scan_area   = scan_area -1
    end
    if                      command     == device_commands.CLIC_RADAR_AZ_SCAN                       then
        if                  scan_area   ==  1                                                       then
                            dispatch_action(nil,Keys.iCommandIncreaseRadarScanArea)                 
        elseif              scan_area   ==  0                                                       then
                            dispatch_action(nil,Keys.iCommandDecreaseRadarScanArea) 
        end
    end
                            scan_area   = reset_scan_area(scan_area)
end


 
    
function update_radar()
    RADAR_MODE_SEL:set(radar_mode)
    RADAR_POWER:set(radar_stat)
    RADAR_SPL_MODE:set(radar_spl)
end


function update()
 
        if s_timer > 0 then
            s_timer = s_timer - update_time_step
            if s_timer <= 0 then
                s_timer = 0
                dispatch_action(nil,Keys.iCommandSelecterStop)
            end
        end
        if r_timer > 0 then
            r_timer = r_timer - update_time_step
            if r_timer <= 0 then
                r_timer = 0
                dispatch_action(nil,Keys.iCommandPlaneRadarStop)
            end
        end
        update_radar()
        --print_message_to_user(get_cockpit_draw_argument_value(429))
end
    
need_to_be_closed = false 


