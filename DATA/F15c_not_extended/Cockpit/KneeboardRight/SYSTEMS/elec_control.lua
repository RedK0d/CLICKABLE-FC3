
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
local   GND_EPS    ,GND_PWR_2,GND_PWR_3,GND_PWR_4,GND_PWR_CC
local   SYSTEM_STAT,SYSTEM_TARGET  
local   AC_BUS_1                =   get_param_handle("AC_BUS_1")
local   AC_BUS_2                =   get_param_handle("AC_BUS_2")
local   DC_BUS_1                =   get_param_handle("DC_BUS_1")
local   DC_BUS_2                =   get_param_handle("DC_BUS_2")
local   ECS                     =   get_param_handle("ECS_READY") 
local   birth                   =   LockOn_Options.init_conditions.birth_place            
--------------------------------------------------------------------
local   function    elec_hot_start()
    dev:performClickableAction(device_commands.GND_EPS    ,   1, false)  
    dev:performClickableAction(device_commands.GND_PWR_2,   1, false)
    dev:performClickableAction(device_commands.GND_PWR_3,   1, false)    
    dev:performClickableAction(device_commands.GND_PWR_4,   1, false)
    dev:performClickableAction(device_commands.GND_PWR_CC,  1, false)
end    
local   function    elec_cold_start()
    dev:performClickableAction(device_commands.GND_EPS    ,   0, false)  
    dev:performClickableAction(device_commands.GND_PWR_2,  -1, false)
    dev:performClickableAction(device_commands.GND_PWR_3,  -1, false)    
    dev:performClickableAction(device_commands.GND_PWR_4,  -1, false)
    dev:performClickableAction(device_commands.GND_PWR_CC, -1, false)
end
function post_initialize()
    --print_message_to_user("DEV.ELEC_CONTROL_SYSTEM",0.2)                          debug
    if              birth           ==      "GROUND_HOT"            or 
                    birth           ==      "AIR_HOT"               then
                    SYSTEM_STAT      =       1
                    elec_hot_start()

        
    elseif          birth           ==      "GROUND_COLD"           then
                    SYSTEM_STAT      =       0
                    elec_cold_start()
     

    end

	

end
function SetCommand(command,value)
    --print_message_to_user(tostring(command).." = "..tostring(value))                  debug
    if          command         ==  device_commands.GND_EPS                 then
                GND_EPS           =   value
    end 
    if          command         ==  device_commands.GND_PWR_2               then
                GND_PWR_2       =   value
    end
    if          command         ==  device_commands.GND_PWR_3               then
                GND_PWR_3       =   value
    end
    if          command         ==  device_commands.GND_PWR_4               then
                GND_PWR_4       =   value
    end     
    if          command         ==  device_commands.GND_PWR_CC              then
                GND_PWR_CC      =   value
    end
    if          GND_EPS         ==  1                                       then
                SYSTEM_TARGET   =   1   
                                            
    else    
                SYSTEM_TARGET   =   0
                
    end
    if          SYSTEM_STAT      ==  1                                       and
                SYSTEM_TARGET    ==  0                                       then
                dispatch_action(nil,Keys.iCommandPowerOnOff) 
                SYSTEM_STAT      =   SYSTEM_TARGET
    elseif      SYSTEM_STAT      ==  0                                       and
                SYSTEM_TARGET    ==  1                                       then
                dispatch_action(nil,Keys.iCommandPowerOnOff)
                SYSTEM_STAT      =   SYSTEM_TARGET    
                
    end
    if          SYSTEM_STAT      ==  1                                       then
                dev:AC_Generator_1_on(true)   
                dev:AC_Generator_2_on(true)   
                dev:DC_Battery_on(true)       
    else     
                dev:AC_Generator_1_on(false)   
                dev:AC_Generator_2_on(false)   
                dev:DC_Battery_on(false)
    end
     
end


function update()    
                AC_BUS_1:set(dev:get_AC_Bus_1_voltage())
                AC_BUS_2:set(dev:get_AC_Bus_2_voltage())
                DC_BUS_1:set(dev:get_DC_Bus_1_voltage())
                DC_BUS_2:set(dev:get_DC_Bus_2_voltage())
                ECS:set(SYSTEM_STAT)    
end

need_to_be_closed = false -- close lua state after initialization


