#!/bin/sh
#
# Display (download) a configuration file

# Our parameters
CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text

# The file to display
if [ "$QUERY_STRING" = "ovpn=" ]; then
    FILE=$OVPN
elif [ "$QUERY_STRING" = "text=" ]; then
    FILE=$TEXT
fi
if [ ! -r $FILE ]; then
    exit
fi

# Header for the response
echo Content-type: application/octet-stream
echo

# File contents
cat $FILE
