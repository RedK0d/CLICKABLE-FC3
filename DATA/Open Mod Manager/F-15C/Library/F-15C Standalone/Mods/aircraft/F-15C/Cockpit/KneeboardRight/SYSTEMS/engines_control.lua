
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")


local   update_time_step        = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
local   sensor_data             =   get_base_data()
local   dev                     =   GetSelf()
local   aircraft                =   get_aircraft_type()
--------------------------------------------------------------------
--  Variables Declaration
local   ENG_L_DCNT              =   0
local   ENG_R_DCNT              =   0
local   ENG_EXT_PWR,ENG_GEN_L,ENG_GEN_R,ENG_ECC_L,ENG_ECC_R,ENG_GEN_E,ENG_STARTER,ENG_MASTER_L,ENG_MASTER_R,ENG_JFS,ENG_FF_L,ENG_FF_R
local   ENG_ECC_L_T             =   -1   
local   ENG_ECC_R_T             =   -1
local   ECC_OFF_TIMER           =   0.1
local   JFS_COUPLE_L            =   0   
local   JFS_COUPLE_R            =   0
local   JFS_COUPLE_NIL          =   0
local   JFS_COUPLE_T            =   1.5
local   ENG_STARTER_TIMER       =   25
local   ENG_STARTER_LT          =   0
local   ENG_STARTER_CNT         =   0
local   ENG_STARTER_R           =   0
local   ENG_STARTER_S           =   0
local   ENG_L_START             =   0
local   ENG_L_CNT               =   0
local   ENG_START_TIMER         =   0.5
local   PROC                    =   0
local   birth                   =   LockOn_Options.init_conditions.birth_place
local   FCS                     =   get_param_handle("FCS_READY") 
local   ECS                     =   get_param_handle("ECS_READY") 
local   ENCS                    =   get_param_handle("ENCS_READY") 
local   LCS                     =   get_param_handle("LICS_READY") 
local   ENG_STARTER_L           =   get_param_handle("ENG_STARTER_L")
local   LEFT_THROTTLE_POS       =   get_param_handle("BASE_SENSOR_LEFT_THROTTLE_POS")
local   LEFT_RPM                =   get_param_handle("BASE_SENSOR_LEFT_ENGINE_RPM")
local   RIGHT_RPM               =   get_param_handle("BASE_SENSOR_RIGHT_ENGINE_RPM")
local   CANOPY_POS              =   get_param_handle("BASE_SENSOR_CANOPY_POS")
local   PARAMENG_STARTER_LT     =   get_param_handle("ENG_STARTER_LT")
local   PARAMENG_STARTER_R      =   get_param_handle("ENG_STARTER_R")
local   PARAMENG_STARTER_S      =   get_param_handle("ENG_STARTER_S")
local   TEST                    =   get_param_handle("TEST")
local   function    eng_hot_start()
    dev:performClickableAction(device_commands.ENG_GEN_L,   1, false)  
    dev:performClickableAction(device_commands.ENG_GEN_R,   1, false)
    dev:performClickableAction(device_commands.ENG_ECC_L,   1, false)    
    dev:performClickableAction(device_commands.ENG_ECC_R,   1, false)
    dev:performClickableAction(device_commands.ENG_GEN_E,   0, false)
    dev:performClickableAction(device_commands.ENG_EXT_PWR,-1, false)
    dev:performClickableAction(device_commands.ENG_STARTER,-1, false)
    dev:performClickableAction(device_commands.ENG_MASTER_L,0, false)
    dev:performClickableAction(device_commands.ENG_MASTER_R,0, false)
    dev:performClickableAction(device_commands.ENG_JFS,     0, false)
    dev:performClickableAction(device_commands.ENG_FF_L,    0, false)
    dev:performClickableAction(device_commands.ENG_FF_R,    0, false)
end    
local   function    eng_cold_start()
    dev:performClickableAction(device_commands.ENG_GEN_L,   0, false)  
    dev:performClickableAction(device_commands.ENG_GEN_R,   0, false)
    dev:performClickableAction(device_commands.ENG_ECC_L,   -1, false)    
    dev:performClickableAction(device_commands.ENG_ECC_R,   -1, false)
    dev:performClickableAction(device_commands.ENG_GEN_E,   0, false)
    dev:performClickableAction(device_commands.ENG_EXT_PWR, 0, false)
    dev:performClickableAction(device_commands.ENG_STARTER,-1, false)
    dev:performClickableAction(device_commands.ENG_MASTER_L,0, false)
    dev:performClickableAction(device_commands.ENG_MASTER_R,0, false)
    dev:performClickableAction(device_commands.ENG_JFS,     0, false)
    dev:performClickableAction(device_commands.ENG_FF_L,    0, false)
    dev:performClickableAction(device_commands.ENG_FF_R,    0, false)
