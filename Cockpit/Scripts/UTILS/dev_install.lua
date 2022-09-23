dofile(lfs.writedir().."Config\\options.lua")
local   rep_source_ext      =   get_dcs_plugin_path("RedK0d Clickable").."\\DATA\\F15c_extended\\"                                                       -- Change this according to the versions
local   rep_source_not_ext  =   get_dcs_plugin_path("RedK0d Clickable").."\\DATA\\F15c_not_extended\\"
local   rep_source_utils    =   get_dcs_plugin_path("RedK0d Clickable").."\\DATA\\"

local   rep_dest_FC3        =   lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\"                                   --lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\Cockpit\\KneeboardRight\\"
local   rep_dest_F15C       =   lfs.currentdir().."Mods\\aircraft\\F-15C\\"                                            --lfs.currentdir().."Mods\\aircraft\\F-15C\\Cockpit\\KneeboardRight\\"
local   rep_input_F15C      =   lfs.currentdir().."Mods\\aircraft\\F-15C\\Input\\"
local   rep_input_FC3       =   lfs.currentdir().."Mods\\aircraft\\Flaming Cliffs\\Input\\F-15C\\"
local   mod_version         =   get_plugin_option_value("RedK0d Clickable", "Version", "local")
local   F15c_extended       =   0--get_plugin_option_value("RedK0d Clickable", "F15c_extended", "local")
local   present_FC3         =   options.plugins["FC3"]
local   present_F15C        =   options.plugins["F-15C"]
local   device_init_ext     =   "--[[CLICKABLE-FC3 ".. mod_version  .." F15c_extended]]"
local   device_init         =   "--[[CLICKABLE-FC3 ".. mod_version  .."]]"
local   date                =   os.date()
local   modified            =   "--[[Modified " .. date .. "]]"
local   entry_ext_f15c      =   "MAC_flyable('F-15C', current_mod_path..'/Cockpit/KneeboardRight/',nil, current_mod_path..'/Comm/F-15C.lua')"
local   entry_f15c          =   "MAC_flyable('F-15C', current_mod_path..'/Cockpit/KneeboardRight/',F15FM, current_mod_path..'/Comm/F-15C.lua')"
local   entry_ext_fc3       =   "make_flyable('F-15C'	, current_mod_path..'/Cockpit/KneeboardRight/',nil, current_mod_path..'/Comm/F-15C.lua')"
local   entry_fc3           =   "make_flyable('F-15C'	, current_mod_path..'/Cockpit/KneeboardRight/',F15FM, current_mod_path..'/Comm/F-15C.lua')"
local   FC3,F15C,up_to_date_fc3,up_to_date_f15c,up_to_date_fc3_ext,up_to_date_f15c_ext,first_run
local   blink_timer         = 0
local   blink_timer_s       = 1
---------------------------------------------------------------------------------------
-- File manipulation functions
local io, os, error = io, os, error
local filemanip = {}
function filemanip.exists(path)
    local file = io.open(path, 'rb')
    if file then
      file:close()
    end
    return file ~= nil
end
function filemanip.read(path, mode)
    mode = mode or '*a'
    local file, err = io.open(path, 'rb')
    if err then
      error(err)
    end
    local content = file:read(mode)
    file:close()
    return content
end
function filemanip.write(path, content, mode)
    mode = mode or 'w'
    local file, err = io.open(path, mode)
    if err then
      error(err)
    end
    file:write(content)
    file:close()
end
function filemanip.copy(src, dest)
    local content = filemanip.read(src)
    filemanip.write(dest, content)
end
function filemanip.move(src, dest)
    os.rename(src, dest)
end
function filemanip.remove(path)
    os.remove(path)
end
function        restart_dcs()
    dofile(LockOn_Options.script_path.."UTILS\\show_restart_window.lua")
