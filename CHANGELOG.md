# 23/04/2023 v1.1.1e-beta

Removed the popup

# 28/09/2022 v1.1.1b-beta

Changed the installation method.
    Look in the install file
F-15C
.Fixed Illumination Cocpit Issue
.Fixed Bingo Fuel Issue    
# 24/09/2022 v1.1.1a-beta
Su-25
.Fixed Salvo Control 
    Was not moving two notches at a time.
Su-25T
.Fixed misplacement of landing gear lever connector
    Was not moving

MiG-29S/A/G
.Fixed misplacement of landing gear lever connector
.Fixed bug about electro Electro-Optical System On/Off
.Fixed bug about Radar On/Off

F-15C
.Fixed throttle connectors location

Rework of the F-15C part.
The mod uses the connectors already provided in the cockpit and can thus use the animations.

Creation of a customized countermeasure system.
    .Choose, Chaff, Flares, or both, by operating a switch.
    .Two modes supported, Manual, or Semi Automatic.
    .Important, see the INSTALL and follow the instructions to make it work.

Creation of a lighting management system..
    .The LDG/TAXI light lever is now functional.
    .The navigation lights are adjustable in intensity, and can now flash.
    .The anti-collision lights are managed independently and are activated with their own switch.
    .The cockpit lighting can be activated by manipulating a switch, and is adjustable by manipulating a rotary.
    .You can now turn off the formation lights by turning the relevant knob to OFF.

Many other animations integrated. Most are cosmetic, but some others are usable.
Work still in progress

# 03/06/2022 v1.0.2c-beta

Added Help Images produced by @denissoliveira#9693 thanks to him.

All 
.Added_Message  Next/Previous Waypoint, Airfield now triggers a user message             

Su-27/J-11A
.Added Launch Permission Override
.Moved Radar Pulse Repeat Frequency Select
.Moved Electro-Optical System On/Off
.Added Receive Mode
.Removed HOTAS Target Unlock (Throttle)
.Added HOTAS Communication menu (Throttle)

Su-33
.Added Launch Permission Override
.Moved Radar Pulse Repeat Frequency Select
.Moved Electro-Optical System On/Off
.Added Receive Mode
.Removed HOTAS Target Unlock (Throttle)
.Added HOTAS Communication menu (Throttle)

MiG-29S/A/G
.Added Launch Permission Override

Su-25T
.Moved Canopy Lever 
    Now follows the canopy and lever
.Fixed Laser Ranger
    Was not working    

Su-25
.Moved Canopy Lever 
    Now follows the canopy and lever
.Removed HOTAS Autopilot - Transition To Level Flight Control
.Removed HOTAS Autopilot - Reset
.Added HOTAS Target Designator To Center
 
F-15C
.Added Illumination Cockpit
.Added HUD Color
.Fixed Gear Light Near/Far/Off Bug
       The command was executing twice
.Fixed T/O Trim
        Renamed "Autopilot Disengage" to "T/O Trim" and fixed the command
.Moved Navigation lights
.Added Anti-collision lights
        
# 21/05/2022 v1.0.2a-beta

Fixed issues
.Interference issue with All Modules
    Reworked mod logic. 
    The mod only starts if the aircraft is supported.

Su-27/J-11A
.Moved Scan Zone Left
.Moved Scan Zone Right
.Removed Scan Zone Up
.Removed Scan Zone Down
.Added Scan Zone Up/Down 

Su-33
.Moved Scan Zone Left
.Moved Scan Zone Right
.Removed Scan Zone Up
.Removed Scan Zone Down
.Added Scan Zone Up/Down 

MiG-29A/G/S
.Added Scan Zone Up/Down

Su-25T
.Removed HOTAS Target Lock (Handle)
.Added HOTAS Quick A-A to A-G Switch

Su-25
.Removed HOTAS Target Lock (Handle)
.Added HOTAS Quick A-A to A-G Switch
.Fixed ASP-17 Glass Up/Down (Only cycled down)

F-15C
.Added          Bingo Fuel Index CW/CCW
.Label_Change   Radar Off
            >   Radar On/Off 
.Label_Change   Parking Brakes
            >   Emergency Brakes 
                (Left Click):Engage  
                (Right Click):Disengage
