#!/bin/bash

# Settings for the initial slurp
export INFLUXDBNAME=""
export PGDATABASE=""
export PGHOST=""
export PGUSER=""
export PGPASSWORD=""
export INFLUX_URL=""
export INFLUX_PASS=""
export INFLUX_USER=""

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
