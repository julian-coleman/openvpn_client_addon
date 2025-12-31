#!/usr/bin/with-contenv bashio

# Our parameters
CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text

TUN=/dev/net/tun

BIN=/usr/sbin/openvpn
PID=/openvpn.pid
DEF_PARAMS="--writepid $PID --config $OVPN"

date

# Run the web server
echo Starting web server
lighttpd -f /lighttpd.conf

# Do we have a tunnel device?
if [ -e /dev/net/tun ]; then
    echo Tunnel device found
else
    echo Creating tunnel device
    mkdir -p /dev/net
    mknod /dev/net/tun c 10 200
fi

# Are the configuration files available?
echo Looking for configuration
found=0
while true; do
    if [ -r $OVPN ]; then
        echo "Found configuration file(s):"
        found=1
        ls -l $OVPN
        PARAMS="$DEF_PARAMS"
        if [ -r $TEXT ]; then
            ls -l $TEXT
            PARAMS="$PARAMS --auth-user-pass $TEXT"
        fi
    fi
    if [ $found -eq 1 ]; then
        break
    fi
    echo Waiting for configuration file
    sleep 60
    date
done

# Run OpenVPN
while true; do
    echo Starting OpenVPN
    PARAMS="$DEF_PARAMS"
    if [ -r $TEXT ]; then
        PARAMS="$PARAMS --auth-user-pass $TEXT"
    fi
    echo $BIN $PARAMS
    $BIN $PARAMS || true
    rm -f $PID
    echo Waiting for restart
    sleep 60
done
