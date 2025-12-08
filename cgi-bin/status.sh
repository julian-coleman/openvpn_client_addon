#!/bin/sh
#
# Check if the OpenVPN configuration files are available

# Our parameters
CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text

# Header for the response
echo Content-type: text/plain
echo

# The file to check
if [ -r $OVPN ]; then
   echo ovpn=YES
else
   echo ovpn=NO
fi
if [ -r $TEXT ]; then
   echo text=YES
else
   echo text=NO
fi