end

function post_initialize()
    --print_message_to_user("DEV.ENG_ECCTROL_SYSTEM",0.2)


    sndhost_cockpit                 =   create_sound_host("COCKPIT", "3D",0,0,0) 
    sndhost_aircraft                =   create_sound_host("AIRCRAFT","3D",0,0,0)

    JFS_OPEN_START 	                =   sndhost_cockpit:create_sound("Aircrafts/JFS_OPEN_START") 
    JFS_OPEN_CONTINUE 	            =   sndhost_cockpit:create_sound("Aircrafts/JFS_OPEN_CONTINUE") 
    JFS_OPEN_STOP                   =   sndhost_cockpit:create_sound("Aircrafts/JFS_OPEN_STOP")
    JFS_EXT_START 	                =   sndhost_aircraft:create_sound("Aircrafts/JFS_OPEN_START") 
    JFS_EXT_CONTINUE 	            =   sndhost_aircraft:create_sound("Aircrafts/JFS_OPEN_CONTINUE") 
    JFS_EXT_STOP                    =   sndhost_aircraft:create_sound("Aircrafts/JFS_OPEN_STOP")
    JFS_CLOSED_START 	            =   sndhost_cockpit:create_sound("Aircrafts/JFS_CLOSED_START") 
    JFS_CLOSED_CONTINUE 	        =   sndhost_cockpit:create_sound("Aircrafts/JFS_CLOSED_CONTINUE") 
    JFS_CLOSED_STOP                 =   sndhost_cockpit:create_sound("Aircrafts/JFS_CLOSED_STOP")
    ECC_CLOSED_OFF                  =   sndhost_cockpit:create_sound("Aircrafts/ECC_CLOSED_OFF")
    ECC_CLOSED_ON                   =   sndhost_cockpit:create_sound("Aircrafts/ECC_CLOSED_ON")
    ECC_OFF                         =   sndhost_cockpit:create_sound("Aircrafts/ECC_OFF")
    ECC_ON                          =   sndhost_cockpit:create_sound("Aircrafts/ECC_ON")
    

    update() 
    if              birth           ==      "GROUND_HOT"            or 
                    birth           ==      "AIR_HOT"               then
                    eng_hot_start()     
    elseif          birth           ==      "GROUND_COLD"           then
                    eng_cold_start()
    end

end
local   function    ENG_ECC_L_ON()
                    --print_message_to_user("ECC L ON")                  
                    ENG_ECC_L_T     =   -1
end
local   function    ENG_ECC_L_OFF()
                    --print_message_to_user("ECC L OFF")
                    ENG_ECC_L_T     =   ECC_OFF_TIMER
end
local   function    ENG_ECC_R_ON()
                    --print_message_to_user("ECC R ON")                  
                    ENG_ECC_R_T     =   -1
end
local   function    ENG_ECC_R_OFF()
                    --print_message_to_user("ECC R OFF")
                    ENG_ECC_R_T     =   ECC_OFF_TIMER
end
local   function    ENG_CHECK_SYSTEMS()
    if          ENG_EXT_PWR     ==  -1                                      and
                LCS:get()       ==  1                                       and  
                FCS:get()       ==  1                                       and
                ECS:get()       ==  1                                       then
                PROC            =   1

    else        PROC            =   0
    end                
end
local   function    ENG_STARTER_RSTOP()
                ENG_STARTER_R   =   0
                ENG_STARTER_L:set(0)
                JFS_CLOSED_CONTINUE:stop()
                JFS_OPEN_CONTINUE:stop()
                JFS_OPEN_STOP:play_once()
end
local   function    ENG_STARTER_SSTOP()
                ENG_STARTER_S   =   0
                ENG_STARTER_L:set(0)
                JFS_OPEN_STOP:play_once()

end
local   function    ENG_STARTER_INIT()
                ENG_CHECK_SYSTEMS()
    if          PROC            ==   1                                      then                     
                ENG_STARTER_LT  =   ENG_STARTER_TIMER
        if      CANOPY_POS:get() <  0.15                                    then
                JFS_CLOSED_START:play_once()
        else    JFS_OPEN_START:play_once()
        end
                ENG_STARTER_S   =   1
    end                              
end
local   function    ENG_STARTER_RUNNING()
        if      CANOPY_POS:get() <  0.15                                    then
                JFS_CLOSED_CONTINUE:play_continue()
        else    JFS_OPEN_CONTINUE:play_continue()
        end
                ENG_STARTER_L:set(1)
                ENG_STARTER_R   =   1
                ENG_STARTER_S   =   0    