.Added_Message  Emergency Brakes now triggers a user message             
A-10A
.Label_Change   Wheel Brake
            >   Emergency Brakes 
                (Left Click):Engage  
                (Right Click):Disengage 
.Added_Message  Emergency Brakes now triggers a user message                




# 12/05/2022 v1.0.1c-beta
Fixed issues
.Interference issue with F-16I SUFA Module
F-15C
.Added HOTAS Target Lock
.Added HOTAS Radar - Return To Search/NDTWS
.Added HOTAS Weapon Change
.Added HOTAS Weapon Release
.Added HOTAS Target Designator
.Added HOTAS Trim Controler

# 11/05/2022 v1.0.1b-beta
Su-25
.Fixed  Target Designator Issue
F-15C
.Fixed  Radar Scan Zone Up/Down Issue
.Label_Change   Fuel Quantity Selector  (Click) Fuel Quantity Selector (Scroll)
            >   Fuel Indicator  
                (Click):Quantity Test  
                (Scroll):Quantity Selector
.Label_Change   RWR Mode Select (Click) RWRSound Signals Volume Up/Down (Scroll)
            >   "RWR  
                (Click):Mode Select  
                (Scroll):Signals Volume Up/Down"
.Label_Change   Emergency Brake 
            >   Parking Brakes  
                (Left Click):Engage  
                (Right Click):Disengage
.Label_Change   Master Modes Select 
            >   Master Combat Mode 
                Beyond Visual Range
                Close Air Combat Vertical Scan 
                Close Air Combat Bore 
                Longitudinal Missile Aiming /FLOOD mode
.Fixed Master Combat Mode Issue                      

# 10/05/2022 v1.0.1-beta
F-15C
    .Removed Flight Clock Start/Stop/Reset
        [The F-15C does not support this command]
    .Fixed Emergency Brake
    .Fixed Master Modes Select
        [Need further testings]
    .Fixed Gear Light Near/Far/Off
    .Fixed Navigation Modes
        [Need further testings]
    .Fixed Radar On/Off
        [Need further testings]

# 09/05/2022 v1.0.0-beta

F-15C
    .Moved Engine Left Start
    .Moved Engine Right Start 
    .Added HUD Brightness Up/Down
    .Added Altimeter Pressure Increase/Decrease
    .Added Elapsed Time Clock Start/Stop/Reset
    .Added Flight Clock Start/Stop/Reset
    .Added Eject (3 times)
    .Added Emergency Brake
    .Added Fuel Dump
    .Added Weapons Jettison
    .Added Emergency Jettison
    .Added Fuel Tanks Jettison
    .Added Master Modes Select    
    .Added Navigation lights
    .Added Gear Light Near/Far/Off
    .Added Next/Previous Waypoint, Airfield
    .Added ECM
    .Added Navigation Modes
    .Added RWR/SPO Mode Select
    .Added RWR/SPO Sound Signals Volume Up/Down
    .Added Radar On/Off
    .Added Radar Pulse Repeat Frequency Select
    .Added Radar RWS/TWS Mode Select
    .Added Radar Scan Zone Increase/Decrease 
    .Added Radar Scan Zone Up/Down
    .Added Radar Display Zoom In/Out
    .Added Fuel Dump On
    .Added Fuel Dump Off
    .Added Refueling Bay
    .Added Fuel Dump
    .Added Refueling Bay
    .Added CAS Yaw
    .Added CAS Roll
    .Added CAS Pitch
    .Added Autopilot - Altitude Hold
    .Added Autopilot - Attitude Hold
    .Added Autopilot Disengage
    .Added Fuel Quantity Selector (Click) Fuel Quantity Selector (Scroll)
    .Added Countermeasures Continuously Dispense
    .Added HOTAS Airbrake
    .Added HOTAS Flaps Up/Down
    .Added HOTAS Weapon Change
    .Added HOTAS Countermeasures Release
    
    

 

# 09/05/2022 v0.3.0-alpha

Fixed issues
.Interference issue with Eurofighter Module
.Interference issue with PUCARA Module
.Interference issue with WW1FlyingCircus Module
.Interference issue with RAFB Module
    .Issue with Ripple Quantity Select/SPPU select on Su-25T,Su-25

General Improvement
    .Added a new method to retrieve parameters from flight controls without crashing the game when killed.

