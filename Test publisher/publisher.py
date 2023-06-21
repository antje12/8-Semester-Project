import paho.mqtt.client as mqtt
import time
import os

# Define callback functions for MQTT events
def on_connect(client, userdata, flags, rc):
    print("Connected with result code " + str(rc))

def on_publish(client, userdata, mid):
    print(f"Message {mid} published")

# Create an MQTT client instance
client = mqtt.Client()

# Set the callback functions
client.on_connect = on_connect
client.on_publish = on_publish

# Connect to the MQTT server
MQTT_HOST = os.environ.get("MQTT_HOST", "localhost")
MQTT_PORT = int(os.environ.get("MQTT_PORT", 1883))
client.connect(MQTT_HOST, MQTT_PORT)

# Start the MQTT client loop
client.loop_start()

try:
    while True:
        mqtt_msg = client.publish("atemp", str(22))
        mqtt_msg.wait_for_publish()
        mqtt_msg = client.publish("dtemp", str(22.4))
        mqtt_msg.wait_for_publish()
        mqtt_msg = client.publish("co2", str(78))
        mqtt_msg.wait_for_publish()
        mqtt_msg = client.publish("humidity", str(32))
        mqtt_msg.wait_for_publish()
        print(f"Published Messages")

        # Wait for 1 second before publishing the next message
        time.sleep(1)

except KeyboardInterrupt:
    # Stop the MQTT client loop gracefully on keyboard interrupt
    client.loop_stop()
    print("\nStopped.")