end
local   function    ENG_JFS_COUPLE_L()
                JFS_COUPLE_L    =   JFS_COUPLE_T    
end
local   function    ENG_JFS_COUPLE_R()
                JFS_COUPLE_R    =   JFS_COUPLE_T    
end
local   function    ENG_JFS_COUPLE_NIL()
                JFS_COUPLE_NIL  =   JFS_COUPLE_T    
end
function SetCommand(command,value)
    --print_message_to_user(tostring(command).." = "..tostring(value))                  
    --[[
        Implémenter ceci
          iCommandPlaneThrustCommon                   =   2004;
    iCommandPlaneThrustLeft	                    =   2005;
    iCommandPlaneThrustRight	                =   2006;
    ]]
    if          command         ==  device_commands.ENG_GEN_L               then
                ENG_GEN_L       =   value
    end
    if          command         ==  device_commands.ENG_GEN_R               then
                ENG_GEN_R       =   value
    end
    if          command         ==  device_commands.ENG_ECC_L               then
                ENG_ECC_L       =   value
        if      ENG_ECC_L       ==  -1                                      then
                ENG_ECC_L_OFF()               
        end
        if      ENG_ECC_L       ==  1                                       then
                ENG_ECC_L_ON()               
        end
    end
    if          command         ==  device_commands.ENG_ECC_R               then
                ENG_ECC_R       =   value
        if      ENG_ECC_R       ==  -1                                      then
                ENG_ECC_R_OFF()               
        end
        if      ENG_ECC_R       ==  1                                       then
                ENG_ECC_R_ON()               
        end
    end
    if          command         ==  device_commands.ENG_GEN_E               then
                ENG_GEN_E       =   value
    end
    if          command         ==  device_commands.ENG_EXT_PWR             then
                ENG_EXT_PWR     =   value
    end
    if          command         ==  device_commands.ENG_STARTER             then
                ENG_STARTER     =   value
        if      value           ==  -1                                      then
            if  ENG_STARTER_R   ==  1                                       then
                ENG_STARTER_RSTOP()
            end
        end
        if      value           ==  1                                       and
                ENG_EXT_PWR     ==  -1                                      and                
                ENG_STARTER_R   ==  0                                       and
                ENG_STARTER_S   ==  0                                       then
                ENG_STARTER_INIT()

        end

   
    end
    if          command         ==  device_commands.ENG_MASTER_L            then
                ENG_MASTER_L    =   value
    end
    if          command         ==  device_commands.ENG_MASTER_R            then
                ENG_MASTER_R    =   value
    end
    if          command         ==  device_commands.ENG_JFS                 then
                ENG_JFS         =   value
        if      ENG_MASTER_L    ==  1                                       and
                ENG_MASTER_R    ==  0                                       and
                ENG_STARTER_R   ==  1                                       then   
            if  ENG_JFS         ==  1                                       then
                ENG_JFS_COUPLE_L()
            end
        elseif  ENG_MASTER_L    ==  0                                       and
                ENG_MASTER_R    ==  1                                       and
                ENG_STARTER_R   ==  1                                       then
            if  ENG_JFS         ==  1                                       then
                ENG_JFS_COUPLE_R()
            end
        elseif  ENG_MASTER_L    ==  0                                       and
                ENG_MASTER_R    ==  0                                       then
            if  ENG_JFS         ==  1                                       then
                ENG_JFS_COUPLE_NIL()
            end
        elseif  ENG_STARTER_R   ==  0                                       then
                ENG_JFS_COUPLE_NIL()
        end
        
    end
    if          command         ==  device_commands.ENG_FF_L                then
                ENG_FF_L        =   value
    end
    if          command         ==  device_commands.ENG_FF_R                then
                ENG_FF_R        =   value
    end
    
    

  
   
    
end


