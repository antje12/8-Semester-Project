#Semester Project 8
MDSD & IOT

External DSL example:

DSL Example
```
system Building44
    baseURL 'http://myserver.dk/{Device}/{SensorType}'
    sampRate 20 ms
    batchSize 10
    location U173
        WiFi 'myWifi' 'secretpassword'
    device SofaSensor in U173
        sampRate 10 ms
        deviceType ESP32
        sensor TempSensorCeiling
            sampRate 5 ms
            batchSize 1
            signalType Digital
            output Temperature
        sensor TempSensorFloor
            signalType Analog
            output Temperature
    device WindowSensor at U173
        WiFi ssid 'myWifi' password 'secretpassword'
        sampRate 50 ms
        deviceType Arduino
        sensor TempSensorWindow
            batchSize 1
            signalType Analog
            output Humidity
```

Sampling: hvor ofte vi læser fra sensoren
Batch size: hvor mange læsninger før vi sender til serveren


