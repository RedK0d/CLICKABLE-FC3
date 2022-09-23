
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
sensor_data                     = get_base_data()
local   dev                     = GetSelf()
local   aircraft                = get_aircraft_type()

--------------------------------------------------------------------
--  Mainpanel Hijacking
local   MISC_TAXI_LIGHT         = get_param_handle("MISC_TAXI_LIGHT")
--------------------------------------------------------------------
--  Update Connectors Position              Step 1/3
local   connector = {}
connector["TMB_MISC_TAXI-LIGHT"]= nil
--------------------------------------------------------------------
--  Variables Declaration
local   n_flash_stat            =   0       --  0:Off   1:Flashing
local   n_flash                 =   0
local   n_flash_s               =   1.5
local   c_flash_stat            =   0       --  0:Off   1:Flashing
local   c_flash                 =   0
local   c_flash_s               =   1
local   LIGHT_ANTICOL,LIGHT_POS,LIGHT_FORM,PROC

local   navlight_s      
local   LCS                     =   get_param_handle("LICS_READY") 
local   ECS                     =   get_param_handle("ECS_READY") 


--------------------------------------------------------------------
local   function    LCS_CHECK_SYSTEMS()
    if          LIGHT_ANTICOL   ==  1     and
                LIGHT_POS       >   0     then
                PROC            =   1

    else        PROC            =   0
    end                
end
local   function lics_hot_start()
    dev:performClickableAction(device_commands.LIGHT_ANTICOL, 1, false)
    dev:performClickableAction(device_commands.LIGHT_FORM, 0, false) 
    dev:performClickableAction(device_commands.LIGHT_POS, 0.5, false) 

    LCS_CHECK_SYSTEMS()
end
local   function lics_cold_start()
    dev:performClickableAction(device_commands.LIGHT_ANTICOL, -1, false)
    dev:performClickableAction(device_commands.LIGHT_FORM, 0, false) 
    dev:performClickableAction(device_commands.LIGHT_POS, 0, false) 
    LCS_CHECK_SYSTEMS()
end
function post_initialize()
    --print_message_to_user("DEV.LIGHT_CONTROL_SYSTEM",0.2)
  
   
	local birth = LockOn_Options.init_conditions.birth_place
--------------------------------------------------------------------------------------------------------
--  Update Connectors Position              Step 2/3
    connector["TMB_MISC_TAXI-LIGHT"] 			= get_clickable_element_reference("TMB_MISC_TAXI-LIGHT")
--------------------------------------------------------------------------------------------------------

  
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
        
        lics_hot_start() 
    elseif birth=="GROUND_COLD" then
        lics_cold_start()
    end

	

end
function SetCommand(command,value)
  
     
    if                  ECS:get()   ==  1                                                           then
        if              command     ==  device_commands._409                                        then
                        dev:performClickableAction(device_commands._180,value) 
                        dev:performClickableAction(device_commands.LIGHT_COCKPIT,value)           
        end
        if              command     ==  device_commands.LIGHT_COCKPIT                               then
                        dev:performClickableAction(device_commands._180,value)        
        end
        if              command     ==  device_commands.LIGHT_LDG_TAXI                              then
                                        dispatch_action(nil,Keys.iCommandPlaneHeadLightOnOff)   
        end     
        if              command     ==  device_commands.LIGHT_ANTICOL                               then
                        LIGHT_ANTICOL=  value
            if
                        LIGHT_ANTICOL== 1                                                           then
                        c_flash_stat=   1
            elseif      LIGHT_ANTICOL== -1                                                          then
                        c_flash_stat=   0
            end
        end
        if              command     ==  device_commands.LIGHT_POS                                   then
                        LIGHT_POS   =   round(value*10,0)
                        --print_message_to_user(value)
            if          LIGHT_POS   >=  0                                                           and
                        LIGHT_POS   <=  6                                                           then
                        n_flash_stat=   0
                                        set_aircraft_draw_argument_value(190,LIGHT_POS/10)   --navl
                                        set_aircraft_draw_argument_value(191,LIGHT_POS/10)   --navr 
                                        set_aircraft_draw_argument_value(192,LIGHT_POS/10)   --strob
            elseif      LIGHT_POS   ==  7                                                           then
                        n_flash_stat=   1 
            end
            
        end
        if              n_flash_stat==   1                                                          then
                        n_flash     =   n_flash_s
        elseif          n_flash_stat==  0                                                           then
                        n_flash     =   0
        end
        if              c_flash_stat==  1                                                           then
                        c_flash     =   c_flash_s
        elseif          c_flash_stat==  0                                                           then
                        c_flash     =   0
        end
        if              command     ==  device_commands.LIGHT_FORM                                   then
                        LIGHT_FORM   =   value
                                        
        end
        LCS_CHECK_SYSTEMS()
    end
end


 
    




function update()
--------------------------------------------------------------------
--  Sync landing and taxi lights with lever via Mainpanel
    if          get_aircraft_draw_argument_value(208)   ==  1   then
                MISC_TAXI_LIGHT:set(1)

    elseif      get_aircraft_draw_argument_value(209)   ==  1   then
                MISC_TAXI_LIGHT:set(-1)
    elseif      get_aircraft_draw_argument_value(208)   ==  0   and
                get_aircraft_draw_argument_value(209)   ==  0   then
                MISC_TAXI_LIGHT:set(0)
    end
--------------------------------------------------------------------
--  Update Connectors Position              Step 3/3
    if  connector["TMB_MISC_TAXI-LIGHT"]	then
		connector["TMB_MISC_TAXI-LIGHT"]:update()
	end
--------------------------------------------------------------------
--  Navigation lights flash logic
    if                  n_flash     >   0                                                               then
                        n_flash     =   n_flash - update_time_step
        if              n_flash     <=  0                                                               then
                        n_flash     =   n_flash_s
        end
        if              n_flash     >=  0.5                                                            and
                        n_flash     >=  1.00                                                           then
                        set_aircraft_draw_argument_value(190,1)   --navl
                        set_aircraft_draw_argument_value(191,1)   --navr 
                        set_aircraft_draw_argument_value(192,1)   --strob
        else    
                        set_aircraft_draw_argument_value(190,0)   --navl
                        set_aircraft_draw_argument_value(191,0)   --navr 
                        set_aircraft_draw_argument_value(192,0)   --strob
        end
    end
--------------------------------------------------------------------
--  Collision lights flash logic
    if                  c_flash     >   0                                                               then
                        c_flash     =   c_flash - update_time_step
        if              c_flash     <=  0                                                               then
                        c_flash     =   c_flash_s
        end
        if              c_flash     >=  0.5                                                             and
                        c_flash     <=  0.6                                                             then 
                        set_aircraft_draw_argument_value(199,1)   --coll
        else    
                        set_aircraft_draw_argument_value(199,0)   --coll
        end
    end
--------------------------------------------------------------------
--  Sync Formation lights with rotary
                        set_aircraft_draw_argument_value(88,LIGHT_FORM)
--------------------------------------------------------------------
LCS:set(PROC)

end

need_to_be_closed = false -- close lua state after initialization


