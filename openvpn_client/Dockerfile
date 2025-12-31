ARG BUILD_FROM
FROM $BUILD_FROM

# Install the OpenVPN package and web server
RUN apk add --no-cache openvpn lighttpd


# Web server setup
RUN mkdir /cgi-bin

# Web server data
COPY lighttpd.conf index.html index.js addon.css /
COPY cgi-bin/*sh /cgi-bin
RUN chmod a+x /cgi-bin/*.sh

# Start-up script
COPY run.sh /
RUN chmod a+x /run.sh
CMD [ "/run.sh" ]
