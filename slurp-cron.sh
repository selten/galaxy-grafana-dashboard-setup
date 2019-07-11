#!/bin/bash

# Settings for the initial slurp
INFLUXDBNAME=""
PGDATABASE=""
PGHOST=""
PGUSER=""
PGPASSWORD=""
INFLUX_URL=""
INFLUX_PASS=""
INFLUX_USER=""

# Settings for gxadmin
PATH=$PATH:~/gxadmin/

TMPFILE=/tmp/gxadmin-meta-cron-slurp

# create temporary file
echo "" > $TMPFILE

# Slurp the data from yesterday
gxadmin meta slurp-upto `date -I --set='-1 day'` >> $TMPFILE

# Get the current information
gxadmin meta slurp-current >> $TMPFILE

# Post it to InfluxDB
gxadmin meta influx-post $INFLUXDBNAME $TMPFILE

# Remove the temporary file
rm $TMPFILE
