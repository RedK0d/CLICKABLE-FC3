
local  aircraft = get_aircraft_type()

if  aircraft=="F-15C"                       then
    shape_name		   = "Cockpit_F-15C"
end

is_EDM			   = true
new_model_format   = true
ambient_light    = {255,255,255}
ambient_color_day_texture    = {72, 100, 160}
ambient_color_night_texture  = {40, 60 ,150}
ambient_color_from_devices   = {50, 50, 40}
ambient_color_from_panels	 = {35, 25, 25}

dusk_border					 = 0.4
draw_pilot					 = false

external_model_canopy_arg	 = 38

use_external_views = false

day_texture_set_value   = 0.0
night_texture_set_value = 0.1

local controllers = LoRegisterPanelControls()

RADIO_CHAN_TENS                         = CreateGauge("parameter")
RADIO_CHAN_TENS.arg_number              = 348
RADIO_CHAN_TENS.input                   = {0.0, 1.0}
RADIO_CHAN_TENS.output                  = {0.0, 1.0}
RADIO_CHAN_TENS.parameter_name          = "RADIO_CHAN_TENS"

RADIO_CHAN_ONES                         = CreateGauge("parameter")
RADIO_CHAN_ONES.arg_number              = 349
RADIO_CHAN_ONES.input                   = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}             --Animation calibration.
RADIO_CHAN_ONES.output                  = {0.4,0.5,0.6,0.7,0.8,0.9,1.0,0.1,0.2,0.3,0.39}            --Animation calibration.
RADIO_CHAN_ONES.parameter_name          = "RADIO_CHAN_ONES"

RADIO_FREQ1_TENS                           = CreateGauge("parameter")
RADIO_FREQ1_TENS.arg_number              = 350
RADIO_FREQ1_TENS.input                   = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ1_TENS.output                  = {0.8,0.9,1.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.79}
RADIO_FREQ1_TENS.parameter_name          = "RADIO_FREQ1_TENS"

RADIO_FREQ1_ONES                           = CreateGauge("parameter")
RADIO_FREQ1_ONES.arg_number              = 351
RADIO_FREQ1_ONES.input                   = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ1_ONES.output                  = {0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.0,0.1,0.2,0.29}
RADIO_FREQ1_ONES.parameter_name          = "RADIO_FREQ1_ONES"

RADIO_FREQ2                             = CreateGauge("parameter")
RADIO_FREQ2.arg_number                  = 352
RADIO_FREQ2.input                       = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ2.output                      = {0.4,0.5,0.6,0.7,0.8,0.9,1.0,0.1,0.2,0.3,0.39}
RADIO_FREQ2.parameter_name              = "RADIO_FREQ2"

RADIO_FREQ3_CENTS                       = CreateGauge("parameter")
RADIO_FREQ3_CENTS.arg_number            = 353
RADIO_FREQ3_CENTS.input                 = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ3_CENTS.output                = {0.7,0.8,0.9,0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.69}
RADIO_FREQ3_CENTS.parameter_name        = "RADIO_FREQ3_CENTS"

RADIO_FREQ3_TENS                       = CreateGauge("parameter")
RADIO_FREQ3_TENS.arg_number            = 354
RADIO_FREQ3_TENS.input                 = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ3_TENS.output                = {0.3,0.4,0.5,0.6,0.7,0.8,0.9,0.0,0.1,0.2,0.29}

RADIO_FREQ3_TENS.parameter_name        = "RADIO_FREQ3_TENS"

RADIO_FREQ3_ONES                       = CreateGauge("parameter")
RADIO_FREQ3_ONES.arg_number            = 355
RADIO_FREQ3_ONES.input                 = {0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0}
RADIO_FREQ3_ONES.output                = {0.5,0.6,0.7,0.8,0.9,0.0,0.1,0.2,0.3,0.4,0.49}
RADIO_FREQ3_ONES.parameter_name        = "RADIO_FREQ3_ONES"

MISC_TAXI_LIGHT                         = CreateGauge("parameter")
MISC_TAXI_LIGHT.arg_number              = 428
MISC_TAXI_LIGHT.input                   = {-1, 1}
MISC_TAXI_LIGHT.output                  = {-1, 1}
MISC_TAXI_LIGHT.parameter_name          = "MISC_TAXI_LIGHT"


RADAR_POWER                             = CreateGauge("parameter")
RADAR_POWER.arg_number                  = 488
RADAR_POWER.input                       = {0.0,0.5,1.0}
RADAR_POWER.output                      = {-1,0.1,0.2}
RADAR_POWER.parameter_name              = "RADAR_POWER"

RADAR_MODE_SEL                         = CreateGauge("parameter")
RADAR_MODE_SEL.arg_number              = 493
RADAR_MODE_SEL.input                   = {1, 2, 3}
RADAR_MODE_SEL.output                  = {0, 0.1, 0.2}
RADAR_MODE_SEL.parameter_name          = "RADAR_MODE_SEL"

RADAR_SPL_MODE                         = CreateGauge("parameter")
RADAR_SPL_MODE.arg_number              = 492
RADAR_SPL_MODE.input                   = {0, 1}
RADAR_SPL_MODE.output                  = {-1.0, 1.0}
RADAR_SPL_MODE.parameter_name          = "RADAR_SPL_MODE"





need_to_be_closed = false