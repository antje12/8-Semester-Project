import paho.mqtt.client as mqtt
import requests
import os
import datetime
import json

# Thingspeak Config
THINGSPEAK_CHANNEL = os.environ["THINGSPEAK_CHANNEL"]
THINGSPEAK_URL = f"https://api.thingspeak.com/channels/{THINGSPEAK_CHANNEL}/bulk_update"
THINGSPEAK_FIELD = os.environ["THINGSPEAK_FIELD"]
# We should set this API key as an environment variable,
# but the account is free so it's not a big deal right now
THINGSPEAK_API_KEY = os.environ["THINGSPEAK_API_KEY"]

# MQTT Config
MQTT_TOPIC = os.environ["MQTT_TOPIC"]
MQTT_HOST = os.environ["MQTT_HOST"]
MQTT_PORT = int(os.environ.get("MQTT_PORT", 1883))

# Define callback functions for MQTT events
def on_connect(client, userdata, flags, rc):
    print("Connected with result code "+str(rc))

def on_message(client, userdata, msg):
    print("Client: "+str(client))
    print("User: "+str(userdata))
    print(msg.topic+": "+str(msg.payload))
    
    updates = []
    now = datetime.datetime.now()
    for data in msg.payload.split(b','):
        now += datetime.timedelta(seconds=1)
        parts = data.split(b'#')
        time_value = int(parts[0])
        temperature_value = int(parts[1])
        updates.append({
            f"field{THINGSPEAK_FIELD}": temperature_value,
            "created_at": now.strftime("%Y-%m-%dT%H:%M:%S"),
        })
        print("Time: ", time_value)
        print("Temperature: ", temperature_value)

    # Send the message to ThingSpeak
    payload = {
        "write_api_key": THINGSPEAK_API_KEY, 
        "updates": updates
    }
    header = {
        "Content-Type": "application/json"
    }
    response = requests.post(THINGSPEAK_URL, headers=header, data=json.dumps(payload))
    
    if response.status_code == 202:
        print("Data sent to ThingSpeak successfully")
    else:
        print("Error:")
        print(response)

# Create MQTT client instance
client = mqtt.Client()
client.on_connect = on_connect
client.on_message = on_message

# Start the broker
client.enable_logger()
client.connect(MQTT_HOST, MQTT_PORT)
client.subscribe(MQTT_TOPIC)
client.loop_forever()
