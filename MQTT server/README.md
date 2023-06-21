# MQTT Server
A simple MQTT server that subscribes to a topic and writes the data to a field on a ThingSpeak channel. When running the server, the following environment variables must be set:
- **THINGSPEAK_FIELD:** The field the data should be written to on ThingSpeak. See *ThingSpeak Fields* for an overview of which fields are avialable.
- **THINGSPEAK_API_KEY:** The write API key of the channel the data should be written to. Use `VHXNJEQO1H0PY513` for testing. This API key is connected to a free account, so it's fine to expose it.
- **MQTT_HOST:** The hostname of the MQTT broker.
- **MQTT_PORT:** The port of the MQTT broker.
- **MQTT_TOPIC:** The topic the server should subscribe to.

## Getting started
A single container be be started by running the commands in the following sections. Alternatively, 4 default services can be started by running: `docker-compose up`

### Build
`docker build -t mqtt-thingspeak .`

### Run
`docker run -e THINGSPEAK_FIELD=1 -e THINGSPEAK_API_KEY=VHXNJEQO1H0PY513 -e MQTT_HOST=localhost -e MQTT_PORT=1883 -e MQTT_TOPIC=/topic/qos0 mqtt-thingspeak`

## ThingSpeak Fields
- **Field 1:** Analog Temperature
- **Field 2:** Digital Temperature
- **Field 3:** CO2
- **Field 4:** Humidity