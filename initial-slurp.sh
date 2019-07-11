#!/bin/bash

# Settings for the initial slurp
BEGINDATE=2019-01-01
ENDDATE=2019-07-01
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

# create temporary file
echo "" > /tmp/gxadmin-meta-import

# Slurp the data for every date...
d=$BEGINDATE
while [ "$d" != $ENDDATE ]; do
  # Slurp for that day
  gxadmin meta slurp-upto $d > /tmp/gxadmin-meta-import
  
  # Post it to InfluxDB
  gxadmin meta influx-post $INFLUXDBNAME /tmp/gxadmin-meta-import

  d=$(date -I -d "$d + 1 day")
done

# Get the current information
gxadmin meta slurp-current > /tmp/gxadmin-meta-import

# Post it to InfluxDB
gxadmin meta influx-post $INFLUXDBNAME /tmp/gxadmin-meta-import

# Remove the temporary file
rm /tmp/gxadmin-meta-import
