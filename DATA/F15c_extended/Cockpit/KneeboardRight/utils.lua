function recursively_print(table_to_print, max_depth, max_number_tables, filepath)
	file = io.open(filepath, "w")
	file:write("Key,Value\n")
	
	stack = {}
	
	table.insert(stack, {key = "start", value = table_to_print, level = 0})
	
	total = 0
	
	hash_table = {}

	hash_table[tostring(hash_table)] = 2
	hash_table[tostring(stack)] = 2
	
	item = true
	while (item) do
		item = table.remove(stack)
		
		if (item == nil) then
			break
		end
		key = item.key
		value = item.value
		level = item.level
		
		file:write(string.rep("\t", level)..tostring(key).." = "..tostring(value).."\n")
		
		hash = hash_table[tostring(value)]
		valid_table = (hash == nil or hash < 2)
		
		if (type(value) == "table" and valid_table) then
			for k,v in pairs(value) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
		
		if (getmetatable(value) and valid_table) then
			for k,v in pairs(getmetatable(value)) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
	end
	
	file:close()
end

function basic_dump (o)
  if type(o) == "number" then
    return tostring(o)
  elseif type(o) == "string" then
    return string.format("%q", o)
  else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
    return tostring(o)
  end
end


function dump (name, value, seen, result)
  local seen = seen or {}       -- initial value
  local result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
  elseif type(value) == "table" then
    -- if seen[value] then    -- value already saved?
    --   result=result.."->"..seen[value].."\n"  -- use its previous name
    -- else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        -- if fieldname~="_G[\"seen\"]" then
          result=dump(fieldname, v, seen, result)
        -- end
      end
    -- end
  end
  return result
end


function dump1 (name, value, saved, result)
  seen = seen or {}       -- initial value
  result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
    log.info(result)
    result = ""
  elseif type(value) == "table" then
    if seen[value] then    -- value already saved?
      result=result.."->"..seen[value].."\n"  -- use its previous name
      log.info(result)
      result = ""
      else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      log.info(result)
      result = ""
        for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        if fieldname~="_G[\"seen\"]" then
          result=dump1(fieldname, v, seen, result)
        end
      end
    end
  end
  return result
end

-- log.info("=====================================================")
-- param = list_cockpit_params()
-- dump("_G", _G)
-- dump("_G", getmetatable(_G))

-- dump("GetSelf", GetSelf())
-- dump("GetSelf", getmetatable(GetSelf()))

-- dump("GetRenderTarget", GetRenderTarget())
-- dump("GetRenderTarget", getmetatable(GetRenderTarget()))

-- dump("ccIndicator", ccIndicator)


-- Utility functions/classes

function startup_print(...)
    print(...)
end


-- rounds the number 'num' to the number of decimal places in 'idp'
--
-- print(round(107.75, -1))     : 110.0
-- print(round(107.75, 0))      : 108.0
-- print(round(107.75, 1))      : 107.8
function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

function clamp(value, minimum, maximum)
	return math.max(math.min(value,maximum),minimum)
end

-- calculates the x,y,z in russian coordinates of the point that is 'radius' distance away
-- from px,py,pz using the x,z angle of 'hdg' and the vertical slant angle
-- of 'slantangle'
function pointFromVector( px, py, pz, hdg, slantangle, radius )
    local x = px + (radius * math.cos(hdg) * math.cos(slantangle))
    local z = pz + (radius * math.sin(-hdg) * math.cos(slantangle))  -- pi/2 radians is west
    local y = py + (radius * math.sin(slantangle))

    return x,y,z
end
 
-- return GCD of m,n
function gcd(m, n)
    while m ~= 0 do
        m, n = math.fmod(n, m), m;
    end
    return n;
end


function LinearTodB(value)
    return math.pow(value, 3)
end


-- jumpwheel()
-- 
-- utility function to generate an animation argument for numberwhels that animate from 0.x11 to 0.x19
-- useful for "whole number" output dials, or any case where the decimal component determines when to
-- do the rollover.  All digits will roll at the same time as the ones digit, if they should roll.
--
-- input 'number' is the original raw number (e.g. 397.3275) and which digit position you want to draw
-- input 'position' is which digit position you want to generate an animation argument
--
-- technique: for aBcc.dd, where B is the position we're asking about, we break the number up into
--            component parts:
--            
--            a is throwaway.
--            B will become the first digit of the output.
--            cc tells us whether we're rolling or not.  All digits in cc must be "9".
--            dd is used for 0.Bdd as the return if we're going to be rolling B.
--
function jumpwheel(number, position)
    local rolling = false
    local a,dd = math.modf( number )                -- gives us aBcc in a, and .dd in dd

    a = math.fmod( a, 10^position )                 -- strips a to give us Bcc in a
    local B = math.floor( a / (10^(position-1)) )   -- gives us B by itself
    local cc = math.fmod( a, 10^(position-1) )      -- gives us cc by itself

    if cc == (10^(position-1)-1) then
        rolling = true                              -- if all the digits to the right are 9, then we are rolling based on the decimal component
    end

    if rolling then
        return( (B+dd)/10 )
    else
        return B/10
    end
end

---------------------------------------------
--[[
Function to recursively dump a table to a string, can be used to gain introspection into _G too
Usage:
str=dump("_G",_G)
print(str)  -- or log to DCS log file (log.alert), or print_message_to_user etc.
--]]
function basic_dump (o)
  if type(o) == "number" then
    return tostring(o)
  elseif type(o) == "string" then
    return string.format("%q", o)
  else -- nil, boolean, function, userdata, thread; assume it can be converted to a string
    return tostring(o)
  end
end


function dump (name, value, saved, result)
  seen = seen or {}       -- initial value
  result = result or ""
  result=result..name.." = "
  if type(value) ~= "table" then
    result=result..basic_dump(value).."\n"
  elseif type(value) == "table" then
    if seen[value] then    -- value already saved?
      result=result.."->"..seen[value].."\n"  -- use its previous name
    else
      seen[value] = name   -- save name for next time
      result=result.."{}\n"     -- create a new table
      for k,v in pairs(value) do      -- save its fields
        local fieldname = string.format("%s[%s]", name,
                                        basic_dump(k))
        if fieldname~="_G[\"seen\"]" then
          result=dump(fieldname, v, seen, result)
        end
      end
    end
  end
  return result
end

function strsplit(delimiter, text)
  local list = {}
  local pos = 1
  if string.find("", delimiter, 1) then
    return {}
  end
  while 1 do
    local first, last = string.find(text, delimiter, pos)
    if first then -- found?
      table.insert(list, string.sub(text, pos, first-1))
      pos = last+1
    else
      table.insert(list, string.sub(text, pos))
      break
    end
  end
  return list
end

---------------------------------------------
---------------------------------------------
--[[
PID Controller class (Proportional-Integral-Derivative Controller)
(backward Euler discrete form)
--]]

PID = {} -- the table representing the class, which will double as the metatable for the instances
PID.__index = PID -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(PID, {
  __call = function( cls, ... )
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=PID() is equivalent to a=PID.new()
  end,
})

function PID.new( Kp, Ki, Kd, umin, umax, uscale )
    local self = setmetatable({}, PID)

    self.Kp = Kp or 1   -- default to a weight=1 "P" controller
    self.Ki = Ki or 0
    self.Kd = Kd or 0

    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
    self.k3 = self.Kd

    self.e2 = 0     -- error term history for I/D functions
    self.e1 = 0
    self.e = 0

    self.du = 0     -- delta U()
    self.u = 0      -- U() term for output

    self.umax = umax or 999999  -- allow bounding of e for PID output limits
    self.umin = umin or -999999
    self.uscale = uscale or 1   -- allow embedded output scaling and range limiting

    return self
end

-- used to tune Kp on the fly
function PID:set_Kp( val )
    self.Kp = val
    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
end

-- used to tune Kp on the fly
function PID:get_Kp()
    return self.Kp
end

-- used to tune Ki on the fly
function PID:set_Ki( val )
    self.Ki = val
    self.k1 = self.Kp + self.Ki + self.Kd
end

-- used to tune Ki on the fly
function PID:get_Ki()
    return self.Ki
end

-- used to tune Kd on the fly
function PID:set_Kd( val )
    self.Kd = val
    self.k1 = self.Kp + self.Ki + self.Kd
    self.k2 = -self.Kp - 2*self.Kd
    self.k3 = self.Kd
end

-- used to tune Kd on the fly
function PID:get_Kd()
    return self.Kd
end

function PID:run( setpoint, mv )
    self.e2 = self.e1
    self.e1 = self.e
    self.e = setpoint - mv

    -- backward Euler discrete PID function
    self.du = self.k1*self.e + self.k2*self.e1 + self.k3*self.e2
    self.u = self.u + self.du

    if self.u < self.umin then
        self.u = self.umin
    elseif self.u > self.umax then
        self.u = self.umax
    end

    return self.u*self.uscale
end

-- reset dynamic state
function PID:reset(u)
    self.e2 = 0
    self.e1 = 0
    self.e = 0

    self.du = 0
    if u then
        self.u = u/self.uscale
    else
        self.u = 0
    end
end


