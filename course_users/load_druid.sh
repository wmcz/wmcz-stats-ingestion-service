#!/bin/bash

set -e

# cd to the directory where this script is
scriptdir="`dirname \"$0\"`"
cd $scriptdir

curl -X 'POST' -H 'Content-Type:application/json' -d @druid_spec.json http://wmcz-stats-druid01:8081/druid/indexer/v1/task
echo
