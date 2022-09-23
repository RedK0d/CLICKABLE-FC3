
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
sensor_data                     =   get_base_data()
local   dev                     =   GetSelf()
local   aircraft                =   get_aircraft_type()
--------------------------------------------------------------------
--  Variables Declaration

local   birth                   =   LockOn_Options.init_conditions.birth_place
local   SYSTEM_STAT,SYSTEM_TARGET,REFUEL_STAT,REFUEL_INIT 
local   FUEL_TANK,FUEL_CENTER,FUEL_WINGS,FUEL_DUMP,FUEL_EXTTR,FUEL_EMERTR,FUEL_REFUEL
local   FCS                     =   get_param_handle("FCS_READY") 
--------------------------------------------------------------------
local   function    fuel_hot_start()
    dev:performClickableAction(device_commands.FUEL_TANK,   0, false)  
    dev:performClickableAction(device_commands.FUEL_CENTER, 0, false)  
    dev:performClickableAction(device_commands.FUEL_WINGS,  0, false)  
    dev:performClickableAction(device_commands.FUEL_DUMP,  -1, false)  
    dev:performClickableAction(device_commands.FUEL_EXTTR, -1, false)  
    dev:performClickableAction(device_commands.FUEL_EMERTR,-1, false)  
    dev:performClickableAction(device_commands.FUEL_REFUEL,-1, false) 
    REFUEL_INIT    =   -1
end    
local   function    fuel_cold_start()
    dev:performClickableAction(device_commands.FUEL_TANK,   0, false)  
    dev:performClickableAction(device_commands.FUEL_CENTER, 0, false)  
    dev:performClickableAction(device_commands.FUEL_WINGS,  0, false)  
    dev:performClickableAction(device_commands.FUEL_DUMP,  -1, false)  
    dev:performClickableAction(device_commands.FUEL_EXTTR, -1, false)
    dev:performClickableAction(device_commands.FUEL_EMERTR,-1, false)  
    dev:performClickableAction(device_commands.FUEL_REFUEL,-1, false) 
    REFUEL_INIT    =   -1
end
function post_initialize()
    --print_message_to_user("DEV.FUEL_CONTROL_SYSTEM",0.2)                          
    if              birth           ==      "GROUND_HOT"            or 
                    birth           ==      "AIR_HOT"               then
                    fuel_hot_start()
    elseif          birth           ==      "GROUND_COLD"           then
                    fuel_cold_start()
    end
end
function SetCommand(command,value)
    --print_message_to_user(tostring(command).." = "..tostring(value))
    if          command         ==  device_commands.FUEL_TANK               then
                FUEL_TANK       =   value
    end
    if          command         ==  device_commands.FUEL_CENTER             then
                FUEL_CENTER     =   value
    end
    if          command         ==  device_commands.FUEL_WINGS              then
                FUEL_WINGS      =   value
    end  
    if          command         ==  device_commands.FUEL_DUMP               then
                FUEL_DUMP       =   value
    end
    if          command         ==  device_commands.FUEL_EMERTR             then
                FUEL_EMERTR      =   value
    end
    if          command         ==  device_commands.FUEL_EXTTR              then
                FUEL_EXTTR      =   value
    end
    if          command         ==  device_commands.FUEL_REFUEL             then
                FUEL_REFUEL     =   value
    end                
    if          command         ==  device_commands.FUEL_REFUEL             then
                REFUEL_STAT     =  value
    end
    if          REFUEL_INIT     ==  -1                                      then
        if      REFUEL_STAT     ==  1                                       then
                dispatch_action(nil,Keys.iCommandPlaneAirRefuel) 
                REFUEL_INIT     =   REFUEL_STAT  
        end
    end
    if          REFUEL_INIT     ==  1                                       then
        if      REFUEL_STAT     ==  -1                                      then
                dispatch_action(nil,Keys.iCommandPlaneAirRefuel)
                REFUEL_INIT     =   REFUEL_STAT
        end
    end   
    if          FUEL_DUMP       ==  -1                                      and
                FUEL_REFUEL     ==  -1                                      and
                FUEL_EMERTR     ==  -1                                      and
                FUEL_WINGS      ==  0                                       and
                FUEL_CENTER     ==  0                                       and
                FUEL_TANK       ==  0                                       then
                SYSTEM_STAT     =   1   
    else
                SYSTEM_STAT     =   0
    end
        
                                           

end


function update()    
                 FCS:set(SYSTEM_STAT)   
end

need_to_be_closed = false -- close lua state after initialization


