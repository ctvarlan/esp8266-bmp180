-- the code for BMP180 is inspired from
-- https://github.com/javieryanez/nodemcu-modules/tree/master/bmp180

OSS = 1 -- oversampling setting (0-3)
SDA_PIN = 3 -- sda pin, GPIO2
SCL_PIN = 4 -- scl pin, GPIO0
bmp180.init(SDA_PIN, SCL_PIN)
--function readBMP()
bmp180.read(OSS)
t = bmp180.getTemperature()
p = bmp180.getPressure()
l = adc.read(0)
t = (t/10)..'.'..(t%10)
p = (p/100)..'.'..(p%100)
print("Temperature: "..t.."   deg C")
print("Pressure:    "..p.." mbar")
print("Light:       "..l)
print("heap: "..node.heap())
-- sending data to Thingspeak.com
print("Sending data to thingspeak.com")
 conn=net.createConnection(net.TCP, 0)
--conn:on("receive", function(sck, payload) print(payload) end)
-- -- api.thingspeak.com 184.106.153.149
 conn:connect(80,'184.106.153.149')

 conn:send('GET /update?key=XXXXXXXXXXXXXXXX&field1='..p..'&field2='..t..'&field3='..l..'HTTP/1.1\r\n')
 conn:send("Host: api.thingspeak.com\r\n")
 conn:send("Accept: */*\r\n")
 conn:send("User-Agent: Mozilla/4.0 (compatible; esp8266 Lua; Windows NT 5.1)\r\n")
 conn:send("\r\n")

--see it here https://thingspeak.com/channels/15699
