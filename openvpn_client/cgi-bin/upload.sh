#!/bin/sh
#
# Upload a configuration file

CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text
TMP=$CONFIG_DIR/tmpfile
LANG=en

# HTML end <message> <status>
html_end () {
    echo '  <div class="addon-status' $2'">'
    # Translated messages
    if [ $LANG = cs ]; then
        case $1 in
            succeeded)
                echo Nahrávání se zdařilo
            ;;
            unknown)
                echo Nahrávání se nezdařilo: chybí název souboru
            ;;
            missing)
                echo Nahrávání se nezdařilo: neznámá konfigurace
            ;;
            wrong)
                echo Nahrávání se nezdařilo: nesprávný typ souboru: $line
            ;;
            create)
                echo Nahrávání se nezdařilo: chyba při vytváření souboru
            ;;
            write)
                echo Nahrávání se nezdařilo: chyba při zápisu do souboru
            ;;
            rename)
                echo Nahrávání se nezdařilo: chyba při přejmenování souboru
            ;;
        esac
    else # LANG=en
        case $1 in
            succeeded)
                echo Upload succeeded
            ;;
            unknown)
                echo Upload failed: unknown configuration
            ;;
            missing)
                echo Upload failed: missing file name
            ;;
            wrong)
                echo Upload failed: wrong file type: $line
            ;;
            create)
                echo Upload failed: file creation error
            ;;
            write)
                echo Upload failed: write error
            ;;
            rename)
                echo Upload failed: rename error
            ;;
        esac
    fi
    echo '  </div>'
    echo '  <div></div>'
    echo '  <a href="..">'
    echo '    <div class="addon-button" id="upload-done" onmouseover="buttonHover('"'upload-done'"')" onmouseout="buttonOut('"'upload-done'"')">'
    echo 'OK'
    echo '    </div>'
    echo '  </a>'
    echo '</div>' # addon-content
    echo '</body></html>'
    exit
}

# HTML Start
echo Content-type: text/html
echo
echo '<!DOCTYPE html>'
echo '<meta charset="UTF-8">'
echo '<html><body>'
echo '<link rel="stylesheet" type="text/css" media="screen" href="../addon.css">'
echo '<div class="addon-content">'

if [ "$QUERY_STRING" = "" ]; then
    html_end missing addon-status-bad
fi

# Language from parameters
case "$QUERY_STRING" in
    *lang=cs)
        LANG=cs
    ;;
esac

# File from parameters
case "$QUERY_STRING" in
    ovpn=1*)
        FILE=$OVPN
    ;;
    text=1*)
        FILE=$TEXT
    ;;
    *)
        html_end unknown addon-status-bad
    ;;
esac

echo -n > $TMP
if [ $? -ne 0 ]; then
    html_end create addon-status-bad
fi

# Find the separator from $CONTENT_TYPE
sep="${CONTENT_TYPE#*boundary=}"

# The file is the lines between the content type + 1 and separator - 1
# Write this to a temporary file
found=0
count=0
output=0
while read line;
do
    count=$((count + 1))

    # Check the file name
    case "$line" in
        Content-Disposition*filename=\"\"*)
            html_end missing addon-status-bad
        ;;
    esac

    # We want application/x-openvpn-profile, text/plain or application/octet-stream
    case "$line" in
        Content-Type:*application/x-openvpn-profile*|Content-Type:*text/plain*|Content-Type:*application/octet-stream*)
            found=$((count + 1)) # Skip following empty line
        ;;
        Content-Type:*)
            html_end wrong addon-status-bad
    esac

    # The last 2 lines are blank then separator, so skip them
    if [ $found -gt 0 ] && [ $count -gt $found ]; then
        case "$line" in
            --$sep--*)
                break
            ;;
            *)
                # Don't output the previous line the first time
                if [ $output -eq 1 ]; then
                    echo $prev >> $TMP
                fi
                prev="$line"
                output=1
            ;;
        esac
    fi
done
if [ $? -ne 0 ]; then
    html_end write addon-status-bad
fi

# Rename to the real file
chmod 0644 $TMP
mv $TMP $FILE
if [ $? -ne 0 ]; then
    html_end rename addon-status-bad
fi

#cd $CONFIG 
#ls -l $FILE
html_end succeeded addon-status-good