function update() 
        if          ENG_STARTER_LT  >   0                                       then
                    ENG_STARTER_LT  =   ENG_STARTER_LT   -   update_time_step
            if      ENG_STARTER_LT  <  0.1                                      then
                if  ENG_STARTER     ==  1                                       then
                    ENG_STARTER_RUNNING()
                else
                    ENG_STARTER_SSTOP()
                end
            end 
            if      ENG_STARTER_LT  <  0                                        then
                    ENG_STARTER_LT  =  0
            end
        end
        if          JFS_COUPLE_NIL  >   0                                       then
                    JFS_COUPLE_NIL  =   JFS_COUPLE_NIL   -   update_time_step
            if      JFS_COUPLE_NIL  <  0                                        then
                    JFS_COUPLE_NIL  =  0
                    dev:performClickableAction(device_commands.ENG_JFS,     0, false)
            end
        end
        if          JFS_COUPLE_L    >   0                                       then
                    JFS_COUPLE_L    =   JFS_COUPLE_L     -   update_time_step
            if      JFS_COUPLE_L    <  0                                        then
                    JFS_COUPLE_L    =  0
                    dispatch_action(nil,Keys.iCommandLeftEngineStart,0)
                    dev:performClickableAction(device_commands.ENG_JFS,     0, false)

            end
        end
        if          JFS_COUPLE_R    >   0                                       then
                    JFS_COUPLE_R    =   JFS_COUPLE_R     -   update_time_step
            if      JFS_COUPLE_R    <  0                                        then
                    JFS_COUPLE_R    =  0
                    dispatch_action(nil,Keys.iCommandRightEngineStart,0)
                    dev:performClickableAction(device_commands.ENG_JFS,     0, false)

            end
        end
        if          ENG_ECC_L       ==  -1                                      then
                    set_aircraft_draw_argument_value(90,1)
            if      ENG_ECC_L_T     >   0                                       and
                    ENG_ECC_L_T     ~=  -1                                      then
                    ENG_ECC_L_T     =   ENG_ECC_L_T     -   update_time_step
                if  ENG_ECC_L_T     <=  0                                       then
                    ENG_ECC_L_T     =   ECC_OFF_TIMER

        
                    if  sensor_data.getEngineLeftRPM()      >   100             then
                        dispatch_action(nil,Keys.iCommandThrottle1Decrease)
                        ENG_L_DCNT  =   ENG_L_DCNT      +   1                      
       
                    end
                end
            end        
        end
        if          ENG_ECC_L       ==  1                                       then
            if      ENG_L_DCNT      >   0                                       then
                    dispatch_action(nil,Keys.iCommandThrottle1Increase)
                    ENG_L_DCNT      =   ENG_L_DCNT      -   1                                     
            end
        end
        if          ENG_ECC_R       ==  -1                                      then
                    set_aircraft_draw_argument_value(89,1)
            if      ENG_ECC_R_T     >   0                                       and
                    ENG_ECC_R_T     ~=  -1                                      then
                    ENG_ECC_R_T     =   ENG_ECC_R_T     -   update_time_step
                if  ENG_ECC_R_T     <=  0                                       then
                    ENG_ECC_R_T     =   ECC_OFF_TIMER

        
                    if  sensor_data.getEngineRightRPM()      >   100             then
                        dispatch_action(nil,Keys.iCommandThrottle2Decrease)
                        ENG_R_DCNT  =   ENG_R_DCNT      +   1                      
       
                    end
                end
            end        
        end
        if          ENG_ECC_R       ==  1                                       then
            if      ENG_R_DCNT      >   0                                       then
                    dispatch_action(nil,Keys.iCommandThrottle2Increase)
                    ENG_R_DCNT      =   ENG_R_DCNT      -   1                                     
            end
        end
        if          sensor_data.getEngineRightRPM()         >   17              and
                    sensor_data.getEngineLeftRPM()          >   17              and
                    ENG_STARTER_R                           ==  1               then
                    dev:performClickableAction(device_commands.ENG_STARTER,-1, false)
                
        end
        if          sensor_data.getEngineRightRPM()         >   65              then
                    dev:performClickableAction(device_commands.ENG_MASTER_R,0, false)                
        end 
        if          sensor_data.getEngineLeftRPM()         >   65              then
                    dev:performClickableAction(device_commands.ENG_MASTER_L,0, false)                
        end
  
                
    
            
    
        PARAMENG_STARTER_LT:set(ENG_STARTER_LT)
        PARAMENG_STARTER_R:set(ENG_STARTER_R)
        PARAMENG_STARTER_S:set(ENG_STARTER_S)
        ENCS:set(PROC)
           
    end

need_to_be_closed = false -- close lua state after initialization


--[[    ENG_ECC_L_T     =   ECC_OFF_TIMER
        90
        89
        iCommandThrottleIncrease                    =   1032;
        iCommandThrottleDecrease                    =   1033;
        iCommandThrottleStop                        =   1034;
        iCommandThrottle1Increase	                =   1035;
        iCommandThrottle1Decrease	                =   1036;
        iCommandThrottle1Stop	                    =   1037;
        iCommandThrottle2Increase	                =   1038;
        iCommandThrottle2Decrease	                =   1039;
        iCommandThrottle2Stop	                    =   1040;
        iCommandLeftEngineStart                     =   311;
        iCommandRightEngineStart                    =   312;
        iCommandLeftEngineStop                      =   313;
        iCommandRightEngineStop                     =   314;

]]