end
--Editing input files
function F15C_editinput_k()
    local path = rep_input_F15C.."keyboard\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[78]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function F15C_editinput_j()
    local path = rep_input_F15C.."joystick\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[76]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function F15C_editentry()
    --print_message_to_user("F15C_editentry")
     local path = rep_dest_F15C.."entry.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
      if            F15c_extended       ==  0                   and
                    fileContent[80]     ~=  entry_f15c         then
                    filemanip.copy(rep_source_not_ext.."f15c_entry.lua",rep_dest_F15C.."entry.lua")
                    restart_dcs()                   
    elseif          F15c_extended       ==  1                   and
                    fileContent[80]     ~=  entry_ext_f15c     then
                    filemanip.copy(rep_source_ext.."f15c_entry.lua",rep_dest_F15C.."entry.lua")
                    restart_dcs()                   
    end     
end
function F15C_editdevice_init()
    local path = rep_dest_F15C.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    if              F15c_extended       ==  0                   and
                    fileContent[25]     ~=  device_init         then
                    fileContent[25]     =   device_init
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)
    elseif          F15c_extended       ==  1                   and
                    fileContent[25]     ~=  device_init_ext     then
                    fileContent[25]     =   device_init_ext
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)                    
    end      
end
function FC3_editinput_k()
    local path = rep_input_FC3.."keyboard\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[78]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function FC3_editinput_j()
    local path = rep_input_FC3.."joystick\\default.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
        if          fileContent[6]  ~=  '--[[Edited file by RedK0d]]'                                              then   
                    fileContent[4]  =  '})\n\n--[[Edited file by RedK0d]]\n\nlocal CMD_ONOFF    = 10000\n'
                    fileContent[76]  =   '\n-- RedK0d Countermeasures Custom Program\n{down = CMD_ONOFF,name = _(\'Countermeasures Custom Program\'),category = _(\'Countermeasures\'),features = {"Countermeasures"}},\n})\n'
        end
    file = io.open(path, 'w')
    for index, value in ipairs(fileContent) do
        file:write(value..'\n')
    end
    io.close(file)
end
function FC3_editentry()
    --print_message_to_user("FC3_editentry")
     local path = rep_dest_FC3.."entry.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
      if            F15c_extended       ==  0                   and
                    fileContent[134]     ~=  entry_fc3         then
                    filemanip.copy(rep_source_not_ext.."fc3_entry.lua",rep_dest_FC3.."entry.lua")
                    restart_dcs()                   
    elseif          F15c_extended       ==  1                   and
                    fileContent[134]     ~=  entry_ext_fc3     then
                    filemanip.copy(rep_source_ext.."fc3_entry.lua",rep_dest_FC3.."entry.lua")
                    restart_dcs()                   
    end     
end
function FC3_editdevice_init()
    local path = rep_dest_FC3.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    if              F15c_extended       ==  0                   and
                    fileContent[25]     ~=  device_init         then
                    fileContent[25]     =   device_init
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)
    elseif          F15c_extended       ==  1                   and
                    fileContent[25]     ~=  device_init_ext     then
                    fileContent[25]     =   device_init_ext
                    fileContent[26]     =   modified                         
                    file = io.open(path, 'w')
                    for index, value in ipairs(fileContent) do
                        file:write(value..'\n')
                    end
                    io.close(file)                    
    end      
end

