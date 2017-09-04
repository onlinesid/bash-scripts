#!/usr/bin/env bash

SCRIPT_ID=$1

LOCK_FILE_DIR="/lock/file/directory"

# Maximum number of minutes before the lock file will be deleted anyway
# to prevent the script stuck because lock file is never deleted for some reasons
MAX_MINUTES=10

# ensure lock file directory exists
mkdir -p $LOCK_FILE_DIR

# the lock file full path
LOCK_FILE="$LOCK_FILE_DIR/$SCRIPT_ID.lock"

# read the lock file to get the expiry date time
read -r LOCK_FILE_CONTENT < "$LOCK_FILE"

# check if we should delete the lock file anyway
if [[ -f $LOCK_FILE && "$LOCK_FILE_CONTENT" < $(date +%Y-%m-%dT%H:%M:%S) ]] ;
then
    echo "Lock file HAS expired ... delete it"
    rm -f $LOCK_FILE
else
    echo "Lock file has NOT expired"
fi

if [ -f $LOCK_FILE ]; then

    echo "Not processing because a lock file exists: $LOCK_FILE"

else

    # create a lock file with the expiry date time as the content of the file
    EXPIRES_TIME=$(date --date="$MAX_MINUTES minutes" +%Y-%m-%dT%H:%M:%S)
    echo "Creating a lock file: $LOCK_FILE"
    echo "$EXPIRES_TIME" > "$LOCK_FILE"

    # run your processing here...

    # delete lock file
    echo "Deleting a lock file: $LOCK_FILE"
    rm -f $LOCK_FILE

fi