Su-33
    .Added HOTAS Target Designator
    .Added HOTAS Trim Controler
    .Added HOTAS Autopilot - Transition To Level Flight Control
    .Added HOTAS Autopilot - Reset
    .Added HOTAS AA Modes Select
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever
    .Added HOTAS Airbrake
    .Added HOTAS Countermeasures Release
    .Added HOTAS Target Unlock
    .Added HOTAS Target Lock
    .Added HOTAS Weapon Change

Su-27/J-11A
    .Added HOTAS Target Designator
    .Added HOTAS Trim Controler
    .Added HOTAS Autopilot - Transition To Level Flight Control
    .Added HOTAS Autopilot - Reset
    .Added HOTAS AA Modes Select
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever
    .Added HOTAS Airbrake
    .Added HOTAS Countermeasures Release
    .Added HOTAS Target Unlock
    .Added HOTAS Target Lock
    .Added HOTAS Weapon Change

A-10A 
    .Fixed Navigation lights bug
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever
    .Added HOTAS Weapon Change
    .Added HOTAS Target Lock 
    .Added HOTAS Airbrake

MiG-29S/A/G
    .Added HOTAS Target Designator
    .Added HOTAS Trim Controler
    .Added HOTAS Airbrake
    .Added HOTAS Countermeasures Release
    .Added HOTAS Target Unlock
    .Added HOTAS Target Lock
    .Added HOTAS Autopilot - Transition To Level Flight Control
    .Added HOTAS Autopilot - Reset
    .Added  Canopy Open/Close
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever

Su-25T
    .Added HOTAS Target Designator
    .Added HOTAS Trim Controler
    .Added HOTAS Autopilot - Transition To Level Flight Control
    .Added HOTAS Autopilot - Reset
    .Added HOTAS Airbrake
    .Added HOTAS Flaps Up/Down
    .Added HOTAS Countermeasures Release
    .Added HOTAS Target Unlock
    .Added HOTAS Target Lock
    .Added  Canopy Open/Close
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever

Su-25
    .Added HOTAS Target Designator
    .Added HOTAS Trim Controler
    .Added HOTAS Autopilot - Transition To Level Flight Control
    .Added HOTAS Autopilot - Reset
    .Added HOTAS Airbrake
    .Added HOTAS Countermeasures Chaff Dispense
    .Added HOTAS Countermeasures Flares Dispense
    .Added HOTAS Flaps Up/Down
    .Added  Canopy Open/Close
    .Toggle Mirrors         Now follow the canopy
    .Landing Gear Up/Down   Now follow the lever

Added F-15C Support
    .Added Canopy Open/Close
    .Added Engine Left Start
    .Added Engine Right Start
    .Added Engine Left Stop
    .Added Engine Right Stop
    .Added Landing Gear Up/Down
    .Added Electric Power Switch
    .Added Toggle Mirrors 



# 12/04/2022 v0.2.5-alpha

Added A-10A Support
    .Added Weapon Change
    .Added PRS/SGL Release Submodes Cycle
    .Added Toggle Mirrors
    .Added Refueling Port
    .Added Navigation Modes
    .Added Altimeter Pressure Increase/Decrease
    .Added Canopy Open/Close
    .Added Eject (3 times)
    .Added Flaps Up/Down
    .Added Gear Light Near/Far/Off
    .Added Landing Gear Up/Down
    .Added ECM
    .Added Weapons Jettison
    .Added Master Modes Select
    .Added Trim Controler
    .Added Electric Power Switch
    .Added HUD Brightness Up/Down
    .Added Engine Left Start
    .Added Engine Right Start
    .Added Engine Left Stop
    .Added Engine Right Stop
    .Added Navigation lights
    .Added Next/Previous Waypoint, Airfield
    .Added RWR/SPO Mode Select
    .Added RWR/SPO Sound Signals Volume Up/Down
    .Added Audible Warning Reset
    .Added Wheel Brake
    .Added Countermeasures Chaff Dispense
    .Added Countermeasures Flares Dispense
    .Added Countermeasures Continuously Dispense
    .Added Elapsed Time Clock Start/Stop/Reset
    .Added Ripple Interval Increase/Decrease
    .Added Ripple Quantity Increase

