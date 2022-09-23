
dofile(LockOn_Options.script_path.."devices.lua")
dofile(LockOn_Options.script_path.."command_defs.lua")
dofile(LockOn_Options.script_path.."utils.lua")
--dofile(lfs.writedir() .. 'Mods\\Services\\DCS-SRS\\Scripts\\DCS-SimpleRadioStandalone.lua')


local update_time_step = 0.02 --update will be called 50 times per second
make_default_activity(update_time_step) 
sensor_data = get_base_data()
local dev = GetSelf()
local aircraft = get_aircraft_type()
--------------------------------------------------------------------
local RADIO_CHAN_TENS   = get_param_handle("RADIO_CHAN_TENS")
local RADIO_CHAN_ONES   = get_param_handle("RADIO_CHAN_ONES")
local RADIO_FREQ1_TENS  = get_param_handle("RADIO_FREQ1_TENS")
local RADIO_FREQ1_ONES  = get_param_handle("RADIO_FREQ1_ONES")
local RADIO_FREQ2       = get_param_handle("RADIO_FREQ2")
local RADIO_FREQ3_CENTS = get_param_handle("RADIO_FREQ3_CENTS")
local RADIO_FREQ3_TENS  = get_param_handle("RADIO_FREQ3_TENS")
local RADIO_FREQ3_ONES  = get_param_handle("RADIO_FREQ3_ONES")
local RADIO_SRS_TEST    = get_param_handle("RADIO_SRS_TEST")

local radio_chan        = 0
local radio_freq1       = 0
local radio_freq2       = 0
local radio_freq3       = 0
local radio_freq3m      = 0
local radio_freq3c      = 0
local radio_draw_chan   = 0
local radio_draw_freq1  = 0
local radio_draw_freq2  = 0
local radio_draw_freq3  = 0
local radio_draw_freq3m = 0
local radio_draw_freq3c = 0
local radio_freq_srs


function radio_draw_chan(count)
    local tens  = math.floor(count/10 + 0.02)
    local ones  = math.floor(count%10 + 0.01)
    RADIO_CHAN_TENS:set(tens/10)
    RADIO_CHAN_ONES:set(ones/10)
end
function radio_draw_freq1(count)
    local tens  = math.floor(count/10 + 0.02)
    local ones  = math.floor(count%10 + 0.01)
    RADIO_FREQ1_TENS:set(tens/10)
    RADIO_FREQ1_ONES:set(ones/10)
end
function radio_draw_freq2(count)
    local ones  = math.floor(count%10 + 0.02)
    RADIO_FREQ2:set(ones/10)
end
function radio_draw_freq3m(count)
    local cents = math.floor(count/100 + 0.02)
    local ones  = math.floor(count%10 + 0.01)
    RADIO_FREQ3_CENTS:set(cents/10)
    RADIO_FREQ3_ONES:set(ones/10)
end
function radio_draw_freq3c(count)
    local tens  = math.floor(count/10 + 0.02)
    RADIO_FREQ3_TENS:set(tens/10)
end

function update_radio_display()
    radio_draw_chan(radio_chan)
    radio_draw_freq1(radio_freq1)
    radio_draw_freq2(radio_freq2)
    radio_draw_freq3m(radio_freq3m)
    radio_draw_freq3c(radio_freq3c)
end
function update_radio_srs()
    RADIO_SRS_TEST:set(radio_freq_srs)
    --print_message_to_user(RADIO_SRS_TEST:get())
end


function post_initialize()
    --print_message_to_user("DEV.RADIO_CONTROL_SYSTEM",0.2)
    dev:performClickableAction(device_commands.CLIC_RCHAN, 0.1, false) 
    dev:performClickableAction(device_commands.CLIC_RFREQ_1, 0.455, false) 
    dev:performClickableAction(device_commands.CLIC_RFREQ_2, 0.6, false) 
    dev:performClickableAction(device_commands.CLIC_RFREQ_3, 0.6, false) 


	local birth = LockOn_Options.init_conditions.birth_place
    dev:performClickableAction(device_commands.CLIC_RUHF, 0.5, false)
    dev:performClickableAction(device_commands.CLIC_RVOL, 0.66, false)
    if birth=="GROUND_HOT" or birth=="AIR_HOT" then
       


    elseif birth=="GROUND_COLD" then

    end

	

end












function SetCommand(command,value)
   
    --print_message_to_user(tostring(command).." = "..tostring(value))
    if  command ==  device_commands.CLIC_RCOMMENU           and
        value   ==  1                                       then
        dispatch_action(nil,Keys.iCommandToggleCommandMenu)
    end      
    
    if command == device_commands.CLIC_RFREQ_3 then
        radio_freq3 = round(radio_freq3 + 50*value)
        radio_freq3m = radio_freq3 % 1000
        radio_freq3c = radio_freq3 % 100
        --print_message_to_user("CLIC_RFREQ_3"..(value))
    end
    if command == device_commands.CLIC_RFREQ_2 then
        radio_freq2 = round(radio_freq2 + 50*value)
        radio_freq2 = radio_freq2 % 10
        --print_message_to_user(radio_freq2)                          --radio_freq2   Radio freq2 number, can be used to implement radios
    end
    if command == device_commands.CLIC_RFREQ_1 then
        radio_freq1 = round(radio_freq1 + 50*value)
        radio_freq1 = radio_freq1 % 100
        --print_message_to_user(radio_freq1)                          --radio_freq1   Radio freq1 number, can be used to implement radios
    end

    if command == device_commands.CLIC_RCHAN then
        radio_chan = round(radio_chan + 50*value)
        radio_chan = radio_chan % 100
                                                                    --radio_chan   Radio channel number, can be used to implement radios
    end
    radio_freq_srs = radio_freq1*10 + radio_freq2 + radio_freq3m/1000
    

end


 
    





function update()
    --print_message_to_user(RADIO_SRS_TEST:get())
    
    --[[
    if get_cockpit_draw_argument_value(272)~=get_cockpit_draw_argument_value(272) then
        print_message_to_user(get_cockpit_draw_argument_value(272))
    end]]

    update_radio_display()
    update_radio_srs()
end

need_to_be_closed = false -- close lua state after initialization


