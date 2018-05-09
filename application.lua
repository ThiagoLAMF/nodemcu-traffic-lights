print("\nStarting server...");

-- Vars:
-- pins
pGreen = 5; --D5 -- GPIO14
pYellow = 7; --D7 -- GPIO13
pRed = 8; --D8 

--[[
	status = 0 (red to yellow)
	status = 1 (yellow to green)
	status = 2 (green to yellow)
	status = 3 (yellow to red)
]]
status = 0; -- initial state for the traffic light (red)

-- total time in miliseconds the lights will stay on 
timeRed = 5000; 
timeYellow = 2000; 
timeGreen = 5000; 

lastUpdate = tmr.time(); -- last time the light changed (Limited to 31 bits, after that it wraps around back to zero)

-- GPIO
gpio.mode(pGreen, gpio.OUTPUT);
gpio.mode(pYellow, gpio.OUTPUT);
gpio.mode(pRed, gpio.OUTPUT);

function turn_on(pin)
	gpio.write(pin, gpio.HIGH);
end

function turn_off(pin)
	gpio.write(pin, gpio.LOW);
end

turn_off(pGreen)
turn_off(pYellow)
turn_off(pRed)

-- Traffic light:

function get_state_time()
	if (status == 0) then
		return timeRed;
	elseif(status == 1 or status == 3) then
		return timeYellow;
	elseif(status == 2) then
		return timeGreen;
	end
end

function refresh_lights() 
	if (status == 0) then
		turn_off(pYellow);
		turn_on(pRed);
	elseif(status == 1) then
		turn_off(pRed);
		turn_on(pYellow);
	elseif(status == 2) then
		turn_off(pYellow);
		turn_on(pGreen);
	elseif(status == 3) then
		turn_off(pGreen)
		turn_on(pYellow);
	end
	status = ((status + 1) % 4); --updates the state of the traffic light
	lastUpdate = tmr.time();
end

function update_lights_callback()
	mytimer = tmr.create(); -- creates the timer
	mytimer:register(get_state_time(), tmr.ALARM_SINGLE, update_lights_callback); -- set the timer, based on the current state
	refresh_lights();
	mytimer:start(); -- starts the timer
end

-- initiates the sequence:
update_lights_callback();

-- web server:
srv=net.createServer(net.TCP)

srv:listen(80,function(conn)
    conn:on("receive", function(client,request)
        local buf = "";
        -- JSON
        buf = buf .. '{"id":"",';
        buf = buf .. '"status":"' .. status .. '",';
        buf = buf .. '"lastUpdate":"' .. lastUpdate .. '",';
	buf = buf .. '"now":"' ..  tmr.time() .. '",';
        buf = buf .. '"timeRed":"' .. timeRed .. '",';
        buf = buf .. '"timeYellow":"' .. timeYellow .. '",';
        buf = buf .. '"timeGreen":"' .. timeGreen .. '"}';
        

	--[[EDN
	buf = buf .. '{';
        buf = buf .. ':status ' .. status .. ' ';
        buf = buf .. ':lastUpdate ' .. lastUpdate .. ' ';
	buf = buf .. ':now ' ..  tmr.time() .. ' ';
        buf = buf .. ':timeRed ' .. timeRed .. ' ';
        buf = buf .. ':timeYellow ' .. timeYellow .. ' ';
        buf = buf .. ':timeGreen ' .. timeGreen .. '}';]]

        client:send("HTTP/1.0 200 OK\r\nAccess-Control-Allow-Origin:*\r\nContent-Type: application/json\r\nCache-Control: private, no-store\r\n\r\n");
        client:send(buf);
        --client:close();
        --collectgarbage();
    end)
   conn:on("sent",function(conn) conn:close() end)
end)


print("Server started!");