MiG-29S/A/G
    .Added Gear Light Near/Far/Off

# 02/04/2022 v0.2.4-alpha

Added Su-25 Support
    .Added Flight Clock Start/Stop/Reset
    .Added Elapsed Time Clock Start/Stop/Reset
    .Added Eject (3 times)
    .Added Emergency Brake
    .Added Engine Left Start
    .Added Engine Right Start
    .Added Engine Left Stop
    .Added Engine Right Stop
    .Added Weapons Jettison
    .Added Emergency Jettison
    .Added Fuel Tanks Jettison
    .Added Navigation lights
    .Added Nose Wheel Steering
    .Added Electric Power Switch
    .Added RWR/SPO Mode Select
    .Added RWR/SPO Sound Signals Volume Up/Down
    .Added Audible Warning Reset
    .Added Gear Light Near/Far/Off
    .Added ECM
    .Added Ripple Interval Increase/Decrease.
    .Added Ripple Quantity Select/SPPU select
    .Added Altimeter Pressure Increase/Decrease
    .Added Dragging Chute
    .Added Flaps Up/Down
    .Added Flaps Landing Position
    .Added ASP-17 Glass Up/Down
    .Added Navigation Modes
    .Added Countermeasures Continuously Dispense
    .Added Countermeasures Dispense
    .Added Toggle Mirrors
    .Added Landing Gear Up/Down
    .Added HUD Brightness Up/Down
    .Added HUD Color
    .Added Laser Ranger On/Off
    .Added Gunsight Reticle Switch
    .Added Master Modes Select
    .Added Target Designator Up/Down
    .Added Target Designator Left/Right
    .Added Target Lock
    .Added Target UnLock


# 23/03/2022 v0.2.3-alpha
Fixed issues
    .Cockpit liveries problems.
    .The game crashes when you are killed.
    .Problem with cockpit lighting.
    .Problem with SRS
    
Removed 
    .All the moving connectors.
    
Enhancements
    .Added menu icons

# 20/03/2022 v0.2.2-alpha
Fixed issues
    .Cockpit liveries are no longer supported since the position of connectors can move since v0.2.0-alpha
    
# 19/03/2022 v0.2.1-alpha
Fixed issues
    .The player spawns in the cockpit of the Su-25T instead of the cockpit of the chosen aircraft
Known issues
    .Cockpit liveries are no longer supported since the position of connectors can move since v0.2.0-alpha

# 18/03/2022 v0.2.0-alpha

Changelog now in descending order

Fixed issues
.Interference issue with AH-64D Module
.Interference issue with AH-6 Module
.Interference issue with Rafale Module
    .Some buttons were not giving consistent output
    .Position of connectors was not updated

Enhancements

Su-25T
    .Added LLTV Night Vision On/Off
    .Added ELINT Pod On/Off
    .Added Laser Ranger On/Off
    .Added (FLIR or LLTV) On/Off
    .Added Gear Light Near/Far/Off
    .Added Parachute Deployment
    .Added Parachute Release
    .Added Animated HOTAS Target Designator
    .Added Animated HOTAS Trim Controler
    .Added Animated HOTAS Airbrake
    .Added Animated HOTAS Countermeasures Release
    .Added Animated HOTAS Target Lock
    .Added Animated HOTAS Autopilot - Transition To Level Flight Control
    .Added Animated HOTAS Autopilot - Reset
    .Added Animated Canopy Open/Close
    .Added Animated Toggle Mirrors
    .Added Animated Landing Gear Up/Down

MiG-29S/A/G
    .Added Animated HOTAS Target Designator
    .Added Animated HOTAS Trim Controler
    .Added Animated HOTAS Airbrake
    .Added Animated HOTAS Countermeasures Release
    .Added Animated HOTAS Target Unlock
    .Added Animated HOTAS Target Lock
    .Added Animated HOTAS Autopilot - Transition To Level Flight Control
    .Added Animated HOTAS Autopilot - Reset
    .Added Animated Canopy Open/Close
    .Added Animated Toggle Mirrors
    .Added Animated Landing Gear Up/Down

