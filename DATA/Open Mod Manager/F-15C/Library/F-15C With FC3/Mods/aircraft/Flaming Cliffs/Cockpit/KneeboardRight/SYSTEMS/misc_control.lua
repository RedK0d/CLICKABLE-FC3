
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
local   E_BRAKES,PROC
local   birth                   =   LockOn_Options.init_conditions.birth_place    
local   MCS                     =   get_param_handle("MCS_READY")

--------------------------------------------------------------------
local   function    MCS_CHECK_SYSTEMS()
    if          E_BRAKES        ==  1                                      then
                PROC            =   1

    else        PROC            =   0
    end                
end
local   function    misc_hot_start()
    dev:performClickableAction(device_commands.MISC_ANTISKID,   -1, false)
    dev:performClickableAction(device_commands.MISC_INLET_R,    1,  false)
    dev:performClickableAction(device_commands.MISC_INLET_L,    1,  false)
    dev:performClickableAction(device_commands.MISC_ROLL,       1,  false)
    dev:performClickableAction(device_commands.MISC_MASTERARM,  -1, false)
    dev:performClickableAction(device_commands.MISC_EBRAKES,    -1, false)
    MCS_CHECK_SYSTEMS()

end    
local   function    misc_cold_start()
    dev:performClickableAction(device_commands.MISC_ANTISKID,   -1, false)
    dev:performClickableAction(device_commands.MISC_INLET_R,    1,  false)
    dev:performClickableAction(device_commands.MISC_INLET_L,    1,  false)
    dev:performClickableAction(device_commands.MISC_ROLL,       1,  false)
    dev:performClickableAction(device_commands.MISC_MASTERARM,  -1, false)
    dev:performClickableAction(device_commands.MISC_EBRAKES,    -1, false)
    MCS_CHECK_SYSTEMS()

end


function post_initialize()
    --print_message_to_user("DEV.MISC_CONTROL_SYSTEM",0.2)                          
    if              birth           ==      "GROUND_HOT"            or 
                    birth           ==      "AIR_HOT"               then
                    misc_hot_start()

        
    elseif          birth           ==      "GROUND_COLD"           then
                    misc_cold_start()
     

    end

	

end
function SetCommand(command,value)
    --print_message_to_user(tostring(command).." = "..tostring(value))                  
    if          command         ==  device_commands.MISC_EBRAKES            then
                E_BRAKES        =   value           
        if      E_BRAKES        ==  -1                                      then
                dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOff)    
        elseif  E_BRAKES        ==  1                                       then
                dispatch_action(nil,Keys.iCommandPlaneWheelBrakeOn)                    
        end       
    end
    MCS_CHECK_SYSTEMS()        
    
     
    
end


function update()    
    MCS:set(PROC)
                         
end

need_to_be_closed = false -- close lua state after initialization


--arg 25 == hook