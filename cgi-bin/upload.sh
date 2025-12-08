#!/bin/sh
#
# Upload a configuration file

CONFIG_DIR=/config
OVPN=$CONFIG_DIR/client.ovpn
TEXT=$CONFIG_DIR/client.text
TMP=$CONFIG_DIR/tmpfile

# HTML end <message> <status>
html_end () {
    echo '  <div class="addon-status' $2'">'
    echo $1
    echo '  </div>'
    echo '  <div></div>'
    echo '  <a href="..">'
    echo '    <div class="addon-button" id="upload-done" onmouseover="buttonHover('"'upload-done'"')" onmouseout="buttonOut('"'upload-done'"')">'
    echo 'OK'
    echo '    </div>'
    echo '  </a>'
    echo '</div>' # addon-content
    echo '<script src="../index.js"></script>'
    echo '</body></html>'
    exit
}

# HTML Start
echo Content-type: text/html
echo
echo '<!DOCTYPE html>'
echo '<html><body>'
echo '<link rel="stylesheet" type="text/css" media="screen" href="../addon.css">'
echo '<div class="addon-content">'

case "$QUERY_STRING" in
    ovpn*)
        FILE=$OVPN
    ;;
    text*)
        FILE=$TEXT
    ;;
    *)
        html_end 'Upload failed: unknown configuration' addon-status-bad
    ;;
esac

echo -n > $TMP
if [ $? -ne 0 ]; then
    html_end 'Upload failed: create error' addon-status-bad
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
            html_end 'Upload failed: missing file name' addon-status-bad
        ;;
    esac

    # We want text/plain or application/octet-stream
    case "$line" in
        Content-Type:*text/plain*|Content-Type:*application/octet-stream*)
            found=$((count + 1)) # Skip following empty line
        ;;
        Content-Type:*)
            html_end 'Upload failed: wrong file type' addon-status-bad
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
    html_end 'Upload failed: write error' addon-status-bad
fi

# Rename to the real file
chmod 0644 $TMP
mv $TMP $FILE
if [ $? -ne 0 ]; then
    html_end 'Upload failed: rename error' addon-status-bad
fi

#cd $CONFIG 
#ls -l $FILE
html_end 'Upload succeeded' addon-status-good
