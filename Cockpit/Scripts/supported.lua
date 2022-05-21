local  aircraft = get_aircraft_type()											--Reading the variable
if 	aircraft 	== "Su-27" 	or 
	aircraft 	== "Su-33" 	or 
	aircraft 	== "J-11A" 	or
	aircraft 	== "Su-25T"	or
	aircraft 	== "Su-25"	or
	aircraft	=="MiG-29A"	or 
	aircraft	=="MiG-29G"	or 
	aircraft	=="MiG-29S"	or
	aircraft	=="A-10A"	or
	aircraft	=="F-15C"	then 
supported 		= 	true														--The mod will start
	else
supported		=	false														--The mod will not start
end