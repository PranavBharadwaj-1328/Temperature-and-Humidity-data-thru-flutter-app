from flask import Flask
import paho.mqtt.subscribe as subscribe
import json
# The ThingSpeak Channel ID.
# Replace <YOUR-CHANNEL-ID> with your channel ID.
channelID = "1379680"
# The write API key for the channel.
# Replace <YOUR-CHANNEL-WRITEAPIKEY> with your write API key.
readAPIKey = "4509YU9SIR82AAQE"
# The hostname of the ThingSpeak MQTT broker.
mqttHost = "mqtt.thingspeak.com"
# You can use any username.
mqttUsername = "mwa0000022383501"
# Your MQTT API key from Account > My Profile.
mqttAPIKey = "43GRWC90R8UAF2LE"
# Create the topic string.
topic = "channels/" + channelID + "/subscribe/json/" + readAPIKey
app = Flask(__name__)
@app.route('/',methods=['GET'])
def index():
    msg = subscribe.simple(topic, hostname=mqttHost, auth={'username':mqttUsername,'password':mqttAPIKey})
    ent= json.loads(msg.payload)
    return (str(ent["field1"])+","+str(ent["field2"]))

if __name__ == "__main__":
    app.run("0.0.0.0",port=8080, debug=True)
