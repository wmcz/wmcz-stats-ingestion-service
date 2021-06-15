#!/bin/bash

set -e

FILE="$1"

if [ ! -f "$FILE" ]; then
	echo "File $FILE does not exist"
	exit 1
fi

# cd to the directory where this script is
scriptdir="`dirname \"$0\"`"
cd $scriptdir
curl -X 'POST' -H 'Content-Type:application/json' -d @"$FILE" http://wmcz-stats-druid01:8081/druid/indexer/v1/task
