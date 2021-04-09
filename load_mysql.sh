#!/bin/bash

set -e

# cd to the directory where this script is
scriptdir="`dirname \"$0\"`"
cd $scriptdir

# Init environment.
# This is likely to change when the data pipeline is reviewed by Analytics team, and moved to analytics.wikimedia.org
. ./env
BASE_URL="https://people.wikimedia.org/~urbanecm/wmcz/dashboard-stats-data"
TMPDIR=/tmp/$$

# mysql helper
my_mysql() {
	mysql --defaults-extra-file="$DB_DEFAULTS" -h "$DB_HOST" "$DB_NAME"
}

# init temp dir
mkdir $TMPDIR
echo $TMPDIR

tables="wmcz_outreach_dashboard_courses_csv wmcz_outreach_dashboard_courses_users wmcz_outreach_dashboard_edits"

for table in $tables; do
	echo "DROP TABLE IF EXISTS $table" | my_mysql
	curl -s "$BASE_URL/schema/$table.hql" | grep -v -e 'ROW FORMAT' -e 'FIELDS TERMINATED' -e 'COLLECTION ITEMS' -e 'STORED AS' -e 'LOCATION' | sed 's/^)$/);/g' | sed 's/array<string>/VARCHAR(255)/g;s/string/VARCHAR(255)/g' | my_mysql
	curl -s $BASE_URL/$table.txt > $TMPDIR/$table.tsv
	echo "LOAD DATA LOCAL INFILE '$TMPDIR/$table.tsv' INTO TABLE $table FIELDS TERMINATED BY \"\t\" IGNORE 1 LINES;" | my_mysql
done

# clean tmpdir
rm -rf $TMPDIR
