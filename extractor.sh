#!/bin/bash -e

function findHomeFolder {
	local FILE_PATH="${BASH_SOURCE[0]}"

	if [ -L "$FILE_PATH" ]; then
		local PHYS_FILE_PATH="$(dirname $(readlink -f $FILE_PATH))"
	else
		local PHYS_FILE_PATH="$(dirname $FILE_PATH)"
	fi

	cd $PHYS_FILE_PATH
	local ABS_FILE_PATH="$(pwd)"
	cd - >/dev/null

	echo $ABS_FILE_PATH
}

HOME_FOLDER="$(findHomeFolder)"
DESTINATION_FOLDER="$HOME_FOLDER/unpacked"
TEMPORARY_ARCHIVE="$DESTINATION_FOLDER/temp.zip"
JRUBY_FOLDER="$DESTINATION_FOLDER/jruby-1.7.3"
JRUBY_LAUNCHER="$DESTINATION_FOLDER/jruby-1.7.3/bin/jruby"
BOOTSTRAP_FILE="$DESTINATION_FOLDER/bootstrap.rb"
PAYLOAD_FOLDER="$DESTINATION_FOLDER/payload"

# size of the executable script, stripped when unpacking in order to obtain its payload
UNPACKER_SIZE= #autogenerated when installer is assembled


# exiting if the target folder already exists
if [ -d "$DESTINATION_FOLDER" ]; then
    echo "$DESTINATION_FOLDER already exists. Please delete or move it and retry."
    exit 1
fi

echo "Extracting in $DESTINATION_FOLDER"

mkdir "$DESTINATION_FOLDER"

# saving the bundled archive in a separate file; 
dd bs=$UNPACKER_SIZE skip=1 if="$0" of="$TEMPORARY_ARCHIVE"

# extracting the archive
unzip "$TEMPORARY_ARCHIVE" -d "$DESTINATION_FOLDER"

# deleting the archive
rm -f "$TEMPORARY_ARCHIVE"

echo "Extraction successfully complete."

if [ -e "$BOOTSTRAP_FILE" ]; then
	echo
    echo "Launching installer bootstrap..."
	echo
	"$JRUBY_LAUNCHER" "$BOOTSTRAP_FILE" "$PAYLOAD_FOLDER"
	rm -f "$BOOTSTRAP_FILE"
	rm -rf "$JRUBY_FOLDER"
else
	echo
	echo "Bootstrap file not found; installation/upgrade will have to be manually performed."
	echo
fi

exit 0