function  F15C_extended()
    --print_message_to_user("F15C_extended")
    lfs.mkdir(rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS")
    lfs.mkdir(rep_dest_F15C.."Cockpit\\Textures\\F-15C-CPT-TEXTURES")
    lfs.mkdir(rep_dest_F15C.."Sounds")
    lfs.mkdir(rep_dest_F15C.."Sounds\\Effects")
    lfs.mkdir(rep_dest_F15C.."Sounds\\Effects\\Aircrafts")
    lfs.mkdir(rep_dest_F15C.."Sounds\\sdef")
    lfs.mkdir(rep_dest_F15C.."Sounds\\sdef\\Aircrafts")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\clickable_defs.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\clickable_defs.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\clickabledata.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\clickabledata.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\command_defs.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\command_defs.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\device_init.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\device_init.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\devices.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\devices.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\mainpanel_init.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\mainpanel_init.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\supported.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\supported.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\utils.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\utils.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua")  
    filemanip.copy(rep_source_ext.."Cockpit\\Shape\\cockpit_f-15c.edm.json",rep_dest_F15C.."Cockpit\\Shape\\cockpit_f-15c.edm.json")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready_spec.dds",rep_dest_F15C.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready_spec.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready.dds",rep_dest_F15C.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4.dds",rep_dest_F15C.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4_spec.dds",rep_dest_F15C.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4_spec.dds")
    filemanip.copy(rep_source_ext.."Liveries\\Cockpit_F-15C\\default\\description.lua",rep_dest_F15C.."Liveries\\Cockpit_F-15C\\default\\description.lua")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_OFF.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_OFF.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_ON.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_ON.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_OFF.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\ECC_OFF.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_ON.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\ECC_ON.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_CONTINUE.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_CONTINUE.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_START.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_START.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_STOP.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_STOP.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_CONTINUE.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_CONTINUE.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_START.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_START.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_STOP.ogg",rep_dest_F15C.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_STOP.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_CONTINUE.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_CONTINUE.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_START.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_START.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_STOP.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_STOP.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_CONTINUE.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_CONTINUE.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_START.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_START.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_STOP.sdef",rep_dest_F15C.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_STOP.sdef")
    filemanip.copy(rep_input_F15C.."keyboard\\default.lua",rep_input_F15C.."keyboard\\default.lua.backup")
    filemanip.copy(rep_input_F15C.."joystick\\default.lua",rep_input_F15C.."joystick\\default.lua.backup")
    F15C_editinput_k()
    F15C_editinput_j() 
    F15C_editentry()
    F15C_editdevice_init()
end
function  F15C_not_extended()
    --print_message_to_user("F15C_not_extended")
    lfs.mkdir(rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\clickable_defs.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\clickable_defs.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\clickabledata.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\clickabledata.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\command_defs.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\command_defs.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\device_init.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\device_init.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\devices.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\devices.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\mainpanel_init.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\mainpanel_init.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\supported.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\supported.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\utils.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\utils.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua",rep_dest_F15C.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua")  
    filemanip.copy(rep_source_not_ext.."Cockpit\\Shape\\cockpit_f-15c.edm.json",rep_dest_F15C.."Cockpit\\Shape\\cockpit_f-15c.edm.json")
    filemanip.copy(rep_source_not_ext.."Liveries\\Cockpit_F-15C\\default\\description.lua",rep_dest_F15C.."Liveries\\Cockpit_F-15C\\default\\description.lua")
    filemanip.copy(rep_input_F15C.."keyboard\\default.lua",rep_input_F15C.."keyboard\\default.lua.backup")
    filemanip.copy(rep_input_F15C.."joystick\\default.lua",rep_input_F15C.."joystick\\default.lua.backup")
    F15C_editinput_k()
    F15C_editinput_j() 
    F15C_editentry()
    F15C_editdevice_init()
end

function  FC3_extended()
    lfs.mkdir(rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS")
    lfs.mkdir(rep_dest_FC3.."Cockpit\\Textures\\F-15C-CPT-TEXTURES")
    lfs.mkdir(rep_dest_FC3.."Sounds")
    lfs.mkdir(rep_dest_FC3.."Sounds\\Effects")
    lfs.mkdir(rep_dest_FC3.."Sounds\\Effects\\Aircrafts")
    lfs.mkdir(rep_dest_FC3.."Sounds\\sdef")
    lfs.mkdir(rep_dest_FC3.."Sounds\\sdef\\Aircrafts")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\clickable_defs.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\clickable_defs.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\clickabledata.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\clickabledata.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\command_defs.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\command_defs.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\device_init.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\device_init.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\devices.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\devices.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\mainpanel_init.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\mainpanel_init.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\supported.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\supported.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\utils.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\utils.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua")
    filemanip.copy(rep_source_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua")  
    filemanip.copy(rep_source_ext.."Cockpit\\Shape\\cockpit_f-15c.edm.json",rep_dest_FC3.."Cockpit\\Shape\\cockpit_f-15c.edm.json")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready_spec.dds",rep_dest_FC3.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready_spec.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready.dds",rep_dest_FC3.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\jfs_ready.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4.dds",rep_dest_FC3.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4.dds")
    filemanip.copy(rep_source_ext.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4_spec.dds",rep_dest_FC3.."Cockpit\\Textures\\F-15C-CPT-TEXTURES\\correctedcockpit_texture_4_spec.dds")
    filemanip.copy(rep_source_ext.."Liveries\\Cockpit_F-15C\\default\\description.lua",rep_dest_FC3.."Liveries\\Cockpit_F-15C\\default\\description.lua")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_OFF.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_OFF.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_ON.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\ECC_CLOSED_ON.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_OFF.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\ECC_OFF.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\ECC_ON.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\ECC_ON.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_CONTINUE.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_CONTINUE.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_START.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_START.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_STOP.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_CLOSED_STOP.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_CONTINUE.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_CONTINUE.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_START.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_START.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_STOP.ogg",rep_dest_FC3.."Sounds\\Effects\\Aircrafts\\JFS_OPEN_STOP.ogg")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_CONTINUE.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_CONTINUE.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_START.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_START.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_STOP.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_CLOSED_STOP.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_CONTINUE.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_CONTINUE.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_START.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_START.sdef")
    filemanip.copy(rep_source_ext.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_STOP.sdef",rep_dest_FC3.."Sounds\\sdef\\Aircrafts\\JFS_OPEN_STOP.sdef")
    filemanip.copy(rep_input_FC3.."keyboard\\default.lua",rep_input_FC3.."keyboard\\default.lua.backup")
    filemanip.copy(rep_input_FC3.."joystick\\default.lua",rep_input_FC3.."joystick\\default.lua.backup")
    FC3_editinput_k()
    FC3_editinput_j() 
    FC3_editentry()
    FC3_editdevice_init()
end
function  FC3_not_extended()
    --print_message_to_user("FC3_not_extended")
    lfs.mkdir(rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\clickable_defs.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\clickable_defs.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\clickabledata.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\clickabledata.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\command_defs.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\command_defs.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\device_init.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\device_init.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\devices.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\devices.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\mainpanel_init.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\mainpanel_init.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\supported.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\supported.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\utils.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\utils.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\clickable.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\cmd_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\elec_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\engines_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\fuel_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\light_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\misc_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\radar_control.lua")
    filemanip.copy(rep_source_not_ext.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua",rep_dest_FC3.."Cockpit\\KneeboardRight\\SYSTEMS\\radio_control.lua")  
    filemanip.copy(rep_source_not_ext.."Cockpit\\Shape\\cockpit_f-15c.edm.json",rep_dest_FC3.."Cockpit\\Shape\\cockpit_f-15c.edm.json")
    filemanip.copy(rep_source_not_ext.."Liveries\\Cockpit_F-15C\\default\\description.lua",rep_dest_FC3.."Liveries\\Cockpit_F-15C\\default\\description.lua")
    filemanip.copy(rep_input_FC3.."keyboard\\default.lua",rep_input_FC3.."keyboard\\default.lua.backup")
    filemanip.copy(rep_input_FC3.."joystick\\default.lua",rep_input_FC3.."joystick\\default.lua.backup")
    FC3_editinput_k()
    FC3_editinput_j() 
    FC3_editentry()
    FC3_editdevice_init()
end
---------------------------------------------------------------------------------------
--Checks if installalation status
function F15C_check()
    --print_message_to_user("F15C_check")
    local path = rep_dest_F15C.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    F15C_not_extended()
    if              F15c_extended       ==  1                   and
                    fileContent[25]     ~=  device_init_ext     then
                    F15C_extended()                        
    end      
end
function FC3_check()
    --print_message_to_user("FC3_check")
    local path = rep_dest_FC3.."Cockpit\\KneeboardRight\\device_init.lua"
    local file = io.open(path, 'r')
    local fileContent = {}
    for line in file:lines() do
        table.insert (fileContent, line)
    end
    io.close(file)
    FC3_not_extended()
    if              F15c_extended       ==  1                   and
                    fileContent[25]     ~=  device_init_ext     then
                    FC3_extended()                        
    end         
end
---------------------------------------------------------------------------------------
if      present_FC3                                     then
        FC3                 =   true
else
        FC3                 =   false
end
if      present_F15C                                    then
        F15C                =   true
else
        F15C                =   false
end

---------------------------------------------------------------------------------------


if                  F15C                ==  true                                        then
                    F15C_check()                      
end
if                  FC3                 ==  true                                        then
                    FC3_check()
end
---------------------------------------------------------------------------------------
--Installation Functions
--me_ProductType.getType()