---------------------------------------------
---------------------------------------------
--[[
Weighted moving average class, useful for supplying values to gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = (weight*new_value + (1-weight)*prev_value)
Example usage:
myvar=WMA(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average
gauge_param:set(myvar:get_WMA(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA = {} -- the table representing the class, which will double as the metatable for the instances
WMA.__index = WMA -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA() is equivalent to a=WMA.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA() is called
function WMA.new (latest_weight, init_val)
  local self = setmetatable({}, WMA)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA() is called
  self.target_val = self.cur_val
  return self
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
function WMA:get_WMA (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  self.cur_val = self.cur_val+(v-self.cur_val)*self.cur_weight
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA() function)
function WMA:get_target_val ()
    return self.target_val
end

--[[
-- test code
target_cur={}
table.insert(target_cur, {600,0})
table.insert(target_cur, {0,600})

for k,v in ipairs(target_cur) do
	target=v[1]
	cur=v[2]

	print("--- "..cur,target)
	myvar=WMA(0.15,cur)
	for j=1,20 do
		print(myvar:get_WMA(target))
	end
end
--]]

---------------------------------------------


---------------------------------------------
--[[
Weighted moving average class that treats [range_min,range_max] as wraparound, useful for supplying values to circular gauges in an exponential decay/growth form (avoid instantaneous step values)
It keeps only a single previous value, the pseudocode is:
  prev_value = ((prev_value+weight*(wrapped(new_value-old_value)))
Example usage:
myvar=WMA_wrap(0.15,0)   -- create the object (once off), first param is weight for newest values, second param is initial value, both params optional
-- use the object repeatedly, the value passed is stored internally in the object and the return value is the weighted moving average wrapped between range_min and range_max
gauge_param:set(myvar:get_WMA_wrap(new_val))

0.15 is a good value to use for gauges, it takes about 20 steps to achieve 95% of a new set point value
--]]

WMA_wrap = {} -- the table representing the class, which will double as the metatable for the instances
WMA_wrap.__index = WMA_wrap -- failed table lookups on the instances should fallback to the class table, to get methods
setmetatable(WMA_wrap, {
  __call = function (cls, ...)
    return cls.new(...) -- automatically call constructor when class is called like a function, e.g. a=WMA_wrap() is equivalent to a=WMA_wrap.new()
  end,
})

-- Create a new instance of the object.
-- latest_weight must be between 0.01 and 1,  defaults to 0.5 if not supplied.
-- init_val sets the initial value, if not supplied it will be initialized the first time get_WMA_wrap() is called
-- range_min defaults to 0, range_max defaults to 1
function WMA_wrap.new (latest_weight, init_val, range_min, range_max)
  local self = setmetatable({}, WMA_wrap)

  self.cur_weight=latest_weight or 0.5 -- default to 0.5 if not passed as param
  if self.cur_weight>1.0 then
  	self.cur_weight=1.0
  end
  if self.cur_weight<0.01 then
  	self.cur_weight=0.01
  end
  self.cur_val = init_val  -- can be nil if not passed, will be initialized first time get_WMA_wrap() is called
  self.target_val = self.cur_val
  self.range_min=math.min(range_min or 0.0, range_max or 1.0)
  self.range_max=math.max(range_min or 0.0, range_max or 1.0)
  self.range_delta=range_max-range_min;
  self.range_thresh=self.range_delta/8192
  return self
end

-- this can almost certainly be simplified, but I was lazy and did it the straightforward way
local function get_shortest_delta(target,cur,min,max)
	local d1,d2,delta
	if target>=cur then
		d1=target-cur
		d2=cur-min+(max-target)
		if d2<d1 then
			delta=-d2
		else
			delta=d1
		end
	else
		d1=cur-target
		d2=target-min+(max-cur)
		if d1<d2 then
			delta=-d1
		else
			delta=d2
		end
	end
	return delta
end

-- this updates current value based on weighted moving average with new value v, and returns the weighted moving average
-- the target value v is kept internally and can be retrieved with the get_target_val() function
-- it wraps within [range_min,range_max] and also moves in the shortest direction (clockwise or anticlockwise) between two points
function WMA_wrap:get_WMA_wrap (v)
  self.target_val = v
  if not self.cur_val then
  	self.cur_val=v
  	return self.cur_val
  end
  delta=get_shortest_delta(v, self.cur_val, self.range_min, self.range_max)
  self.cur_val=self.cur_val+(delta*self.cur_weight)
  if math.abs(delta)<self.range_thresh then
    self.cur_val=self.target_val
  end
  if self.cur_val>self.range_max then
  	self.cur_val=self.cur_val-self.range_delta
  elseif self.cur_val<self.range_min then
  	self.cur_val=self.cur_val+self.range_delta
  end
  return self.cur_val
end

-- if necessary to update the current value instantaneously (bypass weighted moving average)
function WMA_wrap:set_current_val (v)
    self.cur_val = v
    self.target_val = v
end

-- if necessary to read the current weighted average value (without updating the weighted moving average with a new value)
function WMA_wrap:get_current_val ()
    return self.cur_val
end

-- read the target value (latest value passed to the get_WMA_wrap() function)
function WMA_wrap:get_target_val ()
    return self.target_val
end

--------------------------------------------------------------------

Constant_Speed_Controller = {}
Constant_Speed_Controller.__index = Constant_Speed_Controller
setmetatable(Constant_Speed_Controller,
  {
    __call = function(cls, ...)
        return cls.new(...) --call constructor if someone calls this table
    end
  }
)

function Constant_Speed_Controller.new(speed, min, max, pos)
  local self = setmetatable({}, Constant_Speed_Controller)
  self.speed = speed
  self.min = min
  self.max = max
  self.pos = pos
  return self
end

function Constant_Speed_Controller:update(target)

  local p = self.pos
  local direction = target - self.pos

  if math.abs(direction) <= self.speed then
    self.pos = target
  elseif direction < 0.0 then
    self.pos = self.pos - self.speed
  elseif direction > 0.0 then
    self.pos = self.pos + self.speed
  end

end

function Constant_Speed_Controller:get_position()
  return self.pos
end










--------------------------------------------------------------------

--[[
Description
Recursively descends both meta and regular tables and prints their key : value pairs until
limits are reached or the table is exhausted.

@param[in] table_to_print 		root of the tables to recursively explore
@param[in] max_depth				how many levels are recursion (not function recursion) are allowed.
@param[in] max_number_tables		how many different tables are allowed to be processed in total
@param[in] filepath				path to put this data

@return VOID
]]--
function recursively_print(table_to_print, max_depth, max_number_tables, filepath)
	file = io.open(filepath, "w")
	file:write("Key,Value\n")
	
	stack = {}
	
	table.insert(stack, {key = "start", value = table_to_print, level = 0})
	
	total = 0
	
	hash_table = {}

	hash_table[tostring(hash_table)] = 2
	hash_table[tostring(stack)] = 2
	
	item = true
	while (item) do
		item = table.remove(stack)
		
		if (item == nil) then
			break
		end
		key = item.key
		value = item.value
		level = item.level
		
		file:write(string.rep("\t", level)..tostring(key).." = "..tostring(value).."\n")
		
		hash = hash_table[tostring(value)]
		valid_table = (hash == nil or hash < 2)
		
		if (type(value) == "table" and valid_table) then
			for k,v in pairs(value) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
		
		if (getmetatable(value) and valid_table) then
			for k,v in pairs(getmetatable(value)) do
				if (v ~= nil and level <= max_depth and total < max_number_tables) then
					table.insert(stack, {key = k, value = v, level = level+1})
					if (type(v) == "table") then
						if (hash_table[tostring(v)] == nil) then
							hash_table[tostring(v)] = 1
						elseif (hash_table[tostring(v)] < 2) then
							hash_table[tostring(v)] = 2
						end
						total = total + 1
					end
				end
			end
		end
	end
	
	file:close()
end

--[[
-- test code
target_cur={}
table.insert(target_cur, {350,10})
table.insert(target_cur, {10,350})
table.insert(target_cur, {280,90})
table.insert(target_cur, {90,280})

for k,v in ipairs(target_cur) do
	target=v[1]
	cur=v[2]

	print("--- "..cur,target)
	myvar=WMA_wrap(0.15,cur,0,360)
	for j=1,20 do
		print(myvar:get_WMA_wrap(target))
	end
end
--]]
---------------------------------------------


-- _G = {}
-- _G["basic_dump"] = function: 000002D28527FAB0
-- _G["dofile"] = function: 000002D2872717A0
-- _G["_G"] = ->_G
-- _G["dump"] = function: 000002D28527FB70
-- _G = {}
-- _G["__index"] = {}
-- _G["__index"]["get_aircraft_mission_data"] = function: 000002D271B7D530
-- _G["__index"]["MakeFont"] = function: 000002D271B7D440
-- _G["__index"]["tostring"] = function: 000002D271B77AD0
-- _G["__index"]["get_player_crew_index"] = function: 000002D271B7CDB0
-- _G["__index"]["set_crew_member_seat_adjustment"] = function: 000002D271B7D5C0
-- _G["__index"]["create_guid_string"] = function: 000002D271B7D380
-- _G["__index"]["os"] = {}
-- _G["__index"]["os"]["getpid"] = function: 000002D271B7A0E0
-- _G["__index"]["os"]["date"] = function: 000002D271B7A3E0
-- _G["__index"]["os"]["getenv"] = function: 000002D276FCD890
-- _G["__index"]["os"]["difftime"] = function: 000002D271B79FF0
-- _G["__index"]["os"]["remove"] = function: 000002D271B7A080
-- _G["__index"]["os"]["time"] = function: 000002D271B7A3B0
-- _G["__index"]["os"]["run_process"] = function: 000002D271B79A50
-- _G["__index"]["os"]["clock"] = function: 000002D271B77920
-- _G["__index"]["os"]["open_uri"] = function: 000002D271B7A230
-- _G["__index"]["os"]["rename"] = function: 000002D271B79AE0
-- _G["__index"]["os"]["execute"] = function: 000002D276FCD4D0
-- _G["__index"]["USE_TERRAIN4"] = true
-- _G["__index"]["list_cockpit_params"] = function: 000002D271B7CCC0
-- _G["__index"]["pairs"] = function: 000002D276FCCD10
-- _G["__index"]["get_param_handle"] = function: 000002D271B7C810
-- _G["__index"]["get_mission_route"] = function: 000002D271B7C360
-- _G["__index"]["get_random_orderly"] = function: 000002D271B7BF10
-- _G["__index"]["get_input_devices"] = function: 000002D271B7C090
-- _G["__index"]["get_cockpit_draw_argument_value"] = function: 000002D271B7D500
-- _G["__index"]["get_terrain_related_data"] = function: 000002D271B7C6F0
-- _G["__index"]["UTF8_substring"] = function: 000002D271B7C4B0
-- _G["__index"]["coroutine_create"] = function: 000002D271B7B400
-- _G["__index"]["set_aircraft_draw_argument_value"] = function: 000002D271B7D0E0
-- _G["__index"]["ED_PUBLIC_AVAILABLE"] = true
-- _G["__index"]["get_random_evenly"] = function: 000002D271B7C8D0
-- _G["__index"]["Copy"] = function: 000002D271B7D0B0
-- _G["__index"]["coroutine"] = {}
-- _G["__index"]["coroutine"]["resume"] = function: 000002D271B78850
-- _G["__index"]["coroutine"]["yield"] = function: 000002D271B78490
-- _G["__index"]["coroutine"]["status"] = function: 000002D271B78910
-- _G["__index"]["coroutine"]["wrap"] = function: 000002D271B78310
-- _G["__index"]["coroutine"]["create"] = function: 000002D271B77770
-- _G["__index"]["coroutine"]["running"] = function: 000002D271B78D00
-- _G["__index"]["get_plugin_option_value"] = function: 000002D271B7C000
-- _G["__index"]["copy_to_mission_and_dofile"] = function: 000002D271B7C750
-- _G["__index"]["loadstring"] = function: 000002D271B77C50
-- _G["__index"]["string"] = {}
-- _G["__index"]["string"]["sub"] = function: 000002D271B7A500
-- _G["__index"]["string"]["upper"] = function: 000002D271B79D50
-- _G["__index"]["string"]["len"] = function: 000002D271B79F00
-- _G["__index"]["string"]["gfind"] = function: 000002D271B79E70
-- _G["__index"]["string"]["rep"] = function: 000002D271B79FC0
-- _G["__index"]["string"]["find"] = function: 000002D271B7A470
-- _G["__index"]["string"]["match"] = function: 000002D271B7A0B0
-- _G["__index"]["string"]["char"] = function: 000002D271B78970
-- _G["__index"]["string"]["dump"] = function: 000002D271B78CA0
-- _G["__index"]["string"]["gmatch"] = function: 000002D271B79E70
-- _G["__index"]["string"]["reverse"] = function: 000002D271B79C00
-- _G["__index"]["string"]["byte"] = function: 000002D271B77D40
-- _G["__index"]["string"]["format"] = function: 000002D271B7A290
-- _G["__index"]["string"]["gsub"] = function: 000002D271B79C60
-- _G["__index"]["string"]["lower"] = function: 000002D271B7A380
-- _G["__index"]["a_cockpit_lock_player_seat"] = function: 000002D271B7CE40
-- _G["__index"]["mount_vfs_path_to_mount_point"] = function: 000002D271B7C0F0
-- _G["__index"]["print"] = function: 000002D271B78820
-- _G["__index"]["get_option_value"] = function: 000002D271B7C840
-- _G["__index"]["a_cockpit_highlight_position"] = function: 000002D271B7CA80
-- _G["__index"]["table"] = {}
-- _G["__index"]["table"]["setn"] = function: 000002D271B799C0
-- _G["__index"]["table"]["insert"] = function: 000002D271B79930
-- _G["__index"]["table"]["getn"] = function: 000002D271B78CD0
-- _G["__index"]["table"]["foreachi"] = function: 000002D271B78400
-- _G["__index"]["table"]["maxn"] = function: 000002D271B79540
-- _G["__index"]["table"]["foreach"] = function: 000002D271B78670
-- _G["__index"]["table"]["concat"] = function: 000002D271B784F0
-- _G["__index"]["table"]["sort"] = function: 000002D271B791E0
-- _G["__index"]["table"]["remove"] = function: 000002D271B78FD0
-- _G["__index"]["_ARCHITECTURE"] = "x86_64"
-- _G["__index"]["c_cockpit_param_equal_to"] = function: 000002D271B7CB70
-- _G["__index"]["get_absolute_model_time"] = function: 000002D271B7C990
-- _G["__index"]["_ED_VERSION"] = "DCS/2.5.6.60966 (x86_64; Windows NT 10.0.18363)"
-- _G["__index"]["ipairs"] = function: 000002D276FCCE90
-- _G["__index"]["collectgarbage"] = function: 000002D271B77C20
-- _G["__index"]["c_cockpit_param_in_range"] = function: 000002D271B7D2F0
-- _G["__index"]["Add"] = function: 000002D271B7D200
-- _G["__index"]["print_message_to_user"] = function: 000002D271B7C8A0
-- _G["__index"]["c_start_wait_for_user"] = function: 000002D271B7CD20
-- _G["__index"]["track_is_reading"] = function: 000002D271B7C240
-- _G["__index"]["math"] = {}
-- _G["__index"]["math"]["log"] = function: 000002D271B7ADD0
-- _G["__index"]["math"]["max"] = function: 000002D271B7B0A0
-- _G["__index"]["math"]["acos"] = function: 000002D271B7A1A0
-- _G["__index"]["math"]["huge"] = inf
-- _G["__index"]["math"]["ldexp"] = function: 000002D271B7AC20
-- _G["__index"]["math"]["pi"] = 3.1415926535898
-- _G["__index"]["math"]["cos"] = function: 000002D271B7A680
-- _G["__index"]["math"]["tanh"] = function: 000002D271B7AF50
-- _G["__index"]["math"]["pow"] = function: 000002D271B7AD70
-- _G["__index"]["math"]["deg"] = function: 000002D271B7AE30
-- _G["__index"]["math"]["tan"] = function: 000002D271B7AFB0
-- _G["__index"]["math"]["cosh"] = function: 000002D271B7AE60
-- _G["__index"]["math"]["sinh"] = function: 000002D271B7A6E0
-- _G["__index"]["math"]["random"] = function: 000002D271B7A8F0
-- _G["__index"]["math"]["randomseed"] = function: 000002D271B7AF20
-- _G["__index"]["math"]["frexp"] = function: 000002D271B7AA10
-- _G["__index"]["math"]["ceil"] = function: 000002D271B7A950
-- _G["__index"]["math"]["floor"] = function: 000002D271B7A830
-- _G["__index"]["math"]["rad"] = function: 000002D271B7AD40
-- _G["__index"]["math"]["abs"] = function: 000002D271B7A140
-- _G["__index"]["math"]["sqrt"] = function: 000002D271B7A7D0
-- _G["__index"]["math"]["modf"] = function: 000002D271B7B1F0
-- _G["__index"]["math"]["asin"] = function: 000002D271B7A620
-- _G["__index"]["math"]["min"] = function: 000002D271B7B0D0
-- _G["__index"]["math"]["mod"] = function: 000002D271B7AE90
-- _G["__index"]["math"]["fmod"] = function: 000002D271B7AE90
-- _G["__index"]["math"]["log10"] = function: 000002D271B7AE00
-- _G["__index"]["math"]["atan2"] = function: 000002D271B7ABF0
-- _G["__index"]["math"]["exp"] = function: 000002D271B7ACE0
-- _G["__index"]["math"]["sin"] = function: 000002D271B7A9E0
-- _G["__index"]["math"]["atan"] = function: 000002D271B7ABC0
-- _G["__index"]["pcall"] = function: 000002D271B77E90
-- _G["__index"]["type"] = function: 000002D271B78130
-- _G["__index"]["a_cockpit_remove_highlight"] = function: 000002D271B7D290
-- _G["__index"]["lfs"] = {}
-- _G["__index"]["lfs"]["normpath"] = function: 000002D271B79600
-- _G["__index"]["lfs"]["locations"] = function: 000002D271B79450
-- _G["__index"]["lfs"]["dir"] = function: 000002D271B79090
-- _G["__index"]["lfs"]["tempdir"] = function: 000002D271B79330
-- _G["__index"]["lfs"]["realpath"] = function: 000002D271B79780
-- _G["__index"]["lfs"]["writedir"] = function: 000002D271B792D0
-- _G["__index"]["lfs"]["mkdir"] = function: 000002D271B79960
-- _G["__index"]["lfs"]["currentdir"] = function: 000002D271B796F0
-- _G["__index"]["lfs"]["add_location"] = function: 000002D271B79510
-- _G["__index"]["lfs"]["attributes"] = function: 000002D271B796C0
-- _G["__index"]["lfs"]["create_lockfile"] = function: 000002D271B7A200
-- _G["__index"]["lfs"]["md5sum"] = function: 000002D271B79840
-- _G["__index"]["lfs"]["del_location"] = function: 000002D271B79720
-- _G["__index"]["lfs"]["chdir"] = function: 000002D271B79210
-- _G["__index"]["lfs"]["rmdir"] = function: 000002D271B79A20
-- _G["__index"]["copy_to_mission_and_get_buffer"] = function: 000002D271B7C9F0
-- _G["__index"]["GetHalfWidth"] = function: 000002D271B7D1D0
-- _G["__index"]["get_model_time"] = function: 000002D271B7C870
-- _G["__index"]["GetHalfHeight"] = function: 000002D271B7CED0
-- _G["__index"]["loadfile"] = function: 000002D271B78430
-- _G["__index"]["log"] = {}
-- _G["__index"]["log"]["FULL"] = 263
-- _G["__index"]["log"]["TIME_LOCAL"] = 129
-- _G["__index"]["log"]["ALL"] = 255
-- _G["__index"]["log"]["set_output"] = function: 000002D271B7BD90
-- _G["__index"]["log"]["LEVEL"] = 2
-- _G["__index"]["log"]["DEBUG"] = 128
-- _G["__index"]["log"]["IMMEDIATE"] = 1
-- _G["__index"]["log"]["ASYNC"] = 0
-- _G["__index"]["log"]["MODULE"] = 4
-- _G["__index"]["log"]["ALERT"] = 2
-- _G["__index"]["log"]["RELIABLE"] = 32768
-- _G["__index"]["log"]["warning"] = function: 000002D276FCD850
-- _G["__index"]["log"]["debug"] = function: 000002D276FCD910
-- _G["__index"]["log"]["write"] = function: 000002D271B7BA00
-- _G["__index"]["log"]["printf"] = function: 000002D271B7BBE0
-- _G["__index"]["log"]["TIME_UTC"] = 1
-- _G["__index"]["log"]["TIME"] = 1
-- _G["__index"]["log"]["WARNING"] = 16
-- _G["__index"]["log"]["INFO"] = 64
-- _G["__index"]["log"]["error"] = function: 000002D276FCD490
-- _G["__index"]["log"]["info"] = function: 000002D276FCD390
-- _G["__index"]["log"]["ERROR"] = 8
-- _G["__index"]["log"]["TIME_RELATIVE"] = 128
-- _G["__index"]["log"]["TRACE"] = 256
-- _G["__index"]["log"]["alert"] = function: 000002D276FCD450
-- _G["__index"]["log"]["MESSAGE"] = 0
-- _G["__index"]["gcinfo"] = function: 000002D271B780A0
-- _G["__index"]["LockOn_Options"] = {}
-- _G["__index"]["LockOn_Options"]["script_path"] = "C:\\Users\\cadre\\Saved Games\\DCS\\Mods/aircraft/A-29B/Cockpit/Scripts/"
-- _G["__index"]["LockOn_Options"]["cockpit_language"] = "russian"
-- _G["__index"]["LockOn_Options"]["common_script_path"] = "Scripts/Aircrafts/_Common/Cockpit/"
-- _G["__index"]["LockOn_Options"]["date"] = {}
-- _G["__index"]["LockOn_Options"]["date"]["year"] = 2236
-- _G["__index"]["LockOn_Options"]["date"]["day"] = 22
-- _G["__index"]["LockOn_Options"]["date"]["month"] = 4
-- _G["__index"]["LockOn_Options"]["flight"] = {}
-- _G["__index"]["LockOn_Options"]["flight"]["unlimited_fuel"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["g_effects"] = "realistic"
-- _G["__index"]["LockOn_Options"]["flight"]["radio_assist"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["unlimited_weapons"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["external_view"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["easy_radar"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["easy_flight"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["external_labels"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["crash_recovery"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["immortal"] = false
-- _G["__index"]["LockOn_Options"]["flight"]["tool_tips_enable"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["padlock"] = true
-- _G["__index"]["LockOn_Options"]["flight"]["aircraft_switching"] = true
-- _G["__index"]["LockOn_Options"]["screen"] = {}
-- _G["__index"]["LockOn_Options"]["screen"]["height"] = 1080
-- _G["__index"]["LockOn_Options"]["screen"]["aspect"] = 1.7777777910233
-- _G["__index"]["LockOn_Options"]["screen"]["width"] = 1920
-- _G["__index"]["LockOn_Options"]["cockpit"] = {}
-- _G["__index"]["LockOn_Options"]["cockpit"]["mirrors"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["reflections"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["use_nightvision_googles"] = false
-- _G["__index"]["LockOn_Options"]["cockpit"]["render_target_resolution"] = 1024
-- _G["__index"]["LockOn_Options"]["time"] = {}
-- _G["__index"]["LockOn_Options"]["time"]["hours"] = 12
-- _G["__index"]["LockOn_Options"]["time"]["seconds"] = 0
-- _G["__index"]["LockOn_Options"]["time"]["minutes"] = 0
-- _G["__index"]["LockOn_Options"]["avionics_language"] = "native"
-- _G["__index"]["LockOn_Options"]["measurement_system"] = "imperial"
-- _G["__index"]["LockOn_Options"]["init_conditions"] = {}
-- _G["__index"]["LockOn_Options"]["init_conditions"]["birth_place"] = "AIR_HOT"
-- _G["__index"]["LockOn_Options"]["mission"] = {}
-- _G["__index"]["LockOn_Options"]["mission"]["file_path"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["description"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["title"] = "stub"
-- _G["__index"]["LockOn_Options"]["mission"]["campaign"] = ""
-- _G["__index"]["mount_vfs_model_path"] = function: 000002D271B7C720
-- _G["__index"]["getfenv"] = function: 000002D271B77710
-- _G["__index"]["a_cockpit_unlock_player_seat"] = function: 000002D271B7CBD0
-- _G["__index"]["dbg_print"] = function: 000002D271B7C2D0
-- _G["__index"]["c_indication_txt_equal_to"] = function: 000002D271B7CF90
-- _G["__index"]["module"] = function: 000002D271B78AF0
-- _G["__index"]["MakeMaterial"] = function: 000002D271B7D3B0
-- _G["__index"]["_G"] = ->_G["__index"]
-- _G["__index"]["list_indication"] = function: 000002D271B7CBA0
-- _G["__index"]["geo_to_lo_coords"] = function: 000002D271B7C7E0
-- _G["__index"]["a_cockpit_param_save_as"] = function: 000002D271B7D590
-- _G["__index"]["switch_labels_off"] = function: 000002D271B7CC90
-- _G["__index"]["ED_FINAL_VERSION"] = true
-- _G["__index"]["get_aircraft_property_or_nil"] = function: 000002D271B7D140
-- _G["__index"]["get_aircraft_type"] = function: 000002D271B7CD80
-- _G["__index"]["c_cockpit_highlight_visible"] = function: 000002D271B7CB40
-- _G["__index"]["xpcall"] = function: 000002D271B78790
-- _G["__index"]["package"] = {}
-- _G["__index"]["package"]["preload"] = {}
-- _G["__index"]["package"]["loadlib"] = function: 000002D271B78B50
-- _G["__index"]["package"]["loaded"] = {}
-- _G["__index"]["package"]["loaded"]["string"] = ->_G["__index"]["string"]
-- _G["__index"]["package"]["loaded"]["debug"] = {}
-- _G["__index"]["package"]["loaded"]["debug"]["getupvalue"] = function: 000002D271B7BDC0
-- _G["__index"]["package"]["loaded"]["debug"]["debug"] = function: 000002D271B7B010
-- _G["__index"]["package"]["loaded"]["debug"]["sethook"] = function: 000002D271B7B580
-- _G["__index"]["package"]["loaded"]["debug"]["getmetatable"] = function: 000002D271B7BAF0
-- _G["__index"]["package"]["loaded"]["debug"]["gethook"] = function: 000002D271B7AAA0
-- _G["__index"]["package"]["loaded"]["debug"]["setmetatable"] = function: 000002D271B7B910
-- _G["__index"]["package"]["loaded"]["debug"]["setlocal"] = function: 000002D271B7B820
-- _G["__index"]["package"]["loaded"]["debug"]["traceback"] = function: 000002D271B7B5E0
-- _G["__index"]["package"]["loaded"]["debug"]["setfenv"] = function: 000002D271B7BD30
-- _G["__index"]["package"]["loaded"]["debug"]["getinfo"] = function: 000002D271B7A650
-- _G["__index"]["package"]["loaded"]["debug"]["setupvalue"] = function: 000002D271B7B310
-- _G["__index"]["package"]["loaded"]["debug"]["getlocal"] = function: 000002D271B7B070
-- _G["__index"]["package"]["loaded"]["debug"]["getregistry"] = function: 000002D271B7AB60
-- _G["__index"]["package"]["loaded"]["debug"]["getfenv"] = function: 000002D271B7B130
-- _G["__index"]["package"]["loaded"]["lfs"] = ->_G["__index"]["lfs"]
-- _G["__index"]["package"]["loaded"]["_G"] = ->_G["__index"]
-- _G["__index"]["package"]["loaded"]["i_18n"] = {}
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_locale_dir"] = function: 000002D28714D0B0
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_locale"] = function: 000002D28714D2C0
-- _G["__index"]["package"]["loaded"]["i_18n"]["init"] = function: 000002D271B6F2B0
-- _G["__index"]["package"]["loaded"]["i_18n"]["attach"] = function: 000002D29ABF4100
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_locale"] = function: 000002D28714D0E0
-- _G["__index"]["package"]["loaded"]["i_18n"]["add_package"] = function: 000002D29ABF3FE0
-- _G["__index"]["package"]["loaded"]["i_18n"]["dtranslate"] = function: 000002D271B7D800
-- _G["__index"]["package"]["loaded"]["i_18n"]["remove_package"] = function: 000002D29ABF4310
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_localized_filename"] = function: 000002D28714D140
-- _G["__index"]["package"]["loaded"]["i_18n"]["translate"] = function: 000002D28714D350
-- _G["__index"]["package"]["loaded"]["i_18n"]["set_package"] = function: 000002D28714D890
-- _G["__index"]["package"]["loaded"]["i_18n"]["get_localized_foldername"] = function: 000002D28714D620
-- _G["__index"]["package"]["loaded"]["io"] = {}
-- _G["__index"]["package"]["loaded"]["io"]["read"] = function: 000002D271B797B0
-- _G["__index"]["package"]["loaded"]["io"]["write"] = function: 000002D271B79120
-- _G["__index"]["package"]["loaded"]["io"]["close"] = function: 000002D271B799F0
-- _G["__index"]["package"]["loaded"]["io"]["lines"] = function: 000002D271B79180
-- _G["__index"]["package"]["loaded"]["io"]["flush"] = function: 000002D271B79900
-- _G["__index"]["package"]["loaded"]["io"]["open"] = function: 000002D271B78EE0
-- _G["__index"]["package"]["loaded"]["io"]["__gc"] = function: 000002D271B795A0
-- _G["__index"]["package"]["loaded"]["os"] = ->_G["__index"]["os"]
-- _G["__index"]["package"]["loaded"]["table"] = ->_G["__index"]["table"]
-- _G["__index"]["package"]["loaded"]["math"] = ->_G["__index"]["math"]
-- _G["__index"]["package"]["loaded"]["log"] = ->_G["__index"]["log"]
-- _G["__index"]["package"]["loaded"]["coroutine"] = ->_G["__index"]["coroutine"]
-- _G["__index"]["package"]["loaded"]["package"] = ->_G["__index"]["package"]
-- _G["__index"]["package"]["loaders"] = {}
-- _G["__index"]["package"]["loaders"][1] = function: 000002D271B788B0
-- _G["__index"]["package"]["loaders"][2] = function: 000002D276FCD0D0
-- _G["__index"]["package"]["loaders"][3] = function: 000002D271B78B20
-- _G["__index"]["package"]["loaders"][4] = function: 000002D271B783A0
-- _G["__index"]["package"]["loaders"][5] = function: 000002D271B78640
-- _G["__index"]["package"]["cpath"] = ".\\lua-?.dll;.\\?.dll;C:\\DCS World\\bin\\lua-?.dll;C:\\DCS World\\bin\\?.dll;"
-- _G["__index"]["package"]["config"] = "\\\




-- _G["__index"]["package"]["path"] = ".\\?.lua;C:\\DCS World\\bin\\lua\\?.lua;C:\\DCS World\\bin\\lua\\?\\init.lua;C:\\DCS World\\bin\\?.lua;C:\\DCS World\\bin\\?\\init.lua"
-- _G["__index"]["package"]["seeall"] = function: 000002D271B78DC0
-- _G["__index"]["_VERSION"] = "Lua 5.1"
-- _G["__index"]["i_18n"] = ->_G["__index"]["package"]["loaded"]["i_18n"]
-- _G["__index"]["get_aircraft_property"] = function: 000002D271B7D020
-- _G["__index"]["unpack"] = function: 000002D271B77B30
-- _G["__index"]["GetSelf"] = function: 000002D28527DEF0
-- _G["__index"]["get_plugin_option"] = function: 000002D271B7C330
-- _G["__index"]["require"] = function: 000002D271B785B0
-- _G["__index"]["find_viewport"] = function: 000002D271B7C570
-- _G["__index"]["debug"] = ->_G["__index"]["package"]["loaded"]["debug"]
-- _G["__index"]["GetAspect"] = function: 000002D271B7CC00
-- _G["__index"]["setmetatable"] = function: 000002D271B77F50
-- _G["__index"]["next"] = function: 000002D271B77D10
-- _G["__index"]["GetScale"] = function: 000002D271B7D350
-- _G["__index"]["assert"] = function: 000002D271B776E0
-- _G["__index"]["tonumber"] = function: 000002D271B77F80
-- _G["__index"]["io"] = ->_G["__index"]["package"]["loaded"]["io"]
-- _G["__index"]["SetCustomScale"] = function: 000002D271B7CAE0
-- _G["__index"]["SetScale"] = function: 000002D271B7D1A0
-- _G["__index"]["rawequal"] = function: 000002D271B778C0
-- _G["__index"]["elementmeta"] = {}
-- _G["__index"]["elementmeta"]["__index"] = function: 000002D271B7CEA0
-- _G["__index"]["elementmeta"]["__newindex"] = function: 000002D271B7CA50
-- _G["__index"]["get_dcs_plugin_path"] = function: 000002D271B7D2C0
-- _G["__index"]["load_mission_file"] = function: 000002D271B7C420
-- _G["__index"]["newproxy"] = function: 000002D276FCD710
-- _G["__index"]["load"] = function: 000002D271B779B0
-- _G["__index"]["a_cockpit_highlight_indication"] = function: 000002D271B7CDE0
-- _G["__index"]["CreateElement"] = function: 000002D271B7D080
-- _G["__index"]["get_aircraft_draw_argument_value"] = function: 000002D271B7BF70
-- _G["__index"]["a_cockpit_pop_actor"] = function: 000002D271B7CE10
-- _G["__index"]["a_cockpit_push_actor"] = function: 000002D271B7D5F0
-- _G["__index"]["rawset"] = function: 000002D271B77E00
-- _G["__index"]["get_base_data"] = function: 000002D271B7C2A0
-- _G["__index"]["mount_vfs_texture_archives"] = function: 000002D271B7C5A0
-- _G["__index"]["c_cockpit_param_is_equal_to_another"] = function: 000002D271B7CC60
-- _G["__index"]["a_start_listen_event"] = function: 000002D271B7CE70
-- _G["__index"]["save_to_mission"] = function: 000002D271B7C780
-- _G["__index"]["GetRenderTarget"] = function: 000002D271B7D260
-- _G["__index"]["c_stop_wait_for_user"] = function: 000002D271B7D170
-- _G["__index"]["get_non_sim_random_evenly"] = function: 000002D271B7BF40
-- _G["__index"]["c_argument_in_range"] = function: 000002D271B7D3E0
-- _G["__index"]["a_cockpit_perform_clickable_action"] = function: 000002D271B7CFF0
-- _G["__index"]["a_cockpit_highlight"] = function: 000002D271B7CCF0
-- _G["__index"]["do_mission_file"] = function: 000002D271B7C690
-- _G["__index"]["get_UIMainView"] = function: 000002D271B7BFD0
-- _G["__index"]["get_multimonitor_preset_name"] = function: 000002D271B7BFA0
-- _G["__index"]["select"] = function: 000002D271B780D0
-- _G["__index"]["get_clickable_element_reference"] = function: 000002D271B7CD50
-- _G["__index"]["getmetatable"] = function: 000002D271B78160
-- _G["__index"]["rawget"] = function: 000002D271B78010
-- _G["__index"]["lo_to_geo_coords"] = function: 000002D271B7BE50
-- _G["__index"]["a_start_listen_command"] = function: 000002D271B7CFC0
-- _G["__index"]["dispatch_action"] = function: 000002D271B7C1E0
-- _G["__index"]["dofile"] = function: 000002D271B78880
-- _G["__index"]["mount_vfs_texture_path"] = function: 000002D271B7C0C0
-- _G["__index"]["track_is_writing"] = function: 000002D271B7C480
-- _G["__index"]["error"] = function: 000002D271B77980
-- _G["__index"]["setfenv"] = function: 000002D271B77A70
-- GetSelf = {}
-- GetSelf["link"] = userdata: 000002D1CD9C8CB0
-- GetSelf = {}
-- GetSelf["__index"] = {}
-- GetSelf["__index"]["set_page"] = function: 000002D285284EB0
-- GetSelf["__index"]["add_purpose"] = function: 000002D285284E80
-- GetSelf["__index"]["remove_purpose"] = function: 000002D285284F40
-- GetRenderTarget = -1
-- GetRenderTarget = nil


-- _G["__index"]["LockOn_Options"]["screen"]["oculus_rift"] = true


-- The DCS A-10 uses GetRenderTarget() == 1 to determine if it is the left display, else it is the right display.  I don't know what the function is supposed to return, but it is not working for me.
-- AHA got it.  In case anyone is trying to do something similar, you define the render target ID in the indicators[] definition right after the position corrections

  --[[HUB
  {
    [1] = "package",
    [2] = "_G",
    [3] = "_VERSION",
    [4] = "_GOPHER_LUA_VERSION",
    [5] = "loadstring",
    [6] = "setfenv",
    [7] = "setmetatable",
    [8] = "xpcall",
    [9] = "require",
    [10] = "newproxy",
    [11] = "assert",
    [12] = "getfenv",
    [13] = "rawequal",
    [14] = "unpack",
    [15] = "getmetatable",
    [16] = "load",
    [17] = "print",
    [18] = "rawset",
    [19] = "select",
    [20] = "tonumber",
    [21] = "dofile",
    [22] = "pcall",
    [23] = "next",
    [24] = "module",
    [25] = "error",
    [26] = "rawget",
    [27] = "loadfile",
    [28] = "_printregs",
    [29] = "tostring",
    [30] = "type",
    [31] = "collectgarbage",
    [32] = "ipairs",
    [33] = "pairs",
    [34] = "table",
    [35] = "io",
    [36] = "os",
    [37] = "string",
    [38] = "math",
    [39] = "debug",
    [40] = "channel",
    [41] = "coroutine",
    [42] = "hub",
    [43] = "setFileEnv",
    [44] = "enterEnv",
}
  

    Mission
{
    [1] = "a_do_script_file",
    [2] = "a_out_text_delay_s",
    [3] = "c_part_of_coalition_out_zone",
    [4] = "c_player_score_less",
    [5] = "del_player",
    [6] = "c_unit_altitude_lower_AGL",
    [7] = "a_out_text_delay_u",
    [8] = "get_param_handle",
    [9] = "a_illumination_bomb",
    [10] = "a_remove_radio_item_for_coalition",
    [11] = "tonumber",
    [12] = "c_part_of_coalition_in_zone",
    [13] = "c_time_before",
    [14] = "get_unit_possible_player_roles",
    [15] = "c_flag_equals_flag",
    [16] = "a_fall_in_template",
    [17] = "c_all_of_group_out_zone",
    [18] = "a_rect_to_all",
    [19] = "a_remove_radio_item_for_group",
    [20] = "c_mlrs_in_zone",
    [21] = "copyTable",
    [22] = "netIsRunning",
    [23] = "a_line_to_all",
    [24] = "warehouses",
    [25] = "a_cockpit_lock_player_seat",
    [26] = "a_set_briefing",
    [27] = "a_unit_on",
    [28] = "a_set_command_with_value",
    [29] = "a_do_script",
    [30] = "a_out_sound_u",
    [31] = "c_missile_in_zone",
    [32] = "a_explosion",
    [33] = "a_deactivate_group",
    [34] = "c_all_of_coalition_in_zone",
    [35] = "a_set_ATC_silent_mode",
    [36] = "a_set_failure",
    [37] = "_APP_VERSION",
    [38] = "a_play_argument",
    [39] = "collectgarbage",
    [40] = "c_cockpit_param_in_range",
    [41] = "mission",
    [42] = "c_start_wait_for_user",
    [43] = "c_unit_vertical_speed",
    [44] = "a_out_picture_c",
    [45] = "math",
    [46] = "pcall",
    [47] = "a_shelling_zone",
    [48] = "c_flag_less_flag",
    [49] = "a_unit_emission_on",
    [50] = "value2json",
    [51] = "make_briefing",
    [52] = "Miz",
    [53] = "log",
    [54] = "gcinfo",
    [55] = "c_group_alive",
    [56] = "a_show_helper_gate",
    [57] = "player_slots",
    [58] = "a_set_ai_task",
    [59] = "a_set_internal_cargo_unit",
    [60] = "c_unit_altitude_higher_AGL",
    [61] = "c_flag_more",
    [62] = "a_add_radio_item",
    [63] = "a_effect_smoke_stop",
    [64] = "value2code",
    [65] = "c_unit_dead",
    [66] = "a_radio_transmission",
    [67] = "a_clear_flag",
    [68] = "c_unit_speed_higher",
    [69] = "a_zone_increment_resize",
    [70] = "a_cockpit_param_save_as",
    [71] = "set_player_name",
    [72] = "a_signal_flare",
    [73] = "a_out_text",
    [74] = "c_expression",
    [75] = "a_route_gates_set_current_point",
    [76] = "a_add_safety_zone",
    [77] = "reset_players",
    [78] = "c_cockpit_highlight_visible",
    [79] = "xpcall",
    [80] = "__FINAL_VERSION__",
    [81] = "a_mark_to_all",
    [82] = "check_register",
    [83] = "a_out_picture_stop",
    [84] = "a_prevent_controls_synchronization",
    [85] = "c_dead_zone",
    [86] = "next",
    [87] = "c_mission_score_higher",
    [88] = "c_flag_is_false",
    [89] = "c_unit_in_zone_unit",
    [90] = "rawequal",
    [91] = "a_set_mission_result",
    [92] = "setUnitInvisible",
    [93] = "newproxy",
    [94] = "c_time_after",
    [95] = "getThreatsAllies",
    [96] = "c_group_dead",
    [97] = "GetIndicator",
    [98] = "c_unit_altitude_lower",
    [99] = "a_start_listen_event",
    [100] = "a_out_sound",
    [101] = "c_unit_out_zone",
    [102] = "append_commanders",
    [103] = "tabComanders",
    [104] = "select",
    [105] = "c_cargo_unhooked_in_zone",
    [106] = "a_group_off",
    [107] = "setfenv",
    [108] = "a_add_match_zone",
    [109] = "a_set_flag",
    [110] = "tostring",
    [111] = "c_time_since_flag",
    [112] = "unset_human",
    [113] = "a_remove_radio_item",
    [114] = "list_cockpit_params",
    [115] = "pairs",
    [116] = "a_set_flag_random",
    [117] = "a_aircraft_ctf_color_tag",
    [118] = "assert",
    [119] = "c_player_unit_argument_in_range",
    [120] = "c_flag_equals",
    [121] = "c_coalition_has_airdrome",
    [122] = "load",
    [123] = "c_unit_speed_lower",
    [124] = "c_unit_hit",
    [125] = "a_load_mission",
    [126] = "getValueResourceByKey",
    [127] = "ED_PUBLIC_AVAILABLE",
    [128] = "a_stop_radio_transmission",
    [129] = "coroutine",
    [130] = "show_param_handles_list",
    [131] = "a_ai_task",
    [132] = "serveroptions",
    [133] = "c_group_life_less",
    [134] = "a_out_picture_s",
    [135] = "string",
    [136] = "c_unit_out_zone_unit",
    [137] = "addTblStartData",
    [138] = "a_group_controllable_off",
    [139] = "_l10n_res_default",
    [140] = "a_cockpit_perform_clickable_action",
    [141] = "a_group_stop",
    [142] = "a_cockpit_highlight_position",
    [143] = "table",
    [144] = "_ARCHITECTURE",
    [145] = "update_briefing",
    [146] = "__MAC__",
    [147] = "a_out_picture",
    [148] = "a_effect_smoke",
    [149] = "a_group_controllable_on",
    [150] = "build_slots",
    [151] = "c_unit_in_zone",
    [152] = "a_explosion_unit",
    [153] = "a_out_sound_s",
    [154] = "a_inc_flag",
    [155] = "add_dynamic_group",
    [156] = "getValueDictByKey",
    [157] = "a_cockpit_remove_highlight",
    [158] = "c_signal_flare_in_zone",
    [159] = "a_unit_highlight",
    [160] = "c_flag_less",
    [161] = "a_out_picture_g",
    [162] = "c_player_coalition",
    [163] = "isSeveralClients",
    [164] = "c_part_of_group_out_zone",
    [165] = "a_explosion_marker",
    [166] = "c_flag_is_true",
    [167] = "a_set_altitude",
    [168] = "a_cockpit_unlock_player_seat",
    [169] = "get_server_info",
    [170] = "c_predicate",
    [171] = "c_player_score_more",
    [172] = "options",
    [173] = "a_cockpit_pop_actor",
    [174] = "a_cockpit_push_actor",
    [175] = "c_stop_wait_for_user",
    [176] = "c_indication_txt_equal_to",
    [177] = "a_circle_to_all",
    [178] = "c_cockpit_param_is_equal_to_another",
    [179] = "_G",
    [180] = "c_cockpit_param_equal_to",
    [181] = "c_argument_in_range",
    [182] = "c_unit_argument_in_range",
    [183] = "add_group",
    [184] = "list_indication",
    [185] = "a_remove_match_zone",
    [186] = "USE_TERRAIN4",
    [187] = "a_out_sound_stop",
    [188] = "doZipFile",
    [189] = "_IsAuthorized",
    [190] = "a_out_picture_u",
    [191] = "_l10n_dict_default",
    [192] = "c_unit_altitude_higher",
    [193] = "a_out_sound_c",
    [194] = "a_explosion_marker_unit",
    [195] = "set_human",
    [196] = "c_bomb_in_zone",
    [197] = "ED_FINAL_VERSION",
    [198] = "a_group_on",
    [199] = "remove_dynamic_group",
    [200] = "c_unit_bank",
    [201] = "a_remove_mark",
    [202] = "a_group_resume",
    [203] = "a_mark_to_coalition",
    [204] = "db",
    [205] = "reset_slots",
    [206] = "a_start_world_game_pattern",
    [207] = "a_remove_safety_zone",
    [208] = "c_all_of_group_in_zone",
    [209] = "a_activate_group",
    [210] = "composeWeaponsString",
    [211] = "a_out_text_delay",
    [212] = "loadstring",
    [213] = "a_remove_scene_objects",
    [214] = "a_scenery_destruction_zone",
    [215] = "getAlliesString",
    [216] = "a_user_draw_hide",
    [217] = "unpack",
    [218] = "a_user_draw_show",
    [219] = "c_all_of_coalition_out_zone",
    [220] = "a_cockpit_highlight",
    [221] = "c_unit_alive",
    [222] = "print",
    [223] = "addThreatsAllies",
    [224] = "setmetatable",
    [225] = "c_time",
    [226] = "a_mark_to_group",
    [227] = "c_random_less",
    [228] = "c_part_of_group_in_zone",
    [229] = "a_out_text_delay_c",
    [230] = "a_show_route_gates_for_unit",
    [231] = "ipairs",
    [232] = "set_welcome_info",
    [233] = "a_set_internal_cargo",
    [234] = "value2string",
    [235] = "c_coalition_has_helipad",
    [236] = "getmetatable",
    [237] = "c_unit_heading",
    [238] = "a_cockpit_highlight_indication",
    [239] = "a_set_flag_value",
    [240] = "a_dec_flag",
    [241] = "c_unit_pitch",
    [242] = "occupy_player_slot",
    [243] = "rawset",
    [244] = "a_unit_emission_off",
    [245] = "a_out_sound_g",
    [246] = "a_add_radio_item_for_group",
    [247] = "add_player",
    [248] = "type",
    [249] = "a_unit_off",
    [250] = "traverseTable",
    [251] = "compile_mission",
    [252] = "get_welcome_info",
    [253] = "a_add_radio_item_for_coalition",
    [254] = "__DCS_VERSION__",
    [255] = "release_player_slot",
    [256] = "c_mission_score_lower",
    [257] = "register_unit",
    [258] = "a_signal_flare_unit",
    [259] = "getfenv",
    [260] = "a_out_text_delay_g",
    [261] = "rawget",
    [262] = "a_set_command",
    [263] = "a_start_listen_command",
    [264] = "c_unit_life_less",
    [265] = "c_unit_damaged",
    [266] = "a_end_mission",
    [267] = "GetDevice",
    [268] = "error",
    [269] = "_VERSION",
}

{ Export
    [1] = "safe_require",
    [2] = "LoIsObjectExportAllowed",
    [3] = "tostring",
    [4] = "LoGetObjectById",
    [5] = "LoGetCameraPosition",
    [6] = "LoGetMachNumber",
    [7] = "LoGetRadioBeaconsStatus",
    [8] = "LoGetControlPanel_HSI",
    [9] = "list_cockpit_params",
    [10] = "debug",
    [11] = "get_param_handle",
    [12] = "assert",
    [13] = "tonumber",
    [14] = "LoRemoveSharedTexture",
    [15] = "load",
    [16] = "socket",
    [17] = "LoGetF15_TWS_Contacts",
    [18] = "LoGetVerticalVelocity",
    [19] = "ED_PUBLIC_AVAILABLE",
    [20] = "LoGeoCoordinatesToLoCoordinates",
    [21] = "coroutine",
    [22] = "show_param_handles_list",                     -- Usefull
    [23] = "LoGetVersionInfo",
    [24] = "LoGetRadarAltimeter",
    [25] = "loadstring",
    [26] = "LoGetMechInfo",
    [27] = "LoGetAngularVelocity",
    [28] = "string",
    [29] = "a_cockpit_lock_player_seat",
    [30] = "print",
    [31] = "a_cockpit_perform_clickable_action",
    [32] = "a_cockpit_highlight_position",
    [33] = "table",
    [34] = "_ARCHITECTURE",
    [35] = "LoGetMCPState",
    [36] = "LoSimulationOnPause",
    [37] = "LoSetCameraPosition",
    [38] = "ipairs",
    [39] = "LoSetCommand",
    [40] = "_APP_VERSION",
    [41] = "collectgarbage",
    [42] = "c_cockpit_param_in_range",
    [43] = "c_start_wait_for_user",
    [44] = "LoGetMagneticYaw",
    [45] = "LoGetBasicAtmospherePressure",
    [46] = "math",
    [47] = "LoGetSnares",
    [48] = "pcall",
    [49] = "type",
    [50] = "a_cockpit_remove_highlight",
    [51] = "lfs",
    [52] = "LoGetHelicopterFMData",
    [53] = "LoLoCoordinatesToGeoCoordinates",
    [54] = "LoGetAltitude",
    [55] = "loadfile",
    [56] = "log",
    [57] = "LoGetAccelerationUnits",
    [58] = "gcinfo",
    [59] = "LoGetNavigationInfo",
{
    ["Requirements"] = {
        ["pitch"] = 1.0121020078659,
        ["roll"] = 1.0471975803375,
        ["vertical_speed"] = 0,
        ["speed"] = 416.66665649414,
        ["altitude"] = 12000,
    },
    ["ACS"] = {
        ["autothrust"] = false,
        ["mode"] = "FOLLOW_ROUTE",
    },
    ["SystemMode"] = {
        ["submode"] = "ROUTE",
        ["master"] = "NAV",
    },
}

    [60] = "LoGetSlipBallPosition",
    [61] = "LoSimulationOnActivePause",
    [62] = "LoGetADIPitchBankYaw",
    [63] = "LoGetRoute",
    {
    ["route"] = {
        [1] = {
            ["world_point"] = {
                ["y"] = 6000,
                ["x"] = -156713.921875,
                ["z"] = 843467,
            },
            ["estimated_time"] = 0,
            ["speed_req"] = 256.94445800781,
            ["next_point_num"] = 2,
            ["point_action"] = "TURNPOINT",
            ["this_point_num"] = 1,
        },
        [2] = {
            ["world_point"] = {
                ["y"] = 8000,
                ["x"] = -188142.859375,
                ["z"] = 814428.5625,
            },
            ["estimated_time"] = 171.16110630789,
            ["speed_req"] = 250,
            ["next_point_num"] = 3,
            ["point_action"] = "TURNPOINT",
            ["this_point_num"] = 2,
        },
        [3] = {
            ["world_point"] = {
                ["y"] = 8000,
                ["x"] = -111783.9296875,
                ["z"] = 795775.4375,
            },
            ["estimated_time"] = 487.42300437437,
            ["speed_req"] = 250,
            ["next_point_num"] = 4,
            ["point_action"] = "TURNPOINT",
            ["this_point_num"] = 3,
        },
        [4] = {
            ["world_point"] = {
                ["y"] = 154.61184692383,
                ["x"] = -83329.7890625,
                ["z"] = 835634.6875,
            },
            ["estimated_time"] = 0,
            ["speed_req"] = 0,
            ["next_point_num"] = -1,
            ["point_action"] = "LANDING",
            ["this_point_num"] = 4,
        },
    },
    ["goto_point"] = {
        ["world_point"] = {
            ["y"] = 8000,
            ["x"] = -188142.859375,
            ["z"] = 814428.5625,
        },
        ["estimated_time"] = 171.16110630789,
        ["speed_req"] = 250,
        ["next_point_num"] = 3,
        ["point_action"] = "TURNPOINT",
        ["this_point_num"] = 2,
    },
}
    [64] = "dbg_print",
    [65] = "io",
    [66] = "LoGetPilotName",
    [67] = "LoGetAngleOfSideSlip",
    [68] = "module",
    [69] = "LoGetWindAtPoint",
    [70] = "LoGetSelfData",
    {
    ["Pitch"] = -0.061774808913469,
    ["Type"] = {
        ["level3"] = 1,
        ["level1"] = 1,
        ["level4"] = 3,
        ["level2"] = 1,
    },
    ["Country"] = 0,
    ["GroupName"] = "Su-27",
    ["Flags"] = {
        ["Jamming"] = false,
        ["IRJamming"] = false,
        ["Born"] = true,
        ["Static"] = false,
        ["Invisible"] = false,
        ["Human"] = true,
        ["AI_ON"] = true,
        ["RadarActive"] = false,
    },
    ["Coalition"] = "Allies",
    ["Heading"] = 3.8798534870148,
    ["Name"] = "Su-27",
    ["Position"] = {
        ["y"] = 5267.0973810447,
        ["x"] = -160981.96374683,
        ["z"] = 839498.14540686,
    },
    ["UnitName"] = "Nouveau Surnom",
    ["LatLongAlt"] = {
        ["Long"] = 44.534649471776,
        ["Lat"] = 43.101543635662,
        ["Alt"] = 5267.0973810447,
    },
    ["CoalitionID"] = 1,
    ["Bank"] = 0.0021513907704502,
}
    [71] = "LoGetMissionStartTime",
    [72] = "_G",
    {
    ["safe_require"] = function: 000001FE6BA72000,
    ["LoIsObjectExportAllowed"] = function: 000001FE6BA132E0,
    ["tostring"] = function: 000001FE6BA1EBC0,
    ["LoGetObjectById"] = function: 000001FE6BA22FD0,
    ["LoGetCameraPosition"] = function: 000001FE6BA22C10,
    ["LoGetMachNumber"] = function: 000001FE6BA22400,
    ["LoGetRadioBeaconsStatus"] = function: 000001FE6BA22A60,
    ["LoGetControlPanel_HSI"] = function: 000001FE6BA22730,
    ["list_cockpit_params"] = function: 000001FE6BA13220,
    ["debug"] = {
        ["getupvalue"] = function: 000001FE6BA22070,
        ["debug"] = function: 000001FE6BA22040,
        ["sethook"] = function: 000001FE6BA22250,
        ["getmetatable"] = function: 000001FE6BA21830,
        ["gethook"] = function: 000001FE6BA21860,
        ["setmetatable"] = function: 000001FE6BA21AD0,
        ["setlocal"] = function: 000001FE6BA22130,
        ["traceback"] = function: 000001FE6BA21A10,
        ["setfenv"] = function: 000001FE6BA21F50,
        ["getinfo"] = function: 000001FE6BA22100,
        ["setupvalue"] = function: 000001FE6BA21B90,
        ["getlocal"] = function: 000001FE6BA21E30,
        ["getregistry"] = function: 000001FE6BA220D0,
        ["getfenv"] = function: 000001FE6BA22310,
    },
    ["get_param_handle"] = function: 000001FE6BA20150,
    ["assert"] = function: 000001FE6BA1E5F0,
    ["tonumber"] = function: 000001FE6BA1F3A0,
    ["LoRemoveSharedTexture"] = function: 000001FE6BA12A10,
    ["load"] = function: 000001FE6BA1E4A0,
    ["socket"] = {
        ["sleep"] = function: 000001FDC33ABB00,
        ["source"] = function: 000001FE6BA76AC0,
        ["newtry"] = function: 000001FDC33AB950,
        ["_VERSION"] = "LuaSocket 2.0.2",
        ["connect"] = function: 000001FE6BA76980,
        ["sink"] = function: 000001FE6BA769C0,
        ["__unload"] = function: 000001FDC33AB7D0,
        ["bind"] = function: 000001FE6BA761C0,
        ["_M"] = table: 000001FEF4769570,
        ["_DEBUG"] = true,
        ["skip"] = function: 000001FDC33ADC30,
        ["dns"] = {
            ["gethostname"] = function: 000001FDC33AB230,
            ["tohostname"] = function: 000001FDC33AB350,
            ["toip"] = function: 000001FDC33AB2F0,
        },
        ["gettime"] = function: 000001FDC33AB8C0,
        ["select"] = function: 000001FF63E675C0,
        ["BLOCKSIZE"] = 2048,
        ["sinkt"] = {
            ["default"] = function: 000001FE6BA760C0,
            ["close-when-done"] = function: 000001FE6BA76DC0,
            ["keep-open"] = function: 000001FE6BA760C0,
        },
        ["sourcet"] = {
            ["by-length"] = function: 000001FEF4769020,
            ["default"] = function: 000001FE6BA76400,
            ["until-closed"] = function: 000001FE6BA76400,
        },
        ["tcp"] = function: 000001FEF8EDD2F0,
        ["_NAME"] = "socket",
        ["choose"] = function: 000001FE6BA76CC0,
        ["try"] = function: 000001FE6BA76200,
        ["protect"] = function: 000001FDC33ABC80,
        ["_PACKAGE"] = "",
        ["udp"] = function: 000001FF63E67410,
    },
    ["LoGetF15_TWS_Contacts"] = function: 000001FE6BA22EB0,
    ["LoGetVerticalVelocity"] = function: 000001FE6BA22F70,
    ["ED_PUBLIC_AVAILABLE"] = true,
    ["LoGeoCoordinatesToLoCoordinates"] = function: 000001FE6BA22F10,
    ["coroutine"] = {
        ["resume"] = function: 000001FE6BA1EB30,
        ["yield"] = function: 000001FE6BA1EDA0,
        ["status"] = function: 000001FE6BA1F340,
        ["wrap"] = function: 000001FE6BA1E980,
        ["create"] = function: 000001FE6BA1E5C0,
        ["running"] = function: 000001FE6BA1F130,
    },
    ["show_param_handles_list"] = function: 000001FE6BA20240,
    ["LoGetVersionInfo"] = function: 000001FE6BA22490,
    ["LoGetRadarAltimeter"] = function: 000001FE6BA22460,
    ["loadstring"] = function: 000001FE6BA1E500,
    ["LoGetMechInfo"] = function: 000001FE6BA22AF0,
    ["LoGetAngularVelocity"] = function: 000001FE6BA22BE0,
    ["string"] = {
        ["sub"] = function: 000001FE6BA21620,
        ["upper"] = function: 000001FE6BA21560,
        ["len"] = function: 000001FE6BA21380,
        ["gfind"] = function: 000001FE6BA208D0,
        ["rep"] = function: 000001FE6BA216B0,
        ["find"] = function: 000001FE6BA20690,
        ["match"] = function: 000001FE6BA21650,
        ["char"] = function: 000001FE6BA20480,
        ["dump"] = function: 000001FE6BA204E0,
        ["gmatch"] = function: 000001FE6BA208D0,
        ["reverse"] = function: 000001FE6BA21140,
        ["byte"] = function: 000001FE6BA203C0,
        ["format"] = function: 000001FE6BA207E0,
        ["gsub"] = function: 000001FE6BA209C0,
        ["lower"] = function: 000001FE6BA21020,
    },
    ["a_cockpit_lock_player_seat"] = function: 000001FE6BA12860,
    ["print"] = function: 000001FE6BA1E920,
    ["a_cockpit_perform_clickable_action"] = function: 000001FE6BA12D70,
    ["a_cockpit_highlight_position"] = function: 000001FE6BA131F0,
    ["table"] = {
        ["setn"] = function: 000001FE6BA1F430,
        ["insert"] = function: 000001FE6BA1F640,
        ["getn"] = function: 000001FE6BA1FA60,
        ["foreachi"] = function: 000001FE6BA1FE80,
        ["maxn"] = function: 000001FE6BA1F4C0,
        ["foreach"] = function: 000001FE6BA1F6D0,
        ["concat"] = function: 000001FE6BA1FD30,
        ["sort"] = function: 000001FE6BA1FB80,
        ["remove"] = function: 000001FE6BA1F490,
    },
    ["_ARCHITECTURE"] = "x86_64",
    ["LoGetMCPState"] = function: 000001FE6BA22940,
    ["LoSimulationOnPause"] = function: 000001FE6BA128C0,
    ["LoSetCameraPosition"] = function: 000001FE6BA13160,
    ["ipairs"] = function: 000001FE6BA72D00,
    ["LoSetCommand"] = function: 000001FE6BA20180,
    ["_APP_VERSION"] = "2.7.15.25026",
    ["collectgarbage"] = function: 000001FE6BA1E7A0,
    ["c_cockpit_param_in_range"] = function: 000001FE6BA133A0,
    ["c_start_wait_for_user"] = function: 000001FE6BA13250,
    ["LoGetMagneticYaw"] = function: 000001FE6BA229D0,
    ["LoGetBasicAtmospherePressure"] = function: 000001FE6BA226A0,
    ["math"] = {
        ["log"] = function: 000001FE6BA21200,
        ["max"] = function: 000001FE6BA21440,
        ["acos"] = function: 000001FE6BA21350,
        ["huge"] = inf,
        ["ldexp"] = function: 000001FE6BA20DB0,
        ["pi"] = 3.1415926535898,
        ["cos"] = function: 000001FE6BA21050,
        ["tanh"] = function: 000001FE6BA21890,
        ["pow"] = function: 000001FE6BA20F90,
        ["deg"] = function: 000001FE6BA20C00,
        ["tan"] = function: 000001FE6BA22010,
        ["cosh"] = function: 000001FE6BA213E0,
        ["sinh"] = function: 000001FE6BA21C20,
        ["random"] = function: 000001FE6BA21230,
        ["randomseed"] = function: 000001FE6BA212F0,
        ["frexp"] = function: 000001FE6BA21080,
        ["ceil"] = function: 000001FE6BA20D50,
        ["floor"] = function: 000001FE6BA213B0,
        ["rad"] = function: 000001FE6BA21110,
        ["abs"] = function: 000001FE6BA214A0,
        ["sqrt"] = function: 000001FE6BA221F0,
        ["modf"] = function: 000001FE6BA210E0,
        ["asin"] = function: 000001FE6BA20CF0,
        ["min"] = function: 000001FE6BA210B0,
        ["mod"] = function: 000001FE6BA20C90,
        ["fmod"] = function: 000001FE6BA20C90,
        ["log10"] = function: 000001FE6BA20E10,
        ["atan2"] = function: 000001FE6BA21770,
        ["exp"] = function: 000001FE6BA215F0,
        ["sin"] = function: 000001FE6BA21CB0,
        ["atan"] = function: 000001FE6BA20D20,
    },
    ["LoGetSnares"] = function: 000001FE6BA22CD0,
    ["pcall"] = function: 000001FE6BA1DE70,
    ["type"] = function: 000001FE6BA1ED40,
    ["a_cockpit_remove_highlight"] = function: 000001FE6BA12CE0,
    ["lfs"] = {
        ["normpath"] = function: 000001FE6BA206C0,
        ["locations"] = function: 000001FE6BA20540,
        ["dir"] = function: 000001FE6BA1E590,
        ["tempdir"] = function: 000001FE6BA20510,
        ["realpath"] = function: 000001FE6BA205D0,
        ["writedir"] = function: 000001FE6BA20990,
        ["mkdir"] = function: 000001FE6BA1F550,
        ["currentdir"] = function: 000001FE6BA1FFD0,
        ["add_location"] = function: 000001FE6BA209F0,
        ["attributes"] = function: 000001FE6BA1F400,
        ["create_lockfile"] = function: 000001FE6BA20AE0,
        ["md5sum"] = function: 000001FE6BA20060,
        ["del_location"] = function: 000001FE6BA20420,
        ["chdir"] = function: 000001FE6BA202D0,
        ["rmdir"] = function: 000001FE6BA20A80,
    },
    ["LoGetHelicopterFMData"] = function: 000001FE6BA22EE0,
    ["LoLoCoordinatesToGeoCoordinates"] = function: 000001FE6BA22A30,
    ["LoGetAltitude"] = function: 000001FE6BA22B20,
    ["loadfile"] = function: 000001FE6BA1E950,
    ["log"] = {
        ["FULL"] = 263,
        ["TIME_LOCAL"] = 129,
        ["ALL"] = 255,
        ["set_output"] = function: 000001FE6BA222B0,
        ["LEVEL"] = 2,
        ["DEBUG"] = 128,
        ["IMMEDIATE"] = 1,
        ["ASYNC"] = 0,
        ["ALERT"] = 2,
        ["RELIABLE"] = 32768,
        ["ERROR"] = 8,
        ["debug"] = function: 000001FE6BA72040,
        ["MODULE"] = 4,
        ["error"] = function: 000001FE6BA724C0,
        ["TIME_UTC"] = 1,
        ["TIME"] = 1,
        ["WARNING"] = 16,
        ["INFO"] = 64,
        ["warning"] = function: 000001FE6BA72100,
        ["info"] = function: 000001FE6BA72300,
        ["write"] = function: 000001FE6BA21A40,
        ["TIME_RELATIVE"] = 128,
        ["TRACE"] = 256,
        ["alert"] = function: 000001FE6BA72DC0,
        ["MESSAGE"] = 0,
    },
    ["LoGetAccelerationUnits"] = function: 000001FE6BA226D0,
    ["gcinfo"] = function: 000001FE6BA1E680,
    ["LoGetNavigationInfo"] = function: 000001FE6BA22C70,
    ["LoGetSlipBallPosition"] = function: 000001FE6BA227C0,
    ["LoSimulationOnActivePause"] = function: 000001FE6BA12DA0,
    ["LoGetADIPitchBankYaw"] = function: 000001FE6BA22760,
    ["LoGetRoute"] = function: 000001FE6BA22880,
    ["dbg_print"] = function: 000001FE6BA12AA0,
    ["io"] = {
        ["read"] = function: 000001FE6BA1F9D0,
        ["write"] = function: 000001FE6BA1F970,
        ["close"] = function: 000001FE6BA1FDC0,
        ["lines"] = function: 000001FE6BA1FAF0,
        ["flush"] = function: 000001FE6BA1F3D0,
        ["open"] = function: 000001FE6BA1F940,
        ["__gc"] = function: 000001FE6BA1FC70,
    },
    ["LoGetPilotName"] = function: 000001FE6BA22910,
    ["LoGetAngleOfSideSlip"] = function: 000001FE6BA22970,
    ["module"] = function: 000001FE6BA1FFA0,
    ["LoGetWindAtPoint"] = function: 000001FE6BA225B0,
    ["LoGetSelfData"] = function: 000001FE6BA22550,
    ["LoGetMissionStartTime"] = function: 000001FE6BA228B0,
    ["_G"] = table: 000001FEFB231550,
    ["list_indication"] = function: 000001FE6BA12D10,
    ["a_cockpit_param_save_as"] = function: 000001FE6BA127D0,
    ["LoGetWingTargets"] = function: 000001FE6BA22E50,
    ["LoGetTargetInformation"] = function: 000001FE6BA22820,
    ["LoGetTWSInfo"] = function: 000001FE6BA22DF0,
    ["LoGetVectorWindVelocity"] = function: 000001FE6BA22A90,
    ["ED_FINAL_VERSION"] = true,
    ["modAutoloadPath"] = "C:\\Users\\punko\\Saved Games\\DCS\\Mods\\Aircraft\\VNAO_T45\\SRS\\autoload.lua",
    ["c_cockpit_highlight_visible"] = function: 000001FE6BA12F50,
    ["LoCreateCoroutineActivity"] = function: 000001FE6BA21DD0,
    ["LuaExportBeforeNextFrame"] = function: 000001FEF476A380,
    ["xpcall"] = function: 000001FE6BA1F1F0,
    ["LoGetSideDeviation"] = function: 000001FE6BA22BB0,
    ["package"] = {
        ["preload"] = {
        },
        ["loadlib"] = function: 000001FE6BA1EB90,
        ["loaded"] = {
            ["string"] = table: 000001FEFB231280,
            ["debug"] = table: 000001FEFB231640,
            ["lfs"] = table: 000001FEFB231460,
            ["_G"] = table: 000001FEFB231550,
            ["terrain"] = {
                ["GetSurfaceType"] = function: 000001FE4B911AB0,
                ["GetTerrainConfig"] = function: 000001FE4B911E70,
                ["findPathOnRoads"] = function: 000001FE4B912380,
                ["getObjectsAtMapPoint"] = function: 000001FE4B912230,
                ["getStandList"] = function: 000001FE4B9121A0,
                ["getTechSkinByDate"] = function: 000001FE4B912A40,
                ["GetSurfaceHeightWithSeabed"] = function: 000001FE4B911C90,
                ["getBeacons"] = function: 000001FE4B912290,
                ["InitLight"] = function: 000001FE4B911DE0,
                ["getCrossParam"] = function: 000001FE4B9122C0,
                ["convertMGRStoMeters"] = function: 000001FE4B912740,
                ["getRunwayList"] = function: 000001FE4B912140,
                ["getClosestPointOnRoads"] = function: 000001FE4B912350,
                ["getTempratureRangeByDate"] = function: 000001FE4B912710,
                ["isVisible"] = function: 000001FE4B911990,
                ["getRadio"] = function: 000001FE4B9122F0,
                ["Init"] = function: 000001FEE76757B0,
                ["getClosestValidPoint"] = function: 000001FE4B912110,
                ["getObjectPosition"] = function: 000001FE4B912980,
                  return terrain.getObjectsAtMapPoint(1321.801758,12.352437,246748.5)
                                    return terrain.getObjectsAtMapPoint(37.396435,45.039907)

                ["Create"] = function: 000001FE4B911810,
                ["getRunwayHeading"] = function: 000001FE4B9123E0,
                ["FindNearestPoint"] = function: 000001FE4B912890,
                ["GetHeight"] = function: 000001FE4B911EA0,
                ["convertLatLonToMeters"] = function: 000001FE4B912AD0,
                ["GetSeasons"] = function: 000001FE4B911E40,
                ["Release"] = function: 000001FE4B911A50,
                ["FindOptimalPath"] = function: 000001FE4B912650,
                ["convertMetersToLatLon"] = function: 000001FE4B9128C0,
                ["GetMGRScoordinates"] = function: 000001FE4B912320,
            },
            ["socket.core"] = table: 000001FEF4769570,
            ["socket"] = table: 000001FEF4769570,
            ["io"] = table: 000001FEFB231410,
            ["os"] = {
                ["getpid"] = function: 000001FE6BA20630,
                ["date"] = function: 000001FE6BA1E1D0,
                ["getenv"] = function: 000001FE6BA72400,
                ["difftime"] = function: 000001FE6BA1EE30,
                ["remove"] = function: 000001FE6BA20960,
                ["time"] = function: 000001FE6BA20600,
                ["run_process"] = function: 000001FE6BA20840,
                ["clock"] = function: 000001FE6BA1E620,
                ["open_uri"] = function: 000001FE6BA20270,
                ["rename"] = function: 000001FE6BA20330,
                ["execute"] = function: 000001FE6BA72D80,
            },
            ["table"] = table: 000001FEFB231F50,
            ["math"] = table: 000001FEFB231AA0,
            ["log"] = table: 000001FEFB231690,
            ["coroutine"] = table: 000001FEFB231000,
            ["package"] = table: 000001FEFB231230,
        },
        ["loaders"] = {
            [1] = function: 000001FE6BA1EE00,
            [2] = function: 000001FE6BA72CC0,
            [3] = function: 000001FE6BA1FCD0,
            [4] = function: 000001FE6BA1EF20,
            [5] = function: 000001FE6BA1FDF0,
        },
        ["cpath"] = ".\\lua-?.dll;.\\?.dll;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\lua-?.dll;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\?.dll;;.\\LuaSocket\\?.dll;",
        ["config"] = "\\\
;\
?\
!\
-",
        ["path"] = ";.\\?.lua;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\lua\\?.lua;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\lua\\?\\init.lua;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\?.lua;C:\\Program Files (x86)\\Steam\\steamapps\\common\\DCSWorld\\bin\\?\\init.lua;C:\\Program Files (x86)\\Lua\\5.1\\lua\\?.luac;.\\LuaSocket\\?.lua;;./dxgui/bind/?.lua;./dxgui/loader/?.lua;./dxgui/skins/skinME/?.lua;./dxgui/skins/common/?.lua;./MissionEditor/?.lua;./MissionEditor/themes/main/?.lua;./MissionEditor/modules/?.lua;./Scripts/?.lua;./LuaSocket/?.lua;./Scripts/UI/?.lua;./Scripts/UI/Multiplayer/?.lua;./Scripts/DemoScenes/?.lua;",
        ["seeall"] = function: 000001FE6BA1EBF0,
    },
    ["LuaExportActivityNextEvent"] = function: 000001FEF476ACE0,
    ["_VERSION"] = "Lua 5.1",
    ["terrain"] = table: 000001FEF4769CA0,
    ["LoUpdateSharedTexture"] = function: 000001FE6BA12800,
    ["LoGetGlideDeviation"] = function: 000001FE6BA22430,
    ["LoSetSharedTexture"] = function: 000001FE6BA13340,
    ["unpack"] = function: 000001FE6BA1F220,
    ["log_G_effect"] = function: 000001FE6BA12C80,
    ["LoGetIndicatedAirSpeed"] = function: 000001FE6BA22D30,
    ["require"] = function: 000001FE6BA1F7F0,
    ["a_cockpit_unlock_player_seat"] = function: 000001FE6BA12FB0,
    ["a_cockpit_pop_actor"] = function: 000001FE6BA12DD0,
    ["a_cockpit_push_actor"] = function: 000001FE6BA12EC0,
    ["setmetatable"] = function: 000001FE6BA1E7D0,
    ["next"] = function: 000001FE6BA1DDE0,
    ["LoGetEngineInfo"] = function: 000001FE6BA22D00,
    ["c_indication_txt_equal_to"] = function: 000001FE6BA12D40,
    ["LoGetLockedTargetInformation"] = function: 000001FE6BA22AC0,
    ["os"] = table: 000001FEFB2317D0,
    ["a_cockpit_highlight"] = function: 000001FE6BA13100,
    ["LoGetWingInfo"] = function: 000001FE6BA22850,
    ["rawequal"] = function: 000001FE6BA1EF80,
    ["LoGetHeightWithObjects"] = function: 000001FE6BA22E20,
    ["getfenv"] = function: 000001FE6BA1E6B0,
    ["c_cockpit_param_is_equal_to_another"] = function: 000001FE6BA12B00,
    ["newproxy"] = function: 000001FE6BA71FC0,
    ["pairs"] = function: 000001FE6BA71EC0,
    ["a_cockpit_highlight_indication"] = function: 000001FE6BA129E0,
    ["LoGetPlayerPlaneId"] = function: 000001FE6BA22B50,
    ["c_cockpit_param_equal_to"] = function: 000001FE6BA12B60,
    ["c_argument_in_range"] = function: 000001FE6BA12AD0,
    ["LoGetAngleOfAttack"] = function: 000001FE6BA22640,
    ["rawset"] = function: 000001FE6BA1F1C0,
    ["LoGetModelTime"] = function: 000001FE6BA225E0,
    ["GetIndicator"] = function: 000001FE6BA12830,
    ["getmetatable"] = function: 000001FE6BA1E320,
    ["a_start_listen_event"] = function: 000001FE6BA12A40,
    ["LoGetFMData"] = function: 000001FE6BA224F0,
    ["LoGetShakeAmplitude"] = function: 000001FE6BA12B30,
    ["c_stop_wait_for_user"] = function: 000001FE6BA12C20,
    ["dofile"] = function: 000001FE6BA1EEC0,
    ["LoGetPayloadInfo"] = function: 000001FE6BA22CA0,
      {
    ["Stations"] = {
        [1] = {
            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 106,
                ["level2"] = 4,
            },
        },
        [2] = {
            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 106,
                ["level2"] = 4,
            },
        },
        [3] = {
            ["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 43,
                ["level1"] = 1,
                ["level4"] = 10,
                ["level2"] = 3,
            },
        },
        [4] = {
            ["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 43,
                ["level1"] = 1,
                ["level4"] = 10,
                ["level2"] = 3,
            },
        },
        [5] = {
            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 106,
                ["level2"] = 4,
            },
        },
        [6] = {
            ["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 106,
                ["level2"] = 4,
            },
        },
        [7] = {
            ["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 24,
                ["level2"] = 4,
            },
        },
        [8] = {
            ["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 24,
                ["level2"] = 4,
            },
        },
        [9] = {
            ["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 24,
                ["level2"] = 4,
            },
        },
        [10] = {
            ["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 7,
                ["level1"] = 4,
                ["level4"] = 24,
                ["level2"] = 4,
            },
        },
        [11] = {
            ["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
            ["container"] = false,
            ["count"] = 1,
            ["weapon"] = {
                ["level3"] = 43,
                ["level1"] = 1,
                ["level4"] = 10,
                ["level2"] = 3,
            },
        },
    },
    ["CurrentStation"] = 0,
    ["Cannon"] = {
        ["shells"] = 940,
    },
}
    ["LoGetInAir"] = function: 000001FE6BA13010,
    ["LoGetAltitudeAboveSeaLevel"] = function: 000001FE6BA223D0,
    ["LoIsSensorExportAllowed"] = function: 000001FE6BA12A70,
    ["LoGetWorldObjects"] = function: 000001FE6BA131C0,
    ["LoGetTrueAirSpeed"] = function: 000001FE6BA22700,
    ["select"] = function: 000001FE6BA1E830,
    ["LoGetAircraftDrawArgumentValue"] = function: 000001FE6BA13310,
    ["LoGetSightingSystemInfo"] = function: 000001FE6BA22F40,
      {
    ["PRF"] = {
        ["selection"] = "ILV",
        ["current"] = "MED",
    },
    ["laser_on"] = false,
    ["scale"] = {
        ["azimuth"] = 1.0471974611282,
        ["distance"] = 37040,
    },
    ["radar_on"] = false,
    ["optical_system_on"] = false,
    ["LaunchAuthorized"] = false,
    ["ECM_on"] = false,
    ["Manufacturer"] = "USA",
    ["TDC"] = {
        ["y"] = 0,
        ["x"] = 0,
    },
    ["ScanZone"] = {
        ["coverage_H"] = {
            ["min"] = 0,
            ["max"] = 20000,
        },
        ["size"] = {
            ["azimuth"] = 1.0471974611282,
            ["elevation"] = 0.17453290522099,
        },
        ["position"] = {
            ["azimuth"] = 0,
            ["elevation"] = 0,
        },
    },
}
    ["rawget"] = function: 000001FE6BA1F040,
    ["LoIsOwnshipExportAllowed"] = function: 000001FE6BA12CB0,
    ["a_start_listen_command"] = function: 000001FE6BA13130,
    ["LoGetVectorVelocity"] = function: 000001FE6BA224C0,
    ["setfenv"] = function: 000001FE6BA1EDD0,
    ["LoGetNameByType"] = function: 000001FE6BA22E80,
    ["GetDevice"] = function: 000001FE6BA12BF0,
    ["error"] = function: 000001FE6BA1DC00,
    ["LoGetAltitudeAboveGroundLevel"] = function: 000001FE6BA22D90,
}
    [73] = "list_indication",
    [74] = "a_cockpit_param_save_as",
    [75] = "LoGetWingTargets",
    {
    [1] = {
        ["y"] = 9999.9998112215,
        ["x"] = -191862.38764177,
        ["z"] = 797163.65159751,
    },
    [2] = {
        ["y"] = 8094.0571096397,
        ["x"] = -185891.56997911,
        ["z"] = 818725.32842386,
    },
    [3] = {
        ["y"] = 8082.7225374807,
        ["x"] = -187281.97584642,
        ["z"] = 820411.50851285,
    },
}
    [76] = "LoGetTargetInformation",
    {
    [1] = {
        ["convergence_velocity"] = 427.298828125,
        ["velocity"] = {
            ["y"] = -13.866837501526,
            ["x"] = 153.76219177246,
            ["z"] = 85.681991577148,
        },
        ["delta_psi"] = 3.3464758396149,
        ["reflection"] = 3,
        ["ID"] = 16781312,
        ["mach"] = 0.58062392473221,
        ["course"] = 5.7524099349976,
        ["fin"] = 0.02006440795958,
        ["distance"] = 44042.45703125,
        ["jammer_burned"] = true,
        ["country"] = 2,
        ["fim"] = -0.11503754556179,
        ["forces"] = {
            ["y"] = 1.6473392248154,
            ["x"] = -0.0058913049288094,
            ["z"] = 0,
        },
        ["start_of_lock"] = 0,
        ["position"] = {
            ["y"] = {
                ["y"] = 0.59633588790894,
                ["x"] = -0.5527440905571,
                ["z"] = 0.58211469650269,
            },
            ["x"] = {
                ["y"] = 0.058167520910501,
                ["x"] = 0.75301223993301,
                ["z"] = 0.65543049573898,
            },
            ["p"] = {
                ["y"] = 8936.466796875,
                ["x"] = -196000.34375,
                ["z"] = 814641.75,
            },
            ["z"] = {
                ["y"] = -0.80062484741211,
                ["x"] = -0.35699653625488,
                ["z"] = 0.4811999797821,
            },
        },
        ["flags"] = 2,
        ["updates_number"] = 1,
        ["isjamming"] = 0,
        ["type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 276,
            ["level2"] = 1,
        },
    },
    [2] = {
        ["convergence_velocity"] = 427.03668212891,
        ["velocity"] = {
            ["y"] = -11.823453903198,
            ["x"] = 156.38824462891,
            ["z"] = 81.755500793457,
        },
        ["delta_psi"] = 3.3741066455841,
        ["reflection"] = 3,
        ["ID"] = 16781056,
        ["mach"] = 0.58159232139587,
        ["course"] = 5.780041217804,
        ["fin"] = 0.0203165281564,
        ["distance"] = 43867.29296875,
        ["jammer_burned"] = true,
        ["country"] = 2,
        ["fim"] = -0.088058635592461,
        ["forces"] = {
            ["y"] = 0.95553195476532,
            ["x"] = 0.081402152776718,
            ["z"] = 0,
        },
        ["start_of_lock"] = 0,
        ["position"] = {
            ["y"] = {
                ["y"] = 0.9749967455864,
                ["x"] = -0.16892379522324,
                ["z"] = 0.14438192546368,
            },
            ["x"] = {
                ["y"] = 0.073568604886532,
                ["x"] = 0.85845929384232,
                ["z"] = 0.50757777690887,
            },
            ["p"] = {
                ["y"] = 8935.9482421875,
                ["x"] = -195164.1875,
                ["z"] = 813783.5625,
            },
            ["z"] = {
                ["y"] = -0.20968797802925,
                ["x"] = -0.48426470160484,
                ["z"] = 0.84942251443863,
            },
        },
        ["flags"] = 2,
        ["updates_number"] = 1,
        ["isjamming"] = 0,
        ["type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 276,
            ["level2"] = 1,
        },
    },
    [3] = {
        ["convergence_velocity"] = 447.95892333984,
        ["velocity"] = {
            ["y"] = 0.96360766887665,
            ["x"] = 276.63336181641,
            ["z"] = -9.0620718002319,
        },
        ["delta_psi"] = -2.3880429267883,
        ["reflection"] = 100,
        ["ID"] = 16780544,
        ["mach"] = 0.92375069856644,
        ["course"] = 0.017892131581903,
        ["fin"] = 0.015852456912398,
        ["distance"] = 62210.2421875,
        ["jammer_burned"] = true,
        ["country"] = 2,
        ["fim"] = 0.022740878164768,
        ["forces"] = {
            ["y"] = 1.1013648509979,
            ["x"] = 0.011329373344779,
            ["z"] = 0,
        },
        ["start_of_lock"] = 0,
        ["position"] = {
            ["y"] = {
                ["y"] = 0.99904799461365,
                ["x"] = -0.038479711860418,
                ["z"] = 0.020555006340146,
            },
            ["x"] = {
                ["y"] = 0.038834765553474,
                ["x"] = 0.99909818172455,
                ["z"] = -0.017162943258882,
            },
            ["p"] = {
                ["y"] = 9991.208984375,
                ["x"] = -205326.25,
                ["z"] = 797474.8125,
            },
            ["z"] = {
                ["y"] = -0.019876044243574,
                ["x"] = 0.017944853752851,
                ["z"] = 0.99964135885239,
            },
        },
        ["flags"] = 2,
        ["updates_number"] = 1,
        ["isjamming"] = 0,
        ["type"] = {
            ["level3"] = 4,
            ["level1"] = 1,
            ["level4"] = 23,
            ["level2"] = 1,
        },
    },
}
    [77] = "LoGetTWSInfo",
    {
    ["Emitters"] = {
        [1] = {
            ["Type"] = {
                ["level3"] = 1,
                ["level1"] = 1,
                ["level4"] = 276,
                ["level2"] = 1,
            },
            ["Azimuth"] = -0.11515157669783,
            ["Power"] = 0.13909465074539,
            ["ID"] = 16781312,
            ["Priority"] = 160.13909912109,
            ["SignalType"] = "scan",
        },
        [2] = {
            ["Type"] = {
                ["level3"] = 1,
                ["level1"] = 1,
                ["level4"] = 276,
                ["level2"] = 1,
            },
            ["Azimuth"] = -0.088299550116062,
            ["Power"] = 0.12545901536942,
            ["ID"] = 16781056,
            ["Priority"] = 160.12545776367,
            ["SignalType"] = "scan",
        },
        [3] = {
            ["Type"] = {
                ["level3"] = 5,
                ["level1"] = 1,
                ["level4"] = 26,
                ["level2"] = 1,
            },
            ["Azimuth"] = -3.0805068016052,
            ["Power"] = 0.84203225374222,
            ["ID"] = 16780288,
            ["Priority"] = 110.84203338623,
            ["SignalType"] = "scan",
        },
    },
    ["Mode"] = 0,
}
    [78] = "LoGetVectorWindVelocity",
    [79] = "ED_FINAL_VERSION",
    [80] = "modAutoloadPath",
    [81] = "c_cockpit_highlight_visible",
    [82] = "LoCreateCoroutineActivity",
    [83] = "LuaExportBeforeNextFrame",
    [84] = "xpcall",
    [85] = "LoGetSideDeviation",
    [86] = "package",
    [87] = "LuaExportActivityNextEvent",
    [88] = "_VERSION",
    [89] = "terrain",
    [90] = "LoUpdateSharedTexture",
    [91] = "LoGetGlideDeviation",
    [92] = "LoSetSharedTexture",
    [93] = "unpack",
    [94] = "log_G_effect",
    [95] = "LoGetIndicatedAirSpeed",
    [96] = "require",
    [97] = "a_cockpit_unlock_player_seat",
    [98] = "a_cockpit_pop_actor",
    [99] = "a_cockpit_push_actor",
    [100] = "setmetatable",
    [101] = "next",
    [102] = "LoGetEngineInfo",
    {
    ["fuel_external"] = 0,
    ["Temperature"] = {
        ["left"] = 566.36724853516,
        ["right"] = 566.36724853516,
    },
    ["RPM"] = {
        ["left"] = 86.72013092041,
        ["right"] = 86.72013092041,
    },
    ["FuelConsumption"] = {
        ["left"] = 0.11065668572294,
        ["right"] = 0.11065668572294,
    },
    ["fuel_internal"] = 6541.3286132813,
    ["EngineStart"] = {
        ["left"] = 0,
        ["right"] = 0,
    },
    ["HydraulicPressure"] = {
        ["left"] = 280,
        ["right"] = 280,
    },
}
    [103] = "c_indication_txt_equal_to",
    [104] = "LoGetLockedTargetInformation",
    {
    [1] = {
        ["target"] = {
            ["convergence_velocity"] = 431.39785766602,
            ["velocity"] = {
                ["y"] = -13.39119720459,
                ["x"] = 148.77941894531,
                ["z"] = 104.86042785645,
            },
            ["delta_psi"] = 3.2442164421082,
            ["reflection"] = 3,
            ["ID"] = 16781312,
            ["mach"] = 0.5996373295784,
            ["course"] = 5.6501531600952,
            ["fin"] = 0.046411082148552,
            ["distance"] = 41982.16015625,
            ["jammer_burned"] = true,
            ["country"] = 2,
            ["fim"] = -0.1182609423995,
            ["forces"] = {
                ["y"] = 1.0511620044708,
                ["x"] = 0.087005533277988,
                ["z"] = 0,
            },
            ["start_of_lock"] = 22.313,
            ["position"] = {
                ["y"] = {
                    ["y"] = 0.99648529291153,
                    ["x"] = -0.0070530655793846,
                    ["z"] = -0.083470590412617,
                },
                ["x"] = {
                    ["y"] = 0.054666467010975,
                    ["x"] = 0.80977147817612,
                    ["z"] = 0.58419322967529,
                },
                ["p"] = {
                    ["y"] = 8873.091796875,
                    ["x"] = -195289.65625,
                    ["z"] = 815120.625,
                },
                ["z"] = {
                    ["y"] = 0.063471756875515,
                    ["x"] = -0.58670300245285,
                    ["z"] = 0.80731093883514,
                },
            },
            ["flags"] = 10,
            ["updates_number"] = 2,
            ["isjamming"] = 0,
            ["type"] = {
                ["level3"] = 1,
                ["level1"] = 1,
                ["level4"] = 276,
                ["level2"] = 1,
            },
        },
        ["DLZ"] = {
            ["RAERO"] = 40552.9296875,
            ["RMIN"] = 1500,
            ["RPI"] = 40481.76953125,
            ["RTR"] = 13517.62890625,
        },
    },
}
    [105] = "os",
    [106] = "a_cockpit_highlight",
    [107] = "LoGetWingInfo",
    {
    [2] = {
        ["ordered_task"] = "INTERCEPT",
        ["ordered_target"] = 0,
        ["current_target"] = 0,
        ["wingmen_id"] = 16782848,
        ["current_task"] = "ROUTE",
        ["wingmen_position"] = {
            ["y"] = {
                ["y"] = 0.99887412786484,
                ["x"] = 0.034232284873724,
                ["z"] = 0.032843485474586,
            },
            ["x"] = {
                ["y"] = 0.047419615089893,
                ["x"] = -0.74071460962296,
                ["z"] = -0.67014420032501,
            },
            ["p"] = {
                ["y"] = 5774.3139648438,
                ["x"] = -159994.046875,
                ["z"] = 838973.4375,
            },
            ["z"] = {
                ["y"] = 0.0013870820403099,
                ["x"] = 0.67094713449478,
                ["z"] = -0.74150395393372,
            },
        },
    },
}
    [108] = "rawequal",
    [109] = "LoGetHeightWithObjects",
    [110] = "getfenv",
    [111] = "c_cockpit_param_is_equal_to_another",
    [112] = "newproxy",
    [113] = "pairs",
    [114] = "a_cockpit_highlight_indication",
    [115] = "LoGetPlayerPlaneId",
    [116] = "c_cockpit_param_equal_to",
    [117] = "c_argument_in_range",
    [118] = "LoGetAngleOfAttack",
    [119] = "rawset",
    [120] = "LoGetModelTime",
    [121] = "GetIndicator",
    [122] = "getmetatable",
    [123] = "a_start_listen_event",
    [124] = "LoGetFMData",
    [125] = "LoGetShakeAmplitude",
    [126] = "c_stop_wait_for_user",
    [127] = "dofile",
    [128] = "LoGetPayloadInfo",
    [129] = "LoGetInAir",
    [130] = "LoGetAltitudeAboveSeaLevel",
    [131] = "LoIsSensorExportAllowed",
    [132] = "LoGetWorldObjects",
    {
    [16781312] = {
        ["Pitch"] = 0.054885979741812,
        ["Type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 276,
            ["level2"] = 1,
        },
        ["Country"] = 3,
        ["GroupName"] = "F-5 Escort",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Enemies",
        ["Heading"] = 0.63289976119995,
        ["Name"] = "F-5E-3",
        ["Position"] = {
            ["y"] = 8872.7709755026,
            ["x"] = -195286.08833912,
            ["z"] = 815123.14683053,
        },
        ["UnitName"] = "Pilot #6",
        ["LatLongAlt"] = {
            ["Long"] = 44.185166220388,
            ["Lat"] = 42.828161437736,
            ["Alt"] = 8872.7709755026,
        },
        ["CoalitionID"] = 2,
        ["Bank"] = -0.064483337104321,
    },
    [16782848] = {
        ["Pitch"] = 0.047434475272894,
        ["Type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 3,
            ["level2"] = 1,
        },
        ["Country"] = 0,
        ["GroupName"] = "Su-27",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 3.8770771026611,
        ["Name"] = "Su-27",
        ["Position"] = {
            ["y"] = 5774.3138177431,
            ["x"] = -159994.0542534,
            ["z"] = 838973.42512789,
        },
        ["UnitName"] = "Pilot #2",
        ["LatLongAlt"] = {
            ["Long"] = 44.529989923082,
            ["Lat"] = 43.110905297878,
            ["Alt"] = 5774.3138177431,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = -0.0013868249952793,
    },
    [16777472] = {
        ["Pitch"] = -9.8443808383308e-05,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 71,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #024",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 1.4311699867249,
        ["Name"] = "ZIL-4331",
        ["Position"] = {
            ["y"] = 154.62132401786,
            ["x"] = -83821.882812784,
            ["z"] = 834824.68750014,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.609614099215,
            ["Lat"] = 43.787979566167,
            ["Alt"] = 154.62132401786,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00030028438777663,
    },
    [16777984] = {
        ["Pitch"] = -0.00018458210979588,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 71,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #026",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 5.4628808498383,
        ["Name"] = "ZIL-4331",
        ["Position"] = {
            ["y"] = 154.62482759579,
            ["x"] = -83905.796874665,
            ["z"] = 834918.31250006,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.610608627488,
            ["Lat"] = 43.787122102713,
            ["Alt"] = 154.62482759579,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00028584495885298,
    },
    [16778496] = {
        ["Pitch"] = 0.00028610229492188,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 6,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #028",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 3.8920843601227,
        ["Name"] = "ZiL-131 APA-80",
        ["Position"] = {
            ["y"] = 154.61455276113,
            ["x"] = -83898.843749666,
            ["z"] = 835047.25000006,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.612190308346,
            ["Lat"] = 43.787021726791,
            ["Alt"] = 154.61455276113,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00018238625489175,
    },
    [16779008] = {
        ["Pitch"] = 0,
        ["Type"] = {
            ["level3"] = 0,
            ["level1"] = 0,
            ["level4"] = 0,
            ["level2"] = 0,
        },
        ["Country"] = 0,
        ["Coalition"] = "Allies",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = false,
        },
        ["Name"] = "iso_container",
        ["Position"] = {
            ["y"] = 154.62487792969,
            ["x"] = -83919.359375,
            ["z"] = 834974.5625,
        },
        ["Heading"] = 6.2831854820251,
        ["LatLongAlt"] = {
            ["Long"] = 44.611269921259,
            ["Lat"] = 43.786931952525,
            ["Alt"] = 154.62487792969,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0,
    },
    [16779520] = {
        ["Pitch"] = -3.5384608437772e-11,
        ["Type"] = {
            ["level3"] = 26,
            ["level1"] = 2,
            ["level4"] = 96,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #020",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 4.5902162790298,
        ["Name"] = "outpost",
        ["Position"] = {
            ["y"] = 154.443337025,
            ["x"] = -83994.765629714,
            ["z"] = 834913.06250058,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.610390718535,
            ["Lat"] = 43.786344045706,
            ["Alt"] = 154.443337025,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = -0.0047492594458163,
    },
    [16780032] = {
        ["Pitch"] = 0.00025226222351193,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 71,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #032",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 4.0666172504425,
        ["Name"] = "ZIL-4331",
        ["Position"] = {
            ["y"] = 154.63772089735,
            ["x"] = -83926.562499665,
            ["z"] = 834821.62500006,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.609395635574,
            ["Lat"] = 43.787060203549,
            ["Alt"] = 154.63772089735,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00022926702513359,
    },
    [16780544] = {
        ["Pitch"] = 0.035584557801485,
        ["Type"] = {
            ["level3"] = 4,
            ["level1"] = 1,
            ["level4"] = 23,
            ["level2"] = 1,
        },
        ["Country"] = 2,
        ["GroupName"] = "B-52 1",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Enemies",
        ["Heading"] = 6.2688658162951,
        ["Name"] = "B-52H",
        ["Position"] = {
            ["y"] = 9996.0903514267,
            ["x"] = -204012.69218746,
            ["z"] = 797434.20644675,
        },
        ["UnitName"] = "Pilot #3",
        ["LatLongAlt"] = {
            ["Long"] = 43.958955399086,
            ["Lat"] = 42.771826541882,
            ["Alt"] = 9996.0903514267,
        },
        ["CoalitionID"] = 2,
        ["Bank"] = 0.021039433777332,
    },
    [16781056] = {
        ["Pitch"] = 0.054601445794106,
        ["Type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 276,
            ["level2"] = 1,
        },
        ["Country"] = 3,
        ["GroupName"] = "F-5 Escort",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Enemies",
        ["Heading"] = 0.50361394882202,
        ["Name"] = "F-5E-3",
        ["Position"] = {
            ["y"] = 8875.0573088329,
            ["x"] = -194403.35003382,
            ["z"] = 814187.26670581,
        },
        ["UnitName"] = "Pilot #5",
        ["LatLongAlt"] = {
            ["Long"] = 44.175356809703,
            ["Lat"] = 42.837070685075,
            ["Alt"] = 8875.0573088329,
        },
        ["CoalitionID"] = 2,
        ["Bank"] = -0.056455615907907,
    },
    [16782592] = {
        ["Pitch"] = 0.027682505548,
        ["Type"] = {
            ["level3"] = 1,
            ["level1"] = 1,
            ["level4"] = 3,
            ["level2"] = 1,
        },
        ["Country"] = 0,
        ["GroupName"] = "Su-27",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = false,
            ["Human"] = true,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 3.8772490024567,
        ["Name"] = "Su-27",
        ["Position"] = {
            ["y"] = 5772.3754200925,
            ["x"] = -161150.97480738,
            ["z"] = 839347.38371997,
        },
        ["UnitName"] = "Nouveau Surnom",
        ["LatLongAlt"] = {
            ["Long"] = 44.532550512904,
            ["Lat"] = 43.100237971848,
            ["Alt"] = 5772.3754200925,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = -2.0103781935177e-05,
    },
    [16777728] = {
        ["Pitch"] = 4.0963190258481e-05,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 40,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #025",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 6.1610123440623,
        ["Name"] = "Ural-375",
        ["Position"] = {
            ["y"] = 154.61020475702,
            ["x"] = -83817.875000012,
            ["z"] = 834879.06250024,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.610282993788,
            ["Lat"] = 43.787946729241,
            ["Alt"] = 154.61020475702,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00023809673439246,
    },
    [16778240] = {
        ["Pitch"] = 0.0003123443457298,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 6,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #027",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 3.735004901886,
        ["Name"] = "Ural ATsP-6",
        ["Position"] = {
            ["y"] = 154.58758107788,
            ["x"] = -83817.101562166,
            ["z"] = 835042.68750006,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.612276278538,
            ["Lat"] = 43.787748351607,
            ["Alt"] = 154.58758107788,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00013495306484401,
    },
    [16778752] = {
        ["Pitch"] = 0,
        ["Type"] = {
            ["level3"] = 0,
            ["level1"] = 0,
            ["level4"] = 0,
            ["level2"] = 0,
        },
        ["Country"] = 0,
        ["Coalition"] = "Allies",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = false,
        },
        ["Name"] = "fueltank_cargo",
        ["Position"] = {
            ["y"] = 154.62580871582,
            ["x"] = -83917.3359375,
            ["z"] = 834948.6875,
        },
        ["Heading"] = 6.2831854820251,
        ["LatLongAlt"] = {
            ["Long"] = 44.610958430042,
            ["Lat"] = 43.78698224608,
            ["Alt"] = 154.62580871582,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0,
    },
    [16779264] = {
        ["Pitch"] = -0.00032301872852258,
        ["Type"] = {
            ["level3"] = 25,
            ["level1"] = 2,
            ["level4"] = 71,
            ["level2"] = 17,
        },
        ["Country"] = 0,
        ["GroupName"] = "Mozdok Static #030",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = false,
            ["RadarActive"] = false,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 6.1610123515129,
        ["Name"] = "ZIL-4331",
        ["Position"] = {
            ["y"] = 154.64310570248,
            ["x"] = -83963.367187167,
            ["z"] = 834933.25000006,
        },
        ["UnitName"] = "static",
        ["LatLongAlt"] = {
            ["Long"] = 44.610690820785,
            ["Lat"] = 43.786595642818,
            ["Alt"] = 154.64310570248,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.0001018347684294,
    },
    [16779776] = {
        ["Pitch"] = 0,
        ["Type"] = {
            ["level3"] = 0,
            ["level1"] = 0,
            ["level4"] = 0,
            ["level2"] = 0,
        },
        ["Country"] = 0,
        ["Coalition"] = "Allies",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = true,
            ["Invisible"] = false,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = false,
        },
        ["Name"] = "m117_cargo",
        ["Position"] = {
            ["y"] = 154.62287902832,
            ["x"] = -83913.28125,
            ["z"] = 834974.125,
        },
        ["Heading"] = 6.2831854820251,
        ["LatLongAlt"] = {
            ["Long"] = 44.611275116765,
            ["Lat"] = 43.786986105711,
            ["Alt"] = 154.62287902832,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0,
    },
    [16780288] = {
        ["Pitch"] = 0.090722404420376,
        ["Type"] = {
            ["level3"] = 5,
            ["level1"] = 1,
            ["level4"] = 26,
            ["level2"] = 1,
        },
        ["Country"] = 0,
        ["GroupName"] = "AWACS",
        ["Flags"] = {
            ["Jamming"] = false,
            ["IRJamming"] = false,
            ["Born"] = true,
            ["Static"] = false,
            ["Invisible"] = true,
            ["Human"] = false,
            ["AI_ON"] = true,
            ["RadarActive"] = true,
        },
        ["Coalition"] = "Allies",
        ["Heading"] = 4.887811422348,
        ["Name"] = "A-50",
        ["Position"] = {
            ["y"] = 9143.6892455148,
            ["x"] = -112781.66441541,
            ["z"] = 887057.07160905,
        },
        ["UnitName"] = "Pilot #11",
        ["LatLongAlt"] = {
            ["Long"] = 45.192039914452,
            ["Lat"] = 43.465919137673,
            ["Alt"] = 9143.6892455148,
        },
        ["CoalitionID"] = 1,
        ["Bank"] = 0.00086569780251011,
    },
}
    [133] = "LoGetTrueAirSpeed",
    [134] = "select",
    [135] = "LoGetAircraftDrawArgumentValue",
    [136] = "LoGetSightingSystemInfo",
    [137] = "rawget",
    [138] = "LoIsOwnshipExportAllowed",
    [139] = "a_start_listen_command",
    [140] = "LoGetVectorVelocity",
    [141] = "setfenv",
    [142] = "LoGetNameByType",
    [143] = "GetDevice",
    [144] = "error",
    [145] = "LoGetAltitudeAboveGroundLevel",
}

Gui
{
    [1] = "lbNeutralKeyDown",
    [2] = "me_static",
    [3] = "wsTypeZIL135",
    [4] = "Avenger_",
    [5] = "wsType_GenericVehicle",
    [6] = "LAU_131x3_HYDRA_70_M274",
    [7] = "shell_ref",
    [8] = "cartridge_RESERVED_209",
    [9] = "Control_Containers",
    [10] = "main_w",
    [11] = "__DO_NOT_ERASE_DEBRIEF_LOG__",
    [12] = "USE_TERRAIN4",
    [13] = "LAU_131_HYDRA_70_M257",
    [14] = "wsTypeTrolebus",
    [15] = "collect_available_weapon_resources",
    [16] = "CBU_97",
    [17] = "SA9M82",
    [18] = "P_51D",
    [19] = "LAU_88_AGM_65H_2_R",
    [20] = "CurrentlyMergedPlugin",
    [21] = "filterByTasks",
    [22] = "KA_50",
    [23] = "onShowMainInterface",
    [24] = "insertRow",
    [25] = "Dzhankoy",
    [26] = "copy_table",
    [27] = "TU_22_RBK_250",
    [28] = "APU_R_60_2",
    [29] = "AGM_114K",
    [30] = "wsTypeTeplowoz",
    [31] = "moviesDir",
    [32] = "SU_34_FONAR_R",
    [33] = "XM_158_HYDRA_70_M156",
    [34] = "mbd3_two",
    [35] = "onNetMissionEnd",
    [36] = "BriefingDialog",
    [37] = "CAT_ADAPTER",
    [38] = "updateGrid",
    [39] = "Layout",
    [40] = "plane_file",
    [41] = "resource_by_unique_name",
    [42] = "wsType_Snare_Cont",
    [43] = "aircraft_gunpod",
    [44] = "bombs",
    [45] = "form_bomb",
    [46] = "TF_51D",
    [47] = "PTAB_2_5_DATA",
    [48] = "BORA",
    [49] = "FAB_500_3",
    [50] = "FAB_250P",
    [51] = "Kormoran",
    [52] = "setCoordPanel",
    [53] = "LAU_68_HYDRA_70_M257",
    [54] = "imagePreview",
    [55] = "me_autobriefing",
    [56] = "spot_lights_lockon",
    [57] = "F_16_PTB_N2",
    [58] = "Sea_Lynx",
    [59] = "pluginsEnabled",
    [60] = "P_37",
    [61] = "onPlayerTryChangeSlot",
    [62] = "get_weapon_and_count_from_launcher",
    [63] = "SA9M33",
    [64] = "cartridge_RESERVED_208",
    [65] = "tu_22_mbdz_full",
    [66] = "collectgarbage",
    [67] = "wsType_GenericInfantry",
    [68] = "Sky_Shadow",
    [69] = "Bkg",
    [70] = "KUB_1C91",
    [71] = "PERRY",
    [72] = "Maykop",
    [73] = "maverick_data",
    [74] = "me_quickstart",
    [75] = "LAU_105_1_AIM_9M_R",
    [76] = "panel_backup",
    [77] = "onShowChatAll",
    [78] = "me_encyclopedia",
    [79] = "V_40B6MD",
    [80] = "BEACON_TYPE_RSBN_",
    [81] = "CH_53E",
    [82] = "U",
    [83] = "MBD_3_CBU_97",
    [84] = "Strela_9K35",
    [85] = "CBU_103",
    [86] = "MER_6_2_PB_250",
    [87] = "C_8CM_GN",
    [88] = "CH_47D",
    [89] = "wsType_OBLOMOK_2",
    [90] = "updateCalibration",
    [91] = "NB_2",
    [92] = "_",
    [93] = "utils",
    [94] = "getCountryCoalitionNames",
    [95] = "BUK_PU",
    [96] = "wsType_Smoke_Cont",
    [97] = "MenuRadioItem",
    [98] = "P_60",
    [99] = "gcinfo",
    [100] = "onChange_btnToNeutral",
    [101] = "LAU_68_HYDRA_70_M156",
    [102] = "HorzScrollBar",
    [103] = "CoalitionLast",
    [104] = "simple_warhead",
    [105] = "R_85",
    [106] = "Mirage_FONAR",
    [107] = "AKU_58",
    [108] = "HumanTypeEnd",
    [109] = "fire_effect",
    [110] = "actions_toolbar_w",
    [111] = "OverlayWindow",
    [112] = "OSA_9A33BM3",
    [113] = "TGM_65D",
    [114] = "aim9_station",
    [115] = "GBU_29",
    [116] = "lau_3",
    [117] = "AWACS",
    [118] = "ScrollBar",
    [119] = "VertScrollBar",
    [120] = "guid",
    [121] = "ALQ_131",
    [122] = "loadPanels",
    [123] = "count",
    [124] = "add_single_attribute",
    [125] = "doZipFile",
    [126] = "wsType_Free_Fall",
    [127] = "OPTIC_SENSOR_IR",
    [128] = "MenuBar",
    [129] = "KMGU_2",
    [130] = "GAI",
    [131] = "MW_1",
    [132] = "AGM_130",
    [133] = "collect_unit_ws_types",
    [134] = "staticText",
    [135] = "MBD_4_FAB_250",
    [136] = "progressBar",
    [137] = "right_bottom_panel_height",
    [138] = "TOW",
    [139] = "APU_68_C_24",
    [140] = "sDisclaimer",
    [141] = "FULCRUM_INBOARD",
    [142] = "KAB_500",
    [143] = "DCSPresence",
    [144] = "srs_overlay",
    [145] = "FAB_500",
    [146] = "R_85U",
    [147] = "srs",
    [148] = "show",
    [149] = "getYears",
    [150] = "MER_L_P_60",
    [151] = "AGM_65D",
    [152] = "SU_24_FONAR_L",
    [153] = "Yak_40",
    [154] = "onWebServerRequest",
    [155] = "Gvardeyskoe",
    [156] = "onDynGroupCreated",
    [157] = "onPlayerTryConnect",
    [158] = "A_10A",
    [159] = "onServerRegistrationFail",
    [160] = "MOSCOW",
    [161] = "P_120",
    [162] = "onNetDisconnect",
    [163] = "Kirovskoe",
    [164] = "ammo_supply_mixed",
    [165] = "WSN_10",
    [166] = "showSplash",
    [167] = "ChangeDateBySeason",
    [168] = "me_suppliers",
    [169] = "showMissionResourcesDialog",
    [170] = "F_5_PTB",
    [171] = "findAttribute",
    [172] = "ModsShapeTableByShapeName",
    [173] = "SmokeGenerator_red",
    [174] = "onTriggerPicture",
    [175] = "next",
    [176] = "tu_22_m3_hatch",
    [177] = "MiG_29G",
    [178] = "mapInfoPanel",
    [179] = "getUnitIconByType",
    [180] = "panel_setImage",
    [181] = "traverseTable",
    [182] = "SA9M38M1",
    [183] = "wsTypeGAZ_3307",
    [184] = "Weapon_containers",
    [185] = "onUpdateScore",
    [186] = "MiG_29C_cells_properties",
    [187] = "onPlayerChangeSlot",
    [188] = "onPlayerStop",
    [189] = "damage_use_shield",
    [190] = "guiVariant",
    [191] = "onPlayerStart",
    [192] = "onPlayerDisconnect",
    [193] = "AGM_84E",
    [194] = "check_plugin_available",
    [195] = "Tunguska_",
    [196] = "onPlayerConnect",
    [197] = "smoke_generator_R73",
    [198] = "onShowGameInfo",
    [199] = "K36",
    [200] = "AGM_84S",
    [201] = "HYDRA_70_M257",
    [202] = "WSN_0",
    [203] = "top_toolbar_h",
    [204] = "onChatMessage",
    [205] = "spot_lights_default",
    [206] = "Tu_142",
    [207] = "ModuleLocker",
    [208] = "select",
    [209] = "Text",
    [210] = "onRadioCommand",
    [211] = "calcMw",
    [212] = "helicopter",
    [213] = "BuddyWindow",
    [214] = "rot_nil",
    [215] = "MiG_23_tbl",
    [216] = "Pods",
    [217] = "Beslan",
    [218] = "M60_side_gun",
    [219] = "Su_39",
    [220] = "MICA_T",
    [221] = "onShowScores",
    [222] = "onShowChat",
    [223] = "onShowBriefing",
    [224] = "AGM_154",
    [225] = "tostring",
    [226] = "X_35",
    [227] = "mmw",
    [228] = "watchTrackFileName",
    [229] = "X_58",
    [230] = "wsType_RW2",
    [231] = "LAU_88_AGM_65K",
    [232] = "onSimulationResume",
    [233] = "wsType_Hummer",
    [234] = "onNetConnect",
    [235] = "onSimulationStop",
    [236] = "onUserRequestMissionRestart",
    [237] = "X_23",
    [238] = "onSimulationPause",
    [239] = "AH_64A",
    [240] = "M134_SIDE_R",
    [241] = "MBD_2_67U_FAB_100",
    [242] = "onShowChatTeam",
    [243] = "updateVoicechat",
    [244] = "wsType_Bomb_Guided",
    [245] = "BUK_9C470M1",
    [246] = "SmokeGenerator_orange",
    [247] = "ALQ_184",
    [248] = "gameMessages",
    [249] = "P_27EM",
    [250] = "load",
    [251] = "me_staticTemplateSave",
    [252] = "F_2",
    [253] = "armour_canopy_cells_properties",
    [254] = "onTriggerMessage",
    [255] = "Lochini",
    [256] = "dxguiWin",
    [257] = "onShowMessage",
    [258] = "Vikhr_M",
    [259] = "me_ship",
    [260] = "GUV_YakB_GSHP",
    [261] = "onSimulationEsc",
    [262] = "onShowPool",
    [263] = "onGameBdaEvent",
    [264] = "MIG_25_PTB",
    [265] = "Octyabrskoe",
    [266] = "modulesInfo",
    [267] = "ASPECT_HEAD_ON",
    [268] = "MBD_6_B52",
    [269] = "wsType_Static",
    [270] = "wsRadarLongRange",
    [271] = "TU_22_FAB_250",
    [272] = "F_18_PTB",
    [273] = "HYDRA_70_M156",
    [274] = "pluginsById",
    [275] = "WOLALIGHT_FORMATION_LIGHTS",
    [276] = "loadstring",
    [277] = "damage_curvature",
    [278] = "onBdaSetModeWrite",
    [279] = "SmokeGenerator_yellow",
    [280] = "onBdaShowHide",
    [281] = "rotary_launcher",
    [282] = "P_35",
    [283] = "onBdaShowF10",
    [284] = "onChatShowHide",
    [285] = "dir_short_name",
    [286] = "LAU_131_HYDRA_70_M151",
    [287] = "LAU_131",
    [288] = "F_5_FONAR",
    [289] = "wsType_Bomb_Lighter",
    [290] = "wstype_aircrafts",
    [291] = "aiming_table",
    [292] = "LUU_2B",
    [293] = "me_openfile",
    [294] = "wsType_WingPart",
    [295] = "table",
    [296] = "onMissionLoadProgress",
    [297] = "AT_6_9M114",
    [298] = "onMissionLoadBegin",
    [299] = "P_98",
    [300] = "Panel",
    [301] = "isShowIntermission",
    [302] = "tu_22_mbdz_two",
    [303] = "RBK_500U",
    [304] = "SU_27_FONAR",
    [305] = "AKU_58_X_31P",
    [306] = "FIM_92C",
    [307] = "ipairs",
    [308] = "wsType_Airdrome",
    [309] = "me_selectUnit",
    [310] = "CheckListBoxItem",
    [311] = "isDisconnect",
    [312] = "LAU_88_AGM_65H_2_L",
    [313] = "Strela_9K31",
    [314] = "countCoalitions",
    [315] = "Tu_95",
    [316] = "AGM_84A",
    [317] = "X_22",
    [318] = "declare_gun_mount",
    [319] = "swap_slot",
    [320] = "MK_82AIR",
    [321] = "MissionGenerator",
    [322] = "minizip",
    [323] = "ComboBox",
    [324] = "heat_VEffect",
    [325] = "mul_controlRequest",
    [326] = "mul_bda",
    [327] = "SPS_141",
    [328] = "WOLALIGHT_STROBES",
    [329] = "MBD_3_FAB_250",
    [330] = "silentAutorizationSync",
    [331] = "forceServer",
    [332] = "MIM_104",
    [333] = "AO_2_5RT",
    [334] = "isDCM",
    [335] = "GROZNY",
    [336] = "onWindowFocused",
    [337] = "tempDataDir",
    [338] = "trimQuotes",
    [339] = "onChange_checkBox",
    [340] = "panelHidden",
    [341] = "onClose",
    [342] = "isCustomPreset",
    [343] = "spBox",
    [344] = "TER_3_BDU_33",
    [345] = "loadfile",
    [346] = "warheads",
    [347] = "Export",
    [348] = "wsType_AirCarrier",
    [349] = "sImageSkin",
    [350] = "torpedoes",
    [351] = "HAWK_RAKETA",
    [352] = "SA3M9M",
    [353] = "me_nodes_list_view",
    [354] = "X_25ML",
    [355] = "sImage",
    [356] = "AFAC",
    [357] = "mi28n_cells_properties",
    [358] = "loading",
    [359] = "C_8CM_RD",
    [360] = "loadScene",
    [361] = "BDU_50LD",
    [362] = "preview",
    [363] = "copy",
    [364] = "wsType_Rocket",
    [365] = "cloneItem",
    [366] = "PU_5P85D",
    [367] = "RADAR_SS",
    [368] = "MBD_A10_2_AIM_9",
    [369] = "BD4_pylons",
    [370] = "i18",
    [371] = "panel_modulesmanager",
    [372] = "oh58d_cells_properties",
    [373] = "y_",
    [374] = "w_",
    [375] = "BorderLayout",
    [376] = "add_attributes",
    [377] = "Anapa",
    [378] = "FA_18C",
    [379] = "get_aircraft_ammo_mass",
    [380] = "AN_AAS_38_FLIR",
    [381] = "OPTIC_SENSOR_LLTV",
    [382] = "RadioButton",
    [383] = "_G",
    [384] = "addYears",
    [385] = "EPHIR",
    [386] = "AKU_58_X_29T",
    [387] = "AGM_119",
    [388] = "skin",
    [389] = "Chart",
    [390] = "P_27T",
    [391] = "ModalWindow",
    [392] = "MBD_3_PB_250",
    [393] = "LAU_88_AGM_65K_2_RIGHT",
    [394] = "AN_AAQ_28_LITENING",
    [395] = "B_8V20A_OFP2",
    [396] = "right_bottom_panel_y",
    [397] = "right_panel_y",
    [398] = "i18n",
    [399] = "right_panel_x",
    [400] = "aircraftsFlyableByPluginId",
    [401] = "ED_FINAL_VERSION",
    [402] = "wsType_AS_TRAIN_Missile",
    [403] = "me_weather",
    [404] = "Kerch",
    [405] = "me_showId",
    [406] = "arg_ch_rng_y",
    [407] = "CheckListTreeMulty",
    [408] = "aircraftFlyableInPlugins",
    [409] = "TER_FREE",
    [410] = "Tskhakaya",
    [411] = "liveriesDir",
    [412] = "P_40R",
    [413] = "C_8CM_YE",
    [414] = "Su_24",
    [415] = "enableModules",
    [416] = "createListsUnitsPlugins",
    [417] = "backupTrackMission",
    [418] = "RBK_250S",
    [419] = "Patr_AN_MPQ_53_P",
    [420] = "F_5E",
    [421] = "unpack",
    [422] = "restartME",
    [423] = "isPlannerMission",
    [424] = "FULCRUM_OUTBOARD",
    [425] = "DISPENSER",
    [426] = "ROCKEYE",
    [427] = "RADAR_MULTIROLE",
    [428] = "AnchorLayout",
    [429] = "edSensoryxVRFree",
    [430] = "loadingFirstTime",
    [431] = "openReturnScreen",
    [432] = "loadout_R77",
    [433] = "C_17",
    [434] = "LAU_88_AGM_65K_2_LEFT",
    [435] = "prepareMissionPath",
    [436] = "LOOK_BAD",
    [437] = "panel_paramFM",
    [438] = "Input",
    [439] = "ka27_cells_properties",
    [440] = "actions_bar_h",
    [441] = "FAB_100P",
    [442] = "condition_bar_h",
    [443] = "MBD_F2_2_ROCKEYE",
    [444] = "MICA_R",
    [445] = "Su_25T",
    [446] = "Mk_50_Torpedo",
    [447] = "right_toolbar_h",
    [448] = "allToNeutral",
    [449] = "bottom_toolbar_h",
    [450] = "wsType_OBLOMOK_5",
    [451] = "ah1w_cells_properties",
    [452] = "FAB_250",
    [453] = "WSN_13",
    [454] = "tu_22_mbdz_element",
    [455] = "S_3A",
    [456] = "wsType_Shell_A",
    [457] = "AIM_120C",
    [458] = "me_db",
    [459] = "AIM_7",
    [460] = "missionDir",
    [461] = "HEMISPHERE_LOWER",
    [462] = "PU_5P85C",
    [463] = "GBU_31_V_3B",
    [464] = "mod_copy_paste",
    [465] = "rawget",
    [466] = "panel_startEditor",
    [467] = "penetrating_warhead",
    [468] = "MiG_29_tbl",
    [469] = "panel_training",
    [470] = "input",
    [471] = "gui_video_player",
    [472] = "tail_solid",
    [473] = "LAU_105_FREE",
    [474] = "GBU_24",
    [475] = "VideoPlayerWidget",
    [476] = "get_predefined_aircraft_gunpod",
    [477] = "me_training",
    [478] = "panel_template",
    [479] = "SmokeGeneratorAIM_orange",
    [480] = "AGM_114_Pilon",
    [481] = "templates_manager",
    [482] = "nodes_manager",
    [483] = "AH_1W",
    [484] = "register_targeting_data",
    [485] = "GDData",
    [486] = "wsRadarEngagement",
    [487] = "TabGroupItem",
    [488] = "LANTIRN_F14",
    [489] = "APU_170",
    [490] = "wsRadarActiveHoming",
    [491] = "mul_wait_query",
    [492] = "debug",
    [493] = "panel_quickstart",
    [494] = "MiG_31",
    [495] = "onShowBda",
    [496] = "wsType_Battleplane",
    [497] = "panel_auth",
    [498] = "BOZ_100",
    [499] = "BDU_56LGB",
    [500] = "getYearsLocal",
    [501] = "TU_22_RBK_500AO",
    [502] = "TER_LS",
    [503] = "ModsTexturePaths",
    [504] = "module_updater",
    [505] = "lau_88",
    [506] = "SA9M83",
    [507] = "wsType_Flare_YELLOW",
    [508] = "B_8V20A",
    [509] = "MGModule",
    [510] = "COMMAND_GROUND_POWER_ON_OFF",
    [511] = "Krasnodar_P",
    [512] = "KILO",
    [513] = "panel_enc",
    [514] = "Tu_141",
    [515] = "panel_openfile",
    [516] = "panel_debriefing",
    [517] = "mul_keys",
    [518] = "SUU_25_8_LUU_2",
    [519] = "RLS_5H63C",
    [520] = "panel_autobriefing",
    [521] = "BGM_109B",
    [522] = "Vaziani",
    [523] = "AddPostfixToCtrlIDs",
    [524] = "KC_135",
    [525] = "MODULATION_FM",
    [526] = "panel_briefing",
    [527] = "module_mission",
    [528] = "switchVRSceneToMain",
    [529] = "MBD_RBK_500AO",
    [530] = "wsTypeWGruz",
    [531] = "L_39ZA",
    [532] = "panel_weather",
    [533] = "panel_bullseye",
    [534] = "panel_static",
    [535] = "DebriefingEventsData",
    [536] = "declare_service_life_unit",
    [537] = "panel_nav_target_points",
    [538] = "COMMAND_REARM",
    [539] = "panel_fix_points",
    [540] = "panel_payload",
    [541] = "smoke_without_mass",
    [542] = "setMiniText",
    [543] = "wsType_SAM",
    [544] = "panel_loadout_vehicles",
    [545] = "panel_loadout",
    [546] = "ENGINE_MODE_MINIMAL",
    [547] = "MIG_29C_FONAR",
    [548] = "MBD_3_FAB_100",
    [549] = "P_27PE",
    [550] = "COMMAND_CHANGE_POWER_SOURCE",
    [551] = "AN_30M",
    [552] = "panel_actions",
    [553] = "CBU_52B",
    [554] = "P_27P",
    [555] = "Patr_KP",
    [556] = "CBU_89",
    [557] = "panel_route",
    [558] = "Terrain",
    [559] = "KP_54K6",
    [560] = "LAU_131x3_HYDRA_70_MK1",
    [561] = "GBU_17",
    [562] = "TU_22_BETAB_500SP",
    [563] = "_APP_VERSION",
    [564] = "LAU_131_HYDRA_70_MK5",
    [565] = "panel_targeting",
    [566] = "BetAB_150DS",
    [567] = "panel_triggered_actions",
    [568] = "panel_suppliers",
    [569] = "FLIR_POD",
    [570] = "panel_wagons",
    [571] = "CheckActivation",
    [572] = "Su_24MR",
    [573] = "panel_radio",
    [574] = "panel_summary",
    [575] = "MBD_3_GBU_16",
    [576] = "panel_vehicle",
    [577] = "PTB_3000",
    [578] = "me_wagons",
    [579] = "me_loadout_vehicles",
    [580] = "B_52_hatch",
    [581] = "calcIyz",
    [582] = "Refueling",
    [583] = "SmokeGeneratorAIM_blue",
    [584] = "pcall",
    [585] = "HE_penetrating_warhead",
    [586] = "toolbar",
    [587] = "MIG_29K",
    [588] = "me_db_api",
    [589] = "GUV_VOG",
    [590] = "terrain",
    [591] = "wsType_Bomb_Fire",
    [592] = "CBU_105",
    [593] = "menubar",
    [594] = "MBD_A10_2",
    [595] = "MapWindow",
    [596] = "__meta_namespace",
    [597] = "mech_timing",
    [598] = "getYearsLauncher",
    [599] = "getCoalitionCountryUser",
    [600] = "onShowGameMenu",
    [601] = "HelConst",
    [602] = "log",
    [603] = "MBD_FAB_100",
    [604] = "Patriot_",
    [605] = "startME",
    [606] = "onChange_bClose",
    [607] = "VoiceChat",
    [608] = "HEAT_DATA",
    [609] = "BOBRUISK",
    [610] = "SM_2",
    [611] = "DEBUG",
    [612] = "me_copy_paste",
    [613] = "FragmentLanding",
    [614] = "LUU_19",
    [615] = "DebriefingMissionData",
    [616] = "getfenv",
    [617] = "cartridge_RESERVED_213",
    [618] = "LUU_2BB",
    [619] = "debriefing",
    [620] = "me_action_edit_panel",
    [621] = "wsRadarOptical",
    [622] = "SENSOR_IRST",
    [623] = "onChange_btnToBlue",
    [624] = "C_8OM",
    [625] = "SmokeGenerator_white",
    [626] = "M134_R",
    [627] = "me_mapInfoPanel",
    [628] = "wsTypeWagonPass",
    [629] = "LANTIRN_F18",
    [630] = "SU_30_FONAR",
    [631] = "me_loadoututilsVehicles",
    [632] = "PILOT_F14_SEAT",
    [633] = "declare_cluster_nurs",
    [634] = "X_29L",
    [635] = "getCountriesByLA",
    [636] = "MiG_25P",
    [637] = "SMERCH_9M55F",
    [638] = "Krasnogvardeyskoye",
    [639] = "LAU_105_1_CATM_9M_L",
    [640] = "MenuSeparatorItem",
    [641] = "MER_TOW_4",
    [642] = "wsType_CivilShip",
    [643] = "loadTOW",
    [644] = "LAU_88_AGM_65D_ONE",
    [645] = "cartridge_RESERVED_207",
    [646] = "GBU_22",
    [647] = "saveToMission",
    [648] = "aircraft_gunpod_with_wstype",
    [649] = "me_trigrules",
    [650] = "wsType_Stryker",
    [651] = "OH_58_BRAUNING",
    [652] = "WSN_7",
    [653] = "findUnit",
    [654] = "Batumi",
    [655] = "X_29TE",
    [656] = "GBU_38",
    [657] = "GBU_15",
    [658] = "wsTypeLAZ_695",
    [659] = "M134_side_gun",
    [660] = "register_ship",
    [661] = "LAU_117_TGM_65D",
    [662] = "RBK_250",
    [663] = "me_backup",
    [664] = "SA9M31",
    [665] = "verbose_to_dmg_properties",
    [666] = "wsTypeMAZstol",
    [667] = "ComboList",
    [668] = "CheckListBox",
    [669] = "LAU_131_HYDRA_70_MK1",
    [670] = "MBD_PB_250",
    [671] = "me_predicates",
    [672] = "X_65",
    [673] = "FAB_5000",
    [674] = "mul_query",
    [675] = "SHPIL",
    [676] = "OREL",
    [677] = "me_bullseye",
    [678] = "wsTypeMAZkaraul",
    [679] = "require",
    [680] = "wsTypeUAZ469",
    [681] = "panel_action_condition",
    [682] = "BDU_50LGB",
    [683] = "M2000_PTB",
    [684] = "UB_32_1",
    [685] = "me_setImage",
    [686] = "AutoScrollText",
    [687] = "me_briefing",
    [688] = "EditBox",
    [689] = "me_action_condition",
    [690] = "me_requiredUnits",
    [691] = "rawequal",
    [692] = "wsTypeWCisternaBLUE",
    [693] = "MinVody",
    [694] = "cartridge_50cal",
    [695] = "newproxy",
    [696] = "XZAB_250",
    [697] = "ListBox",
    [698] = "me_parking",
    [699] = "me_nav_target_points",
    [700] = "me_fix_points",
    [701] = "CBU_87_CLUSTER_SCHEME_DATA",
    [702] = "B_8M1_OFP2",
    [703] = "Simpheropol",
    [704] = "me_wpt_properties",
    [705] = "SU_25_FONAR",
    [706] = "multyRangeSpinBox",
    [707] = "me_panelRadio",
    [708] = "wsType_Ship",
    [709] = "panel_aircraft",
    [710] = "wing_engine_cells_properties",
    [711] = "wsType_Jam_Cont",
    [712] = "new",
    [713] = "Bomb_Other",
    [714] = "P_9M117",
    [715] = "me_beaconsInfo",
    [716] = "P_51B",
    [717] = "onChange_listBoxNeutral",
    [718] = "BDU_33",
    [719] = "me_changingCoalitions",
    [720] = "EWR_1L13",
    [721] = "me_setCoordPanel",
    [722] = "me_staticTemplateLoad",
    [723] = "me_staticTemplate",
    [724] = "setfenv",
    [725] = "getListLA",
    [726] = "me_summary",
    [727] = "LAU_117_CATM_65K",
    [728] = "getDefaultRadioFor",
    [729] = "LAU_117_TGM_65H",
    [730] = "S_25_C",
    [731] = "Roland_Search_Radar",
    [732] = "getMeSettings",
    [733] = "wsType_Ground",
    [734] = "updateStartEnabled",
    [735] = "reset",
    [736] = "Kopyo",
    [737] = "GSHG_7_62_heat_desc",
    [738] = "HYDRA_70",
    [739] = "WSN_4",
    [740] = "initPlaceOptions",
    [741] = "endGenerate",
    [742] = "wsType_Container",
    [743] = "IglaRUS_2",
    [744] = "C_24",
    [745] = "hasAttributes",
    [746] = "me_simple_generator_dialog",
    [747] = "pairs",
    [748] = "me_logbook",
    [749] = "wsType_S_Torpedo",
    [750] = "mul_IntegrityCheck",
    [751] = "mul_listIntegrityCheck",
    [752] = "WOLALIGHT_REFUEL_LIGHTS",
    [753] = "mul_password",
    [754] = "me_goal",
    [755] = "F4_PTB_FUZ",
    [756] = "Size",
    [757] = "initTer",
    [758] = "FONAR_OTK",
    [759] = "panel_draw",
    [760] = "mul_nickname",
    [761] = "ToggleButton",
    [762] = "socket",
    [763] = "presetsHandling",
    [764] = "Hawk_CV",
    [765] = "me_targeting",
    [766] = "FindCtrlEntry",
    [767] = "gui_axes_tune",
    [768] = "AxesTuneWidget",
    [769] = "wsType_OBLOMOK_6",
    [770] = "setProfileForceFeedbackSettings",
    [771] = "onShowRadioMenu",
    [772] = "Skin",
    [773] = "MsgWindow",
    [774] = "X_25MR",
    [775] = "coroutine",
    [776] = "RangeIndicator",
    [777] = "HorzRangeIndicator",
    [778] = "move_separated_data_to_obj_table",
    [779] = "ChoiceOfCoalitionDialog",
    [780] = "hide",
    [781] = "MenuSubItem",
    [782] = "arg_ch_rng",
    [783] = "ChoiceOfRoleDialog",
    [784] = "MBD_F2_2_Puma",
    [785] = "START_PARAMS",
    [786] = "Kutaisi",
    [787] = "typical_single_engined_fighter",
    [788] = "CAT_AIR_TO_AIR",
    [789] = "advGrid",
    [790] = "mul_unbanned",
    [791] = "mul_banned",
    [792] = "mbd3_u6_element",
    [793] = "TOW2",
    [794] = "string",
    [795] = "CAT_FUEL_TANKS",
    [796] = "mul_kick",
    [797] = "KC_135_cells_properties",
    [798] = "SA48H6E2",
    [799] = "skill",
    [800] = "M26",
    [801] = "mul_chat",
    [802] = "i_18n",
    [803] = "HYDRA_70_MK5",
    [804] = "fixUnit",
    [805] = "me_generator_dialog_data",
    [806] = "mul_select_role",
    [807] = "_ARCHITECTURE",
    [808] = "me_utilities",
    [809] = "su25t_cells_properties",
    [810] = "ka50_cells_properties",
    [811] = "GBU_28",
    [812] = "AGM_65K",
    [813] = "reg",
    [814] = "me_modulesmanager",
    [815] = "__MAC__",
    [816] = "onNetMissionChanged",
    [817] = "FA_18",
    [818] = "onRadioMessage",
    [819] = "WOLALIGHT_IR_FORMATION",
    [820] = "BD3_",
    [821] = "FileDialogFilters",
    [822] = "FileDialogUtils",
    [823] = "FIXED_WING",
    [824] = "LAU_68x3_HYDRA_70_M274",
    [825] = "getTerrainConfigPath",
    [826] = "SelectFileBar",
    [827] = "FileGrid",
    [828] = "MiG_25",
    [829] = "FileDialog",
    [830] = "ECM",
    [831] = "MK_82SNAKEYE",
    [832] = "F_18C_FONAR",
    [833] = "AGM_62",
    [834] = "wstype_bombs",
    [835] = "Cluster_MLRS_DATA",
    [836] = "registerResourceName",
    [837] = "plugins_to_load",
    [838] = "ED_demosceneAPI",
    [839] = "drawarg",
    [840] = "LAU_131_HYDRA_70_M274",
    [841] = "_WEAPON_",
    [842] = "me_updater",
    [843] = "MBD_3_FAB_500",
    [844] = "mi24v_cells_properties",
    [845] = "wsType_ArmedShip",
    [846] = "SU_17M4",
    [847] = "LastShipType",
    [848] = "CATM_9",
    [849] = "me_authorization",
    [850] = "LAU_88_AGM_65H_3",
    [851] = "me_news",
    [852] = "plPanel",
    [853] = "SEAD",
    [854] = "onChange_listBoxBlue",
    [855] = "MainMenuForm",
    [856] = "Slider",
    [857] = "HorzSlider",
    [858] = "MainMenu",
    [859] = "wsType_Tank",
    [860] = "ENGINE_MODE_MAXIMAL",
    [861] = "gui_nodes_map",
    [862] = "LAU_68_HYDRA_70_MK1",
    [863] = "wsType_Heliport",
    [864] = "wsTypeURAL_4320T",
    [865] = "LUU_1",
    [866] = "me_roles",
    [867] = "MenuBarItem",
    [868] = "KAB_1500Kr",
    [869] = "LAU_131x3_HYDRA_70_M151",
    [870] = "weapons_table",
    [871] = "wsType_Torpedo",
    [872] = "switchVRSceneToEncyclopedia",
    [873] = "me_menubar",
    [874] = "getCurLang",
    [875] = "OH_58D",
    [876] = "global_attributes_list",
    [877] = "Novorossiysk",
    [878] = "BDU_56LD",
    [879] = "setCurLang",
    [880] = "wsType_A_Torpedo",
    [881] = "MER_L_P_60_2",
    [882] = "generateLow",
    [883] = "LAU_88_AGM_65E",
    [884] = "ColorTextStatic",
    [885] = "wsType_Weapon",
    [886] = "F_16",
    [887] = "me_loadoututils",
    [888] = "check_crew_roles",
    [889] = "hideWindow",
    [890] = "formation_lights_default",
    [891] = "tips_lights_default",
    [892] = "CreateSpinbox",
    [893] = "Khersones",
    [894] = "wsTypeMAZelektro",
    [895] = "APU_68",
    [896] = "Grid",
    [897] = "spinGrid",
    [898] = "GridHeaderCell",
    [899] = "PKT_side_gun",
    [900] = "me_manager_resource",
    [901] = "MER_9_B52",
    [902] = "startWait",
    [903] = "loadLiveries",
    [904] = "gui_demoscene",
    [905] = "DemoSceneWidget",
    [906] = "LAU_131_HYDRA_70_MK61",
    [907] = "LAU_68_HYDRA_70_M278",
    [908] = "AKU_58_X_29L",
    [909] = "AGM_114_Pilon_4",
    [910] = "getColumnHeaderSkin",
    [911] = "element",
    [912] = "onMisGenEvent",
    [913] = "MenuCheckItem",
    [914] = "ModsWeaponNames",
    [915] = "MenuItem",
    [916] = "wsType_GenericAAA",
    [917] = "me_loadout",
    [918] = "wsTypeTMZ5",
    [919] = "me_payload",
    [920] = "FULCRUM_S_TIPS",
    [921] = "WSN_8",
    [922] = "copy_RCS",
    [923] = "me_aircraft",
    [924] = "guiBindPath",
    [925] = "COMMAND_CHANGE_PILOT_EQUIPMENT",
    [926] = "PB_250",
    [927] = "me_triggered_actions",
    [928] = "AKU_58_X_35",
    [929] = "GroupVariant",
    [930] = "TANGO",
    [931] = "me_action_map_objects",
    [932] = "planes_dmg_properties",
    [933] = "Gelendzhik",
    [934] = "wsType_Submarine",
    [935] = "RLS_9C32_1",
    [936] = "PredefinedFuzeGUISettings",
    [937] = "ScrollPane",
    [938] = "TU_22_RBK_500SOAB",
    [939] = "AIM_54",
    [940] = "wsType_Radar_Gun",
    [941] = "onChange_btnToRed",
    [942] = "updateEnabledOk",
    [943] = "right_toolbar_width",
    [944] = "Igla_1E",
    [945] = "wsType_GenericIFV",
    [946] = "LAU_68_HYDRA_70_MK61",
    [947] = "onChange_listBoxRed",
    [948] = "LAU_88_AGM_65E_2_LEFT",
    [949] = "ModsModelPaths",
    [950] = "WOLALIGHT_TIPS_LIGHTS",
    [951] = "LAU_117_TGM_65G",
    [952] = "TU_22_ODAB",
    [953] = "wsType_Radar_MissGun",
    [954] = "onChange_Ok",
    [955] = "lbBlueKeyDown",
    [956] = "lbRedKeyDown",
    [957] = "FAB_1000",
    [958] = "AGM_123",
    [959] = "MIG_31_FONAR_Z",
    [960] = "panel_payload_vehicles",
    [961] = "SU_17_FONAR",
    [962] = "showMini",
    [963] = "wsType_SmallBomb",
    [964] = "onRefuelEvent",
    [965] = "MBD_FAB_500",
    [966] = "P_4R",
    [967] = "HYDRA_70_MK1",
    [968] = "wsType_Bomb_Nuclear",
    [969] = "addYearsLaunchers",
    [970] = "me_template",
    [971] = "default_cells_properties",
    [972] = "me_debriefing",
    [973] = "me_actions_listbox",
    [974] = "damage_use_new_damage",
    [975] = "PTB_1500",
    [976] = "TU_22_BETAB_500",
    [977] = "CheckBox",
    [978] = "updateMapObjects",
    [979] = "MER_9_B52_Mk_84",
    [980] = "TU_22_MBD",
    [981] = "updateUnitSystem",
    [982] = "error",
    [983] = "Button",
    [984] = "me_action_db",
    [985] = "safe_require",
    [986] = "plugins_by_id",
    [987] = "autobriefingutils",
    [988] = "Super_530D",
    [989] = "LAU_68x3_HYDRA_70_MK1",
    [990] = "AGM_65H",
    [991] = "HYDRA_70_M151",
    [992] = "me_toolbar",
    [993] = "MBD_3_Rockeye",
    [994] = "wsType_Bomb_Cluster",
    [995] = "ENGINE_MODE_FORSAGE",
    [996] = "controlRequest",
    [997] = "me_templates_manager",
    [998] = "PARACHUTE_ON_GROUND",
    [999] = "wsTypeGAZ_3308",
    [1000] = "Hawk_CWAR_Radar",
    [1001] = "GuiWin",
    [1002] = "MI_28N",
    [1003] = "mul_swap_slot",
    [1004] = "me_tabs",
    [1005] = "A_10C",
    [1006] = "Kobuleti",
    [1007] = "tonumber",
    [1008] = "SAB_100",
    [1009] = "me_nodes_manager",
    [1010] = "me_payload_vehicles",
    [1011] = "wsType_Flare_RED",
    [1012] = "NewMapState",
    [1013] = "AT_9M120M",
    [1014] = "Saki",
    [1015] = "mi26_cells_properties",
    [1016] = "script_path",
    [1017] = "C_130",
    [1018] = "MapColor",
    [1019] = "OPTIC_SENSOR_TV",
    [1020] = "MBD_3_RBK_500AO",
    [1021] = "me_mission",
    [1022] = "AIM_9X",
    [1023] = "me_infoPlugin",
    [1024] = "GameInfo",
    [1025] = "me_music",
    [1026] = "dbtype",
    [1027] = "APU_68_X_25MR",
    [1028] = "db",
    [1029] = "FAB_100",
    [1030] = "wsType_F_Bomber",
    [1031] = "ProgressBar",
    [1032] = "HorzProgressBar",
    [1033] = "P_24R",
    [1034] = "wsType_GenericFort",
    [1035] = "TextUtil",
    [1036] = "Align",
    [1037] = "Window",
    [1038] = "MPS_410",
    [1039] = "StartProgressBar",
    [1040] = "optionsModsScripts",
    [1041] = "MIG_23_FONAR",
    [1042] = "Vikhr",
    [1043] = "TGM_65H",
    [1044] = "onShowIntermission",
    [1045] = "LUU_2AB",
    [1046] = "CAT_SHELLS",
    [1047] = "edLeapMotion",
    [1048] = "SU_25T_FONAR",
    [1049] = "planes_dmg_parts",
    [1050] = "updateSensors",
    [1051] = "checkingSensors",
    [1052] = "MER_6_4_FAB_250",
    [1053] = "PTB_2000",
    [1054] = "wsType_Moving",
    [1055] = "CAT_GUN_MOUNT",
    [1056] = "wsType_Air",
    [1057] = "Su_27",
    [1058] = "wsType_AA_Missile",
    [1059] = "wsType_Snars",
    [1060] = "MBD_Rockeye",
    [1061] = "copy_display_name",
    [1062] = "Reconnaissance",
    [1063] = "CreateStandardFuzeSelectionCtrl",
    [1064] = "RPC",
    [1065] = "modulelocation",
    [1066] = "onGameEvent",
    [1067] = "GRASSAIRFIELD_data",
    [1068] = "FARP_data",
    [1069] = "Objects",
    [1070] = "custom_input_profiles",
    [1071] = "FormLayout",
    [1072] = "IglaGRG_1",
    [1073] = "MBD_3_ZAB",
    [1074] = "wstype_technics",
    [1075] = "LAU_131_HYDRA_70_M278",
    [1076] = "res",
    [1077] = "wstype_ships",
    [1078] = "dxgui",
    [1079] = "MBD_ZAB",
    [1080] = "length",
    [1081] = "curPluginLoaderType",
    [1082] = "enhanced_a2a_warhead",
    [1083] = "curPluginLoaderInfo",
    [1084] = "current_mod_path",
    [1085] = "envTable_",
    [1086] = "SU_33_FONAR",
    [1087] = "PKT_7_62",
    [1088] = "Zuni_127CM",
    [1089] = "ModsShapeTable",
    [1090] = "math",
    [1091] = "Whiskey_Pete",
    [1092] = "wsTypeKAMAZ_Tent",
    [1093] = "F_16_PTB_N1",
    [1094] = "M134_L",
    [1095] = "LAU_105_1_AIM_9M_L",
    [1096] = "theatres",
    [1097] = "me_route",
    [1098] = "plugins_ordered",
    [1099] = "wsType_Airplane",
    [1100] = "calcCy",
    [1101] = "plugins",
    [1102] = "messagesHistory",
    [1103] = "PAVETACK",
    [1104] = "P_40T",
    [1105] = "Cluster",
    [1106] = "Durandal",
    [1107] = "dbYearsLaunchers",
    [1108] = "LAU_10",
    [1109] = "LAU_68x3_HYDRA_70_M257",
    [1110] = "langPanel",
    [1111] = "panel_ship",
    [1112] = "SKORY",
    [1113] = "register_targeting_pod",
    [1114] = "onShowResources",
    [1115] = "AGM_45",
    [1116] = "wsType_GenericMLRS",
    [1117] = "SmokeGenerator_blue",
    [1118] = "IRCM",
    [1119] = "MER_12_B52",
    [1120] = "M6Linebacker",
    [1121] = "register_sensor",
    [1122] = "UB_13",
    [1123] = "hasAttribute",
    [1124] = "panel_news",
    [1125] = "Hawk_",
    [1126] = "tempCampaignPath",
    [1127] = "P_700",
    [1128] = "GBU_27",
    [1129] = "PTB_1150",
    [1130] = "PTB_S_3",
    [1131] = "CBU_87",
    [1132] = "SeaSparrow",
    [1133] = "ASPECT_TAIL_ON",
    [1134] = "get_weapon_display_name_by_wstype",
    [1135] = "AKU_58_X_58",
    [1136] = "HEMISPHERE_UPPER",
    [1137] = "value2code",
    [1138] = "AT_9M120",
    [1139] = "setPlannerMission",
    [1140] = "default_lights_plane",
    [1141] = "GRAD_9M22U",
    [1142] = "module",
    [1143] = "wsTypeWCisternaYELLOW",
    [1144] = "x_",
    [1145] = "P_500",
    [1146] = "RADAR_AS",
    [1147] = "C_5",
    [1148] = "wsType_Cruiser",
    [1149] = "B_1",
    [1150] = "IndividualFuzeGUISettings",
    [1151] = "MER_9_B52_Rockeye",
    [1152] = "CAT_PODS",
    [1153] = "F_15_cells_properties",
    [1154] = "CAT_SERVICE",
    [1155] = "rotz",
    [1156] = "me_rts_map_view",
    [1157] = "X_41",
    [1158] = "SENSOR_OPTICAL",
    [1159] = "unit_aliases",
    [1160] = "h_",
    [1161] = "LAU_131WP",
    [1162] = "_current_mission",
    [1163] = "me_modulesOffers",
    [1164] = "wsType_GenericCivShip",
    [1165] = "wsRadarShrtRange",
    [1166] = "getCurLangForLoad",
    [1167] = "MBD_2_67U",
    [1168] = "wsType_NURS",
    [1169] = "MBD_4",
    [1170] = "TU_22_FAB_500",
    [1171] = "LAU_88",
    [1172] = "Nalchick",
    [1173] = "FA_18_tbl",
    [1174] = "SU_24_FONAR_R",
    [1175] = "MiG_29C",
    [1176] = "xpcall",
    [1177] = "GBU_31",
    [1178] = "P_9M133",
    [1179] = "def_mg_LN",
    [1180] = "_VERSION",
    [1181] = "damage_max_distance",
    [1182] = "WSN_00",
    [1183] = "mul_voicechat",
    [1184] = "calcS",
    [1185] = "HYDRA_70_WTU1B",
    [1186] = "WSN_6",
    [1187] = "wsType_Miss",
    [1188] = "WSN_11",
    [1189] = "fillTasksCombobox",
    [1190] = "WSN_3",
    [1191] = "WSN_2",
    [1192] = "WSN_1",
    [1193] = "BarrelsReloadTypes",
    [1194] = "DialogLoader",
    [1195] = "mul_server_list",
    [1196] = "plane",
    [1197] = "LAU_68_HYDRA_70_WTU1B",
    [1198] = "heli_file",
    [1199] = "FULCRUM_S_INBOARD",
    [1200] = "FULCRUM_S_OUTBOARD",
    [1201] = "FULCRUM_CENTRAL_STATION",
    [1202] = "A_50",
    [1203] = "Mk_81",
    [1204] = "ALBATROS",
    [1205] = "test_topdown_view_models",
    [1206] = "PTAB_10_5_DATA",
    [1207] = "SH_3H",
    [1208] = "MissionResourcesDialog",
    [1209] = "nav_lights_3arg",
    [1210] = "FULCRUM_MERGE_STATION",
    [1211] = "FULCRUM_TIPS",
    [1212] = "FULCRUM_STATION",
    [1213] = "APU_73",
    [1214] = "OBLOMOK_OBSHIWKI_2",
    [1215] = "nav_lights_default",
    [1216] = "Gun__1",
    [1217] = "pl_cat",
    [1218] = "F_16A",
    [1219] = "aircraft_task",
    [1220] = "make_payload_rules_list",
    [1221] = "rts",
    [1222] = "AGM_114K_Pilon_4",
    [1223] = "fill_mechanimation",
    [1224] = "MBD_3_MK_82",
    [1225] = "SA5B27",
    [1226] = "MIG_29K_FONAR",
    [1227] = "SmokeGeneratorAIM_yellow",
    [1228] = "NewMapView",
    [1229] = "RunwayAttack",
    [1230] = "MBD_3_ODAB",
    [1231] = "Rect",
    [1232] = "wsType_Fighter",
    [1233] = "gatling_effect",
    [1234] = "X_15",
    [1235] = "Intercept",
    [1236] = "GroundAttack",
    [1237] = "shell",
    [1238] = "FighterSweep",
    [1239] = "F4_PTB_WING",
    [1240] = "Su_30",
    [1241] = "MK118_DATA",
    [1242] = "me_ProductType",
    [1243] = "tactical_munition_dispenser_10",
    [1244] = "CAP",
    [1245] = "CAS",
    [1246] = "X_29T",
    [1247] = "ZU_23",
    [1248] = "uv_lights_default",
    [1249] = "AntishipStrike",
    [1250] = "Nothing",
    [1251] = "registerTask",
    [1252] = "main_h",
    [1253] = "collect_available_weapon_resources_wstype",
    [1254] = "Mirage",
    [1255] = "StingerUSA_2",
    [1256] = "C_25",
    [1257] = "create_names",
    [1258] = "get_weapon_display_name_by_clsid",
    [1259] = "assert",
    [1260] = "M48_Chaparral",
    [1261] = "S_25_PU",
    [1262] = "CHECK_LOADOUT_CLSID_UNIQUE",
    [1263] = "T_Tail_cells_properties",
    [1264] = "S300V_9A83",
    [1265] = "Tu_160",
    [1266] = "openReturnScreenMAC",
    [1267] = "HORNET_FUEL_TANK",
    [1268] = "Hawk_Track_Radar",
    [1269] = "Gui",
    [1270] = "wsTypeZIL_131_KUNG",
    [1271] = "LAU_117_AGM_65K",
    [1272] = "AN_M64",
    [1273] = "LUU_6",
    [1274] = "wsType_Flare_GREEN",
    [1275] = "Gepard_",
    [1276] = "showId",
    [1277] = "LAU_68",
    [1278] = "Zuni_127",
    [1279] = "onShowTraining",
    [1280] = "Escort",
    [1281] = "makeAirplaneCanopyGeometry",
    [1282] = "LAU_68x3_HYDRA_70_WTU1B",
    [1283] = "B_52",
    [1284] = "wstype_containers",
    [1285] = "C_13",
    [1286] = "wsType_SA_Missile",
    [1287] = "conventional_bomb_module_28",
    [1288] = "bombs_in_hatch_block",
    [1289] = "CBU_104",
    [1290] = "mbd3_four",
    [1291] = "req_launcher",
    [1292] = "mbd3_full",
    [1293] = "onSimulationFrame",
    [1294] = "LAU_131x3_HYDRA_70_WTU1B",
    [1295] = "tu_22_mbdz_four",
    [1296] = "E_3",
    [1297] = "me_campaign_editor",
    [1298] = "MER_6_AGM_86C",
    [1299] = "smokewinder",
    [1300] = "ammo_supply_dual",
    [1301] = "SKY_SHADOW",
    [1302] = "LAU_131_HYDRA_70_WTU1B",
    [1303] = "optionsEditor",
    [1304] = "R_550",
    [1305] = "merge_all_units_to_AGGRESSORS",
    [1306] = "E_2C_cells_properties",
    [1307] = "troopsPath",
    [1308] = "coalition",
    [1309] = "MaintenanceDuration",
    [1310] = "panel_roles",
    [1311] = "AMETYST",
    [1312] = "wsTypeWagonPlatforma",
    [1313] = "GetFullTableSize",
    [1314] = "Heliport_standart",
    [1315] = "WOLALIGHT_TAXI_LIGHTS",
    [1316] = "Su_25_tbl",
    [1317] = "LAU_117_AGM_65D",
    [1318] = "NodesMap",
    [1319] = "RLO_64H6E",
    [1320] = "DROP_TANK_75GAL",
    [1321] = "declare_bomb",
    [1322] = "BD3_pylons",
    [1323] = "COMMAND_VOID",
    [1324] = "GetConflagrationTime",
    [1325] = "wsType_HCarrier",
    [1326] = "Belbek",
    [1327] = "SAV611",
    [1328] = "RBK_500SOAB",
    [1329] = "me_langPanel",
    [1330] = "uh60a_cells_properties",
    [1331] = "MBD_4_FAB_100",
    [1332] = "onReloadEvent",
    [1333] = "Razdolnoe",
    [1334] = "wsType_Point",
    [1335] = "RandomMissionEvents",
    [1336] = "lights_prototypes",
    [1337] = "MER_9_B52_CBU_97",
    [1338] = "default_lights_helicopter",
    [1339] = "onPlayerTrySendChat",
    [1340] = "lamp_prototypes",
    [1341] = "createProgressBar",
    [1342] = "strobe_lights_default",
    [1343] = "MIG_25_FONAR",
    [1344] = "absolutPath",
    [1345] = "FULCRUM_AG_WEAPON",
    [1346] = "SpotLigtPositions",
    [1347] = "panel_manager_resource",
    [1348] = "APU_6_VICHR_M",
    [1349] = "LOOK_AVERAGE",
    [1350] = "MBD_BetAB_250_2",
    [1351] = "WOLALIGHT_PROJECTORS",
    [1352] = "WOLALIGHT_CABIN_NIGHT",
    [1353] = "IglaINS_1",
    [1354] = "wsType_Radar",
    [1355] = "Radar_Dog_Ear",
    [1356] = "MER_2_F_18",
    [1357] = "WOLALIGHT_CABIN_BOARDING",
    [1358] = "WOLALIGHT_BEACONS",
    [1359] = "onBdaSetModeRead",
    [1360] = "P_27AE",
    [1361] = "MIG_31_FONAR_P",
    [1362] = "VARIABLE_GEOMETRY",
    [1363] = "WOLALIGHT_NAVLIGHTS",
    [1364] = "XM_158_HYDRA_70_M151",
    [1365] = "cartridge_RESERVED_212",
    [1366] = "WOLALIGHT_LANDING_LIGHTS",
    [1367] = "LAU_68x3_HYDRA_70_MK5",
    [1368] = "APU_73_P_73",
    [1369] = "userThemeDir",
    [1370] = "WOLALIGHT_SPOTS",
    [1371] = "Tu_143",
    [1372] = "KA_27",
    [1373] = "AGM_88",
    [1374] = "FuzeGUISettingsPresets",
    [1375] = "exhaust_data",
    [1376] = "SpinBox",
    [1377] = "SVIR",
    [1378] = "make_default_mech_animation",
    [1379] = "PILOT_PARASHUT_US",
    [1380] = "KA_52",
    [1381] = "TU_22_PB_250",
    [1382] = "MissionDate",
    [1383] = "IglaRUS_1",
    [1384] = "panel_logbook",
    [1385] = "CAT_BOMBS",
    [1386] = "wsRadarMidRange",
    [1387] = "SmokeGeneratorAIM_green",
    [1388] = "Su_24_tbl",
    [1389] = "wsType_Destroyed",
    [1390] = "P_27TE",
    [1391] = "Su_27_tbl",
    [1392] = "AIPlanesControl",
    [1393] = "checkingCalibration",
    [1394] = "me_action_param_panels",
    [1395] = "B_8V20A_WP",
    [1396] = "wsTypeRLS37",
    [1397] = "GBU_12",
    [1398] = "mul_create_server",
    [1399] = "right_panel_height",
    [1400] = "Serializer",
    [1401] = "wsType_GContainer",
    [1402] = "OptionsData",
    [1403] = "declare_nurs",
    [1404] = "WSN_5",
    [1405] = "ab212_cells_properties",
    [1406] = "left_toolbar_w",
    [1407] = "me_map_window",
    [1408] = "MiG_29_cells_properties",
    [1409] = "Su_33_cells_properties",
    [1410] = "MBD_3_MK_81",
    [1411] = "MODULATION_AM",
    [1412] = "wsTypeFromString",
    [1413] = "S_25L_AND_PU",
    [1414] = "YakB_12_7_heat_desc",
    [1415] = "IL_76_cells_properties",
    [1416] = "mul_playersPool",
    [1417] = "country",
    [1418] = "SA3_TR",
    [1419] = "KONKURS",
    [1420] = "AN_26B_cells_properties",
    [1421] = "p51d_cells_properties",
    [1422] = "Shturm_9K114",
    [1423] = "_CheckActivation",
    [1424] = "loadout_APU_170_R77",
    [1425] = "me_editorManager",
    [1426] = "ch47d_cells_properties",
    [1427] = "me_spin_wpt",
    [1428] = "roty",
    [1429] = "TbilisiMilitary",
    [1430] = "ZU_23_OKOP",
    [1431] = "PILOT_DEAD",
    [1432] = "Default",
    [1433] = "utils_common",
    [1434] = "LOOK_AVERAGE_UH",
    [1435] = "SA9M333",
    [1436] = "update",
    [1437] = "P_77",
    [1438] = "Analytics",
    [1439] = "MER_AIM_9_2",
    [1440] = "wsType_Intruder",
    [1441] = "WSN_12",
    [1442] = "SFM_Data",
    [1443] = "LOOK_EXELLENT_B17",
    [1444] = "F_117",
    [1445] = "generateResourceName",
    [1446] = "PTB_1150_29",
    [1447] = "M60_SIDE_R",
    [1448] = "setmetatable",
    [1449] = "V_40B6M",
    [1450] = "PlaneConst",
    [1451] = "M_117",
    [1452] = "wsType_AirdromePart",
    [1453] = "FAB_500P",
    [1454] = "CAT_MISSILES",
    [1455] = "VARIABLE_GEOMETRY_FOLDED",
    [1456] = "FOLDED_WING",
    [1457] = "declare_torpedo",
    [1458] = "wsType_Gun",
    [1459] = "Sochi",
    [1460] = "getmetatable",
    [1461] = "SENSOR_RWR",
    [1462] = "Dial",
    [1463] = "SwitchButton",
    [1464] = "REG_LOADOUT_BY_CLSID",
    [1465] = "wsType_SS_Missile",
    [1466] = "WSN_9",
    [1467] = "rawset",
    [1468] = "LAU_131x3_HYDRA_70_MK61",
    [1469] = "F_15E",
    [1470] = "M134_SIDE_L",
    [1471] = "ModifyVisibilityCondition",
    [1472] = "Gun__",
    [1473] = "MBD_3",
    [1474] = "AddVisibilityCondition",
    [1475] = "MakeTableCopy",
    [1476] = "MIG_29G_FONAR",
    [1477] = "MAX_TEXTURE_SIZE",
    [1478] = "GenericLblData",
    [1479] = "Airdrome_0",
    [1480] = "TORNADO_IDS",
    [1481] = "MBD_F2_2_ALARM",
    [1482] = "wsType_OBLOMOK_4",
    [1483] = "S300V_9A82",
    [1484] = "M261_HYDRA_70_M151",
    [1485] = "prbCoeff",
    [1486] = "isInitTerrain",
    [1487] = "GameMenu",
    [1488] = "onMessageBox",
    [1489] = "dofile",
    [1490] = "wsType_Standing",
    [1491] = "MER_12_B52_M_117",
    [1492] = "register_adapter",
    [1493] = "wsType_Parts",
    [1494] = "me_failures",
    [1495] = "MiG_29",
    [1496] = "antiship_penetrating_warhead",
    [1497] = "simple_aa_warhead",
    [1498] = "Tu_22M3",
    [1499] = "IglaGRG_2",
    [1500] = "effects",
    [1501] = "XM_158_HYDRA_70_MK5",
    [1502] = "EWR_55G6",
    [1503] = "CBU97_CLUSTER_SCHEME_DATA",
    [1504] = "os",
    [1505] = "AV_8B",
    [1506] = "declare_missile",
    [1507] = "Krasnodar",
    [1508] = "KAB_500Kr",
    [1509] = "form_missile",
    [1510] = "wstype_SAMS",
    [1511] = "tbl2",
    [1512] = "wsRadarEWS",
    [1513] = "BetAB_250",
    [1514] = "me_units_list",
    [1515] = "HMD",
    [1516] = "KMGU_2_AO_2_5RT",
    [1517] = "declare_cluster",
    [1518] = "wsType_Test1",
    [1519] = "tempMissionPath",
    [1520] = "F_15_PTB",
    [1521] = "SA3_LN",
    [1522] = "COMMAND_REFUEL",
    [1523] = "BLU97B_DATA",
    [1524] = "VINSON",
    [1525] = "BLU61_DATA",
    [1526] = "AO_2_5_DATA",
    [1527] = "MIG_27_FONAR",
    [1528] = "Cluster_SMERCH_DATA",
    [1529] = "combine_cluster",
    [1530] = "cluster_desc",
    [1531] = "CombineFuzeGUISettings",
    [1532] = "KORD_side_gun",
    [1533] = "BL_755",
    [1534] = "M134_gun",
    [1535] = "me_video_player",
    [1536] = "GSh_23_2_tail_defense",
    [1537] = "A10C_Gatling_Effect",
    [1538] = "gun_mount",
    [1539] = "GatlingTrigger",
    [1540] = "heat_effect",
    [1541] = "smoke_effect",
    [1542] = "MBD_RBK_250_2",
    [1543] = "Coalitions",
    [1544] = "PILOT_K36",
    [1545] = "ZU_23_insurgent_ural",
    [1546] = "aircraft_guns",
    [1547] = "wsType_Explosion",
    [1548] = "guns_by_wstype",
    [1549] = "MBD_3_RBK_500SOAB",
    [1550] = "LAU_68x3_HYDRA_70_M151",
    [1551] = "wsType_Intercepter",
    [1552] = "PK_",
    [1553] = "gun_mount_templates",
    [1554] = "_WEAPON_COPY",
    [1555] = "ammo_supply_simple",
    [1556] = "MOLNIYA",
    [1557] = "cartridge_RESERVED_211",
    [1558] = "cartridge_RESERVED_210",
    [1559] = "cartridge_RESERVED_206",
    [1560] = "MBD_FAB_250",
    [1561] = "gui_map",
    [1562] = "onMissionLoadEnd",
    [1563] = "SchemeFuzeParameters",
    [1564] = "print",
    [1565] = "predefined_fuze",
    [1566] = "predefined_warhead",
    [1567] = "statusbar",
    [1568] = "wsType_MissGun",
    [1569] = "Mk_84",
    [1570] = "rockets",
    [1571] = "KAB_500KrOD",
    [1572] = "HYDRA_70_M274",
    [1573] = "panel_units_list",
    [1574] = "cumulative_warhead",
    [1575] = "Mozdok",
    [1576] = "P_15U",
    [1577] = "GluB",
    [1578] = "calcMa",
    [1579] = "calcIx",
    [1580] = "NB_1",
    [1581] = "LUU_5",
    [1582] = "ROLAND_R",
    [1583] = "wsType_Flare_WHITE",
    [1584] = "WOLALIGHT_AUX_LIGHTS",
    [1585] = "Z",
    [1586] = "copy_origin",
    [1587] = "namespace",
    [1588] = "add_launcher",
    [1589] = "Transport",
    [1590] = "AZOV",
    [1591] = "MBD_RBK_250",
    [1592] = "copy_recursive_with_metatables",
    [1593] = "SUU_25x3",
    [1594] = "TU_22_FAB_1500_2",
    [1595] = "Su_25",
    [1596] = "wsType_Chaff",
    [1597] = "copy_recursive",
    [1598] = "AKU_58_X_59",
    [1599] = "me_localizationMG",
    [1600] = "MBD_CBU_97",
    [1601] = "wsTypeGAZ_66",
    [1602] = "processing",
    [1603] = "MBD_MK_82",
    [1604] = "LAU_88_AGM_65H",
    [1605] = "TER_3_MK82AIR",
    [1606] = "onShowChatRead",
    [1607] = "APU_68_X_25ML",
    [1608] = "ws",
    [1609] = "LAU_117_AGM_65G",
    [1610] = "CheckListTree",
    [1611] = "me_dataCartridge",
    [1612] = "wsType_Generic_IR_SAM",
    [1613] = "UPK_23_25",
    [1614] = "LAU_88_AGM_65D_2_RIGHT",
    [1615] = "LAU_131x3_HYDRA_70_M278",
    [1616] = "APU_170_P_77",
    [1617] = "EA_6B",
    [1618] = "LAU_131x3_HYDRA_70_M257",
    [1619] = "OSA_9T217",
    [1620] = "KMGU_2_PTAB_2_5KO",
    [1621] = "F_16_FONAR",
    [1622] = "wsTypeComandPost",
    [1623] = "me_paramFM",
    [1624] = "LAU_105_2_CATM_9M",
    [1625] = "TRAVEL_POD",
    [1626] = "X_31A",
    [1627] = "TU_22_BETAB_250",
    [1628] = "userFiles",
    [1629] = "S_25L_PU",
    [1630] = "wsTypeRLS_RSP7",
    [1631] = "edCaptoGlove",
    [1632] = "SORBCIJA",
    [1633] = "C_8OFP2",
    [1634] = "me_campaign",
    [1635] = "SA9M330",
    [1636] = "BEACON_TYPE_DME_",
    [1637] = "MBD_4_RBK_250",
    [1638] = "Pylons",
    [1639] = "MER_6_BLU_107",
    [1640] = "SA9M311",
    [1641] = "MiG_27",
    [1642] = "F_15_FONAR",
    [1643] = "MBD_3_BetAB_500",
    [1644] = "MBD_FAB_250_2",
    [1645] = "launcher",
    [1646] = "MER_R_P_60_2",
    [1647] = "io",
    [1648] = "setSelectLang",
    [1649] = "damage_total_damage",
    [1650] = "SHTURM",
    [1651] = "createLayout",
    [1652] = "LAU_68x3_HYDRA_70_M278",
    [1653] = "AT_6",
    [1654] = "LAU_68_HYDRA_70_M151",
    [1655] = "MBD_3_GBU_22",
    [1656] = "MBD_F2_2_BL_755",
    [1657] = "AGM_122",
    [1658] = "MBD",
    [1659] = "S300V_9A84",
    [1660] = "wsType_Bomb_ODAB",
    [1661] = "MBD_F2_2_Mk_82",
    [1662] = "me_coords_info",
    [1663] = "LAU_88_AGM_65D",
    [1664] = "GROUND_EXP",
    [1665] = "HYDRA_70_MK61",
    [1666] = "VICHR",
    [1667] = "wsRadarAir",
    [1668] = "MIM_72G",
    [1669] = "TU_22_ZAB",
    [1670] = "SCUD_RAKETA",
    [1671] = "BRU_42_HS",
    [1672] = "onChange_Escape",
    [1673] = "Weather",
    [1674] = "Torpedo",
    [1675] = "LAST_AIRDROME_TYPE",
    [1676] = "PILOT_ACER",
    [1677] = "AH_64D",
    [1678] = "trackFileName",
    [1679] = "calcDamage",
    [1680] = "updateColumnHeaders",
    [1681] = "register_car",
    [1682] = "form_unguided_rocket",
    [1683] = "F_111",
    [1684] = "HWAR_SMOKE_GENERATOR",
    [1685] = "LAU_131x3_HYDRA_70_M156",
    [1686] = "loadDeviceProfile",
    [1687] = "wsType_RunWay",
    [1688] = "mul_advanced",
    [1689] = "panel_wpt_properties",
    [1690] = "package",
    [1691] = "MBD_3_M_117",
    [1692] = "M279_AGM114",
    [1693] = "ZU_23_insurgent",
    [1694] = "IL_76",
    [1695] = "LAU_68_HYDRA_70_MK5",
    [1696] = "C_8CM_VT",
    [1697] = "wsTypeUral375PBU",
    [1698] = "onSimulationStart",
    [1699] = "wsType_Bomb",
    [1700] = "GT_t",
    [1701] = "onShowVoicechat",
    [1702] = "MER_R_P_60",
    [1703] = "PTB_367GAL",
    [1704] = "wsType_Bomb_BetAB",
    [1705] = "Z_BAK_3",
    [1706] = "UH_60A",
    [1707] = "CAT_TORPEDOES",
    [1708] = "Hawk_Search_Radar",
    [1709] = "Factory",
    [1710] = "LAU_117_AGM_65H",
    [1711] = "IL_78",
    [1712] = "Airborne",
    [1713] = "panel_trigrules",
    [1714] = "Su_27_cells_properties",
    [1715] = "pylon",
    [1716] = "COMMAND_RELOAD_CANNON",
    [1717] = "OSA",
    [1718] = "MBD_M_117",
    [1719] = "SA5B55",
    [1720] = "image_search_path",
    [1721] = "wsType_Bomb_A",
    [1722] = "XM_158_HYDRA_70_MK1",
    [1723] = "wstype_missiles",
    [1724] = "LOOK_GOOD",
    [1725] = "wsType_Control_Cont",
    [1726] = "dbYears",
    [1727] = "AN_26B",
    [1728] = "ZU_23_insurgent_okop",
    [1729] = "CreateCombolist",
    [1730] = "wsTypeKAMAZ_Fire",
    [1731] = "MBD_3_RBK_250",
    [1732] = "ConflagrationTime",
    [1733] = "wsType_FuelTank",
    [1734] = "A_10_FONAR",
    [1735] = "wsType_GenericAPC",
    [1736] = "Picture",
    [1737] = "VETER",
    [1738] = "X_31P",
    [1739] = "makeHelicopterCanopyGeometry",
    [1740] = "arg_ch_rng_z",
    [1741] = "MER_TOW",
    [1742] = "LAU_105_1_CATM_9M_R",
    [1743] = "Sensors",
    [1744] = "PTB_800L_Wing",
    [1745] = "TORNADO_FONAR",
    [1746] = "mechanimations",
    [1747] = "SmokeGeneratorAIM_red",
    [1748] = "GBU_30",
    [1749] = "REZKY",
    [1750] = "SUU_25",
    [1751] = "F_4_FONAR_Z",
    [1752] = "F_14",
    [1753] = "LAU_117",
    [1754] = "MODULATION_AM_AND_FM",
    [1755] = "XM_158_HYDRA_70_M274",
    [1756] = "MI_26",
    [1757] = "wsType_OBLOMOK_3",
    [1758] = "Su_33",
    [1759] = "MER_12_B52_Mk_82",
    [1760] = "Gudauta",
    [1761] = "MI_8MT",
    [1762] = "wsTypeBus",
    [1763] = "wsType_Test4",
    [1764] = "set_recursive_metatable",
    [1765] = "me_nodes_item_view",
    [1766] = "F_16_tbl",
    [1767] = "TICONDEROGA",
    [1768] = "cartridge_308cal",
    [1769] = "GBU_10",
    [1770] = "P_24T",
    [1771] = "PILOT_PARASHUT",
    [1772] = "wsRadarAWACS",
    [1773] = "S_3R",
    [1774] = "Mk_83",
    [1775] = "Menu",
    [1776] = "E_2C",
    [1777] = "PTB_F2_1500",
    [1778] = "bru_42_ls",
    [1779] = "X_25MP",
    [1780] = "Tor_",
    [1781] = "wsTypeLauncher",
    [1782] = "theatresByName",
    [1783] = "wsType_OBLOMOK_1",
    [1784] = "AGM_114",
    [1785] = "J_11A",
    [1786] = "P_33E",
    [1787] = "wsType_Shell_SPPU",
    [1788] = "ED_PUBLIC_AVAILABLE",
    [1789] = "AKU_58_X_31A",
    [1790] = "ALARM",
    [1791] = "StingerIZR_2",
    [1792] = "S_25L",
    [1793] = "AIM_9",
    [1794] = "tu_22_mbdz_six",
    [1795] = "PTB_KA_50",
    [1796] = "SH_60B",
    [1797] = "RLO_9C19M2",
    [1798] = "MBD_3_LAU_61",
    [1799] = "LAU_117_AGM_65E",
    [1800] = "Kuznecow",
    [1801] = "VertLayout",
    [1802] = "Static",
    [1803] = "SA3_SR",
    [1804] = "AIM_9P",
    [1805] = "LAU_88_AGM_65D_2_LEFT",
    [1806] = "wsTypeMAZ_6303",
    [1807] = "Sukhumi",
    [1808] = "SmokeGenerator_green",
    [1809] = "FANTASM",
    [1810] = "KORD_12_7",
    [1811] = "wsType_Cannon_Cont",
    [1812] = "REFLEX",
    [1813] = "MiG_23",
    [1814] = "RQ_1A_Predator",
    [1815] = "wsType_ChildMiss",
    [1816] = "nav_lights_lockon",
    [1817] = "BDU_50HD",
    [1818] = "wsType_Radar_Miss",
    [1819] = "SMERCH_9M55K",
    [1820] = "wsTypeSteamLocomotive",
    [1821] = "wsTypeZIL_4334",
    [1822] = "MBD_BETAB_250",
    [1823] = "CAT_CLUSTER_DESC",
    [1824] = "MIG_23_PTB",
    [1825] = "mer_5",
    [1826] = "TU_22_FAB_100",
    [1827] = "ModsPreloadResources",
    [1828] = "wsTypeWGruzOtkr",
    [1829] = "GBU_16",
    [1830] = "Shilka_",
    [1831] = "BD4_",
    [1832] = "db_path",
    [1833] = "net",
    [1834] = "wsType_Helicopter",
    [1835] = "SPRUANCE",
    [1836] = "SENSOR_RADAR",
    [1837] = "P_73",
    [1838] = "LastPlaneType",
    [1839] = "BetAB_500",
    [1840] = "SmokeGeneratorAIM_white",
    [1841] = "BetAB_500ShP",
    [1842] = "wsTypeVAZ",
    [1843] = "me_startEditor",
    [1844] = "wsType_GenericLightArmoredShip",
    [1845] = "wsTypeToString",
    [1846] = "VICHR_M",
    [1847] = "wsType_GenericSAU",
    [1848] = "F_4E",
    [1849] = "M60_SIDE_L",
    [1850] = "wsTypeUral375",
    [1851] = "tempMissionName",
    [1852] = "wsType_Shell",
    [1853] = "me_action_panel_widget_factory",
    [1854] = "defaultReturnScreen",
    [1855] = "GBU_11",
    [1856] = "PinpointStrike",
    [1857] = "tools",
    [1858] = "wsTypeMAZobsch",
    [1859] = "panel_goal",
    [1860] = "Insets",
    [1861] = "LAU_68_HYDRA_70_M274",
    [1862] = "type",
    [1863] = "wsType_GenericTank",
    [1864] = "TGM_65G",
    [1865] = "APU_68_X_25MP",
    [1866] = "wsTypeTZ10",
    [1867] = "wsTypeElektrovoz",
    [1868] = "KINGAL",
    [1869] = "F_15",
    [1870] = "FAB_1500",
    [1871] = "wsType_ShortMTail",
    [1872] = "B_20",
    [1873] = "CATM_65K",
    [1874] = "SU_39_FONAR",
    [1875] = "AGM_65G",
    [1876] = "LANTIRN",
    [1877] = "PTB_B_1B",
    [1878] = "OBLOMOK_OBSHIWKI_1",
    [1879] = "X_23L",
    [1880] = "me_statusbar",
    [1881] = "HYDRA_70_M278",
    [1882] = "MIG_29_FONAR",
    [1883] = "Stinger_manpad",
    [1884] = "TK600",
    [1885] = "collect_input_profiles",
    [1886] = "wsType_GroundExp",
    [1887] = "ODAB_500PM",
    [1888] = "HVAR",
    [1889] = "F_4_FONAR_P",
    [1890] = "NEUSTRASH",
    [1891] = "B_20CM",
    [1892] = "LAU_88_AGM_65E_2_RIGHT",
    [1893] = "HumanTypeStart",
    [1894] = "HorzLayout",
    [1895] = "MALUTKA",
    [1896] = "M261_HYDRA_70_M156",
    [1897] = "ZU_23_URAL",
    [1898] = "C_8CM",
    [1899] = "LAU_61",
    [1900] = "verbose_to_failures_table",
    [1901] = "SPPU_22",
    [1902] = "LAU_131_HYDRA_70_M156",
    [1903] = "wsTypeVulkan",
    [1904] = "ah64a_cells_properties",
    [1905] = "C_8",
    [1906] = "music",
    [1907] = "onQuit",
    [1908] = "me_crutches",
    [1909] = "directional_a2a_warhead",
    [1910] = "AGM_86",
    [1911] = "KUB_2P25",
    [1912] = "BUK_LL",
    [1913] = "PTAB_2_5KO",
    [1914] = "MI_24W",
    [1915] = "F_14A_FONAR",
    [1916] = "AGM_65E",
    [1917] = "wsType_Navy",
    [1918] = "MBD_MK_81",
    [1919] = "BUK_9C18M1",
    [1920] = "MBD_3_BETAB_250",
    [1921] = "CAT_ROCKETS",
    [1922] = "wsType_Bomb_Antisubmarine",
    [1923] = "onDebriefingEvent",
    [1924] = "_IsAuthorized",
    [1925] = "damage_pow",
    [1926] = "RLO_9C15MT",
    [1927] = "__FINAL_VERSION__",
    [1928] = "lfs",
    [1929] = "P_51D_30_NA",
    [1930] = "MBD_ODAB",
    [1931] = "ListBoxItem",
    [1932] = "LAU_68x3_HYDRA_70_M156",
    [1933] = "DefMechTimeIdx",
    [1934] = "C_8CM_BU",
    [1935] = "wsType_AS_Missile",
    [1936] = "Sea_Eagle",
    [1937] = "X_55",
    [1938] = "SU_34_FONAR_L",
    [1939] = "Widget",
    [1940] = "wsType_Support",
    [1941] = "SoundPlayer",
    [1942] = "me_vehicle",
    [1943] = "me_nodes_map_view",
    [1944] = "AB_212",
    [1945] = "declare_paveway_2",
    [1946] = "userDataDir",
    [1947] = "XZAB_500",
    [1948] = "MBD_RBK_500SOAB",
    [1949] = "C_8CM_WH",
    [1950] = "URAGAN_9M27F",
    [1951] = "AIM_120",
    [1952] = "X_59M",
    [1953] = "wsType_Missile",
    [1954] = "__EMBEDDED__",
    [1955] = "censorship",
    [1956] = "XM_158_HYDRA_70_M257",
    [1957] = "Puma",
    [1958] = "RBK_500AO",
    [1959] = "Roland_",
    [1960] = "MBD_3_LAU_10",
    [1961] = "B_8V20A_OM",
    [1962] = "X_28",
    [1963] = "Krymsk",
    [1964] = "db_get_logger",
    [1965] = "setMiniValue",
    [1966] = "DCS",
    [1967] = "LAU_131x3_HYDRA_70_MK5",
    [1968] = "visualizer",
    [1969] = "LAU_68x3_HYDRA_70_MK61",
    [1970] = "S300V_9A85",
    [1971] = "me_contextMenu",
    [1972] = "panel_waitDsbweb",
    [1973] = "damage_cells",
    [1974] = "Mk_82",
    [1975] = "tail_liquid",
    [1976] = "MBD_F2_2_Mk_83",
    [1977] = "ConfigHelper",
    [1978] = "wsType_AA_TRAIN_Missile",
    [1979] = "MER_6_4_PB_250",
    [1980] = "KC_10",
    [1981] = "sound",
    [1982] = "wsType_Flare",
    [1983] = "wsType_NoWeapon",
    [1984] = "DcsWeb",
    [1985] = "panel_server_list",
    [1986] = "OPTIONS_ADD_COMMAND_CODES_TO_TOOLTIP",
    [1987] = "cartridge_30mm",
    [1988] = "TER_3_SUU_25_8_LUU_2",
    [1989] = "__DCS_VERSION__",
    [1990] = "dictionary",
    [1991] = "getHistoricalCountres",
    [1992] = "F4_PILON",
    [1993] = "panel_failures",
    [1994] = "TER_3_GBU_12",
    [1995] = "me_modulesInfo",
    [1996] = "ODAB_250",
    [1997] = "wsType_RW1",
    [1998] = "ATGM_Kornet",
    [1999] = "wsType_Civil",
    [2000] = "MER_2_F_18_CBU_97",
    [2001] = "AN_ASQ_173_LST_CAM",
    [2002] = "TANGAZH",
    [2003] = "lau_117",
    [2004] = "Su_34",
}]]