Su-33
    .Added Animated HOTAS Target Designator
    .Added Animated HOTAS Trim Controler
    .Added Animated HOTAS Airbrake
    .Added Animated HOTAS Countermeasures Release
    .Added Animated HOTAS Target Unlock
    .Added Animated HOTAS Target Lock
    .Added Animated HOTAS Weapon Change
    .Added Animated HOTAS Autopilot - Transition To Level Flight Control
    .Added Animated HOTAS Autopilot - Reset
    .Added Animated Toggle Mirrors
    .Added Animated Landing Gear Up/Down

Su-27/J-11A
    .Added Animated HOTAS Target Designator
    .Added Animated HOTAS Trim Controler
    .Added Animated HOTAS Autopilot - Transition To Level Flight Control
    .Added Animated HOTAS Autopilot - Reset
    .Added Animated HOTAS AA Modes Select
    .Added Animated Toggle Mirrors
    .Added Animated Landing Gear Up/Down



# 28/02/2022 v0.1.8-alpha

Changelog now in descending order

Added LowFidelityAircraftManual by Zeitgeist. 

Enhancements
Su-27/J-11A
    .Added Parachute Deployment
    .Added Parachute Release
    .Added Animated HOTAS Airbrake
    .Added Animated HOTAS Countermeasures Release
    .Added Animated HOTAS Target Unlock
    .Added Animated HOTAS Target Lock
    .Added Animated HOTAS Weapon Change


# 16/02/2022 v0.1.7-alpha

Fixed issues
.Interference issue with Bell-47 Module

Enhancements
Su-25T
    .Added Master Modes Select
    .Added Next/Previous Waypoint, Airfield

Su-27/J-11A/Su-33/
    .Moved Radar On/Off connector
    .Moved Electro-Optical System On/Off connector
    .Added Master Modes Select
    .Added Radar RWS/TWS Mode Select
    .Added Radar Pulse Repeat Frequency Select
    .Added Master Modes Select
    .Added Next/Previous Waypoint, Airfield

Added MiG-29S and Mig-29A Support
    .Added Canopy Open/Close
    .Added Flight Clock Start/Stop/Reset
    .Added Elapsed Time Clock Start/Stop/Reset
    .Added Eject (3 times)
    .Added Engine Left Start
    .Added Engine Right Start
    .Added Engine Left Stop
    .Added Engine Right Stop
    .Added Landing Gear Up/Down
    .Added HUD Brightness Up/Down
    .Added HUD Color
    .Added HUD Color Filter On/Off
    .Added Weapons Jettison
    .Added Emergency Jettison
    .Added Fuel Tanks Jettison
    .Added Navigation lights
    .Added Navigation Modes
    .Added Electric Power Switch
    .Added RWR/SPO Mode Select
    .Added RWR/SPO Sound Signals Volume Up/Down
    .Added Audible Warning Reset
    .Added Flaps Up/Down
    .Added Master Modes Select
    .Added Radar RWS/TWS Mode Select
    .Added Radar Pulse Repeat Frequency Select
    .Added Next/Previous Waypoint, Airfield
    .Added Autopilot - Damper
    .Added Autopilot - Ground Collision Avoidance
    .Added Autopilot - Barometric Altitude Hold
    .Added Autopilot - Attitude Hold
    .Added Autopilot - Path Control
    .Added Autopilot - Transition To Level Flight Control
# 12/02/2022 v0.1.6-alpha

Fixed issues
.Interference issue with F-5E-3 Module
.Interference issue with AV8BNA Module
.Interference issue with Spitfire LF Mk. IX Module
.Interference issue with Bf-109K-4 Module 
.Interference issue with P-47D-40 Module
.Interference issue with P-47D-30bl1 Module       
.Interference issue with SA342L Module
.Interference issue with SA342M Module
.Interference issue with SA342Minigun Module
.Interference issue with SA342Mistral Module
.Interference issue with C-101CC Module
.Interference issue with C-101EB Module
.Interference issue with FW-190A8 Module
.Interference issue with L-39C Module
.Interference issue with L-39ZA Module
.Interference issue with P-51D-30-NA Module
.Interference issue with P-51D Module

Su-25T
    . Solved Su-25T Possible bug between Attitude Hold Autopilot and Auto pilot Reset #32 
Su-27/J-11A/Su-33/
    . Solved "Internal Lights Switch Missing #38"
Enhancements
Su-25T 
    .Moved the cannopy connector
    .Added ECM
    .Added IR Jamming
    .Added Ripple Interval Increase/Decrease.
    .Added Ripple Quantity Select/SPPU select
    .Added Cut Of Burst select
    .Added Dragging Chute

# 09/02/2022 v0.1.5-alpha
Fixed issues
.Interference issue with Yak-52 Module
.Interference issue with MOSQUITOFBMKVI Module
.Interference issue with Mi-8MT Module
Enhancements
Added Su-25T Support
    .Added Altimeter Pressure Increase/Decrease
    .Added Autopilot - Attitude Hold
    .Added Autopilot - Altitude And Roll Hold
    .Added Autopilot - Transition To Level Flight Control
    .Added Autopilot - Route following
    .Added Autopilot - Radar Altitude Hold
    .Added Canopy Open/Close
    .Added Flight Clock Start/Stop/Reset
    .Added Elapsed Time Clock Start/Stop/Reset
    .Added Eject (3 times)
    .Added Emergency Brake
    .Added Engine Left Start
    .Added Engine Right Start
    .Added Engine Left Stop
    .Added Engine Right Stop
    .Added Landing Gear Up/Down
    .Added HUD Brightness Up/Down
    .Added HUD Color
    .Added HUD Color Filter On/Off
    .Added Weapons Jettison
    .Added Emergency Jettison
    .Added Fuel Tanks Jettison
    .Added Navigation lights
    .Added Navigation Modes
    .Added Nose Wheel Steering
    .Added Electric Power Switch
    .Added RWR/SPO Mode Select
    .Added RWR/SPO Sound Signals Volume Up/Down
    .Added Audible Warning Reset
    .Added Flaps Up/Down
    .Added Flaps Landing Position

# 05/02/2022 v0.1.4-alpha

Fixed issues
.Interference issue with Su-25T Module
.Interference issue with TF-51D Module
Su-27/33/J-11A
    .AP Auto button should be Attitude Hold #21 
    ."Toggle Mirrors" action still appears when cockpit is open #24 
        -Reduced the number of Mirror connectors to one, and lowered the position a bit. 
    . Scroll down knobs fails #23 
        -The scrollUp and scrollDown actions now work correctly. 

Enhancements
Su-27/33/J-11A
    .The user no longer has to type LAlt+C to enable interactions at startup.
    .Added Altimeter Pressure Increase/Decrease

# 01/02/2022 v0.1.3-alpha

Fixed interference issue with F-86F Sabre Module
Fixed interference issue with UH-60L Mod
Fixed interference issue with A-10C_2 Module

Su-27/33/J-11A

Added RWR/SPO Mode Select 
Added RWR/SPO Sound Signals Volume Up/Down 
Added Audible Warning Reset 
Added Display Zoom In & Display Zoom Out 
Added Flight Clock Start/Stop/Reset 
Added Elapsed Time Clock Start/Stop/Reset" 

Su-33

Added Autopilot - Ground Collision Avoidance

# 31/01/2022  v0.1.2-alpha

Updated Entry.lua to avoid conflicts with other mods
Please report conflicts by opening an issue on GitHub and uploading the mod's entry.lua file.

# 30/01/2022  v0.1.1-alpha

Fixed UI visual bug on Clickable Module Special Options panel
Added CHANGELOG.md
Added Patreon Support

# 30/01/2022  v0.1.0-alpha

Added for Su-27/33

-Engine Inlet Grids Auto/Off    
-Emergency Brake
-Nose Wheel Steering
-Eject (3 times)

Added for Su/33

-Autothrust
-Autothrust - Increase Velocity
-Autothrust - Decrease Velocity
-ASC Refueling Mode
-Refueling Boom
-Special Afterburner Mode
-Aerial Refueling Lights
-Tail Hook
-Emergency Tail Hook
-Folding Wings

# 29/01/2022  v0.0.4-alpha

Added Su-33 Support

# 27/01/2022  v0.0.3-alpha

Added clickables Mirrors.

# 26/01/2022  v0.0.2-alpha

Mainpanel now only calls the edm file if get_aircraft_type() returns Su-27 or J-11A.

# 26/01/2022  v0.0.1-alpha

Added Edm file containing the connectors.
Setting up the option menu.
Lua command coding to link connectors and avionics.
