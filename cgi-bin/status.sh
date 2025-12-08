#!/bin/sh
#
# Check if the OpenVPN configuration files are available

# Our parameters
CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text
PID=/openvpn.pid

# Header for the response
echo Content-type: text/plain
echo

# The configuration files to check
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

# OpenVPN PID file
if [ -r $PID ]; then
    echo pid=`cat $PID`
else
    echo pid=0
fi
