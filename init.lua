print("Starting ESP")

-- Constants
SSID    = "your-SSID"
APPWD   = "your-PSWD"
CMDFILE = "bmp180ex.lua"   -- File that is executed after connection

-- Some control variables
wifiTrys     = 0    -- Counter of trys to connect to wifi
NUMWIFITRYS  = 50   -- Max number of WIFI Testings while waiting for connection

-- Change the code of this function that it calls your code.
function launch()
  print("Connected to WIFI!")
  print("IP Address: " .. wifi.sta.getip())

  bmp180 = require("bmp180")

  tmr.alarm(0, 300000, 1, function() dofile(CMDFILE) end)
end

function checkWIFI()
  if ( wifiTrys > NUMWIFITRYS ) then
    print("Sorry. Not able to connect")
  else
    ipAddr = wifi.sta.getip()

    if ( ( ipAddr ~= nil ) and  ( ipAddr ~= "0.0.0.0" ) )then
      tmr.alarm( 1 , 500 , 0 , launch )     -- timer 1
    else
      tmr.alarm( 0 , 2500 , 0 , checkWIFI)  -- timer 0
      print("Checking WIFI..." .. wifiTrys)
      wifiTrys = wifiTrys + 1
    end
  end
end

--Shut off the RGB LED

    gpio.mode(6, gpio.OUTPUT)
    gpio.mode(7, gpio.OUTPUT)
    gpio.mode(8, gpio.OUTPUT)
    gpio.write(6,gpio.LOW)
    gpio.write(7,gpio.LOW)
    gpio.write(8,gpio.LOW)

ipAddr = wifi.sta.getip()

if ( ( ipAddr == nil ) or  ( ipAddr == "0.0.0.0" ) ) then
  -- We aren't connected, so let's connect
  print("Configuring WIFI....")
  wifi.setmode( wifi.STATION )
  wifi.sta.config( SSID , APPWD)

  print("Waiting for connection")
  tmr.alarm( 0 , 2500 , 0 , checkWIFI ) 
else
 -- We are connected, so just run the launch code.
 launch()
end
