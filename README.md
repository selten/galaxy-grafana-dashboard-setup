# Galaxy Monitoring with Grafana

## Requirements for Galaxy Monitoring with Grafana
*  InfluxDB
*  Grafana 
*  gxadmin 

## InfluxDB

### Setup InfluxDB
Download InfluxDB from https://portal.influxdata.com/downloads/, and install it according to their documentation.

### Configure InfluxDB

Open `/etc/influxdb/influxdb.conf` and go to the `[http]` section.
Then ensure the following:
*  `enabled` is set to `true`
*  `bind-address` is reachable for `gxadmin` (e.g. bound to external IP)
*  `auth-enabled` should be set to true (not mandatory, but recommended)
After making changes, restart InfluxDB.

### Prepare InfluxDB 
Run `influx` to access the InfluxDB if you didn't bind it to an external IP, otherwise use `influx -host [IP]`.
Create a database for your Galaxy instance using:
```
CREATE DATABASE [InfluxDB Galaxy database name];
```


Create a user specifically for this database using:
```
CREATE USER [Galaxy InfluxDB username] WITH PASSWORD '[Password here]';
```


For convenience, grant all permissions for your newly created user to the newly created database:
```
GRANT ALL ON [Galaxy InfluxDB username] TO [InfluxDB Galaxy database name];
```

## Grafana 

### Install Grafana
To install Grafana, follow the installation instructions for your specific OS specified on the Grafana documentation https://grafana.com/docs/installation/debian/.
Grafana will, in case of Ubuntu, automatically start listening on port 3000 on localhost.

### Configure Grafana
Grafana supports multiple authentication schemas. It is recommended to use one of these instead of the default credentials.
Further in the document we will assume that you use the default username and password combination (username `admin` and password `admin`).

## gxadmin

### Setup gxadmin

Download gxadmin as documented here: https://github.com/usegalaxy-eu/gxadmin. 

### Configure gxadmin
Ensure that the following environment variables are set:
*  `PGDATABASE`   
   This is the database name that you use for your Galaxy instance e.g. `galaxy`.
*  `PGHOST`   
   This is the hostname of the database server that you use for your Galaxy instance e.g. `localhost`.
*  `PGUSER`   
   This is the username for the database for your Galaxy instance e.g. `galaxy`.
*  `PGPASSWORD`   
   This is the password for the user e.g. `secretpassword`.
*  `INFLUX_URL`   
   This is the URL for InfluxDB, it is formatted like `[HOST/IP]:[PORT]` e.g. `127.0.0.1:8086`.
*  `INFLUX_PASS`   
   This is the password for the InfluxDB user e.g. `galaxy`.
*  `INFLUX_USER`   
   This is the InfluxDB username e.g. `anothersecret`.

## Import data into InfluxDB

1.  Query the Galaxy Database for information and export this to a file using `gxadmin meta slurp-current > /tmp/gxadmin-meta-slurp && gxadmin meta slurp-upto yyyy-mm-dd >> /tmp/gxadmin-meta-slurp`
2.  Import the data into InfluxDB using `gxadmin meta influx-post [InfluxDB Galaxy database name] /tmp/gxadmin-meta-slurp`

## Add your first Galaxy Dashboard to Grafana

1.  Login to Grafana.
2.  On the left hand side, open the settings cog to configure a data source.
3.  Add a new data source, select `InfluxDB` as the data source type.
4.  Configure the new data source.
    *  General
        *  Set the name of the new data source to `Galaxy Historical` (for compatilibity with dashboards created for `usegalaxy.eu`)
	*  HTTP
	   *  Set the URL to the URL of your InfluxDB e.g. `http://localhost:8086`
	*  InfluxDB Details
	   *  Set the name of the Database that you created.
	   *  Set the user to the username that you created for accessing the database.
	   *  Set the password to the password that you created for the user.
	Save and test the configuration. Your Grafana should now be able to connect to InfluxDB.
5.  On the left hand side, open the '+' and select 'Import'.
6.  Copy the JSON from https://github.com/usegalaxy-eu/grafana-dashboards/blob/master/Galaxy%20User%20Statistics.json
7.  Paste this into the `Or paste JSON` section and press 'Load'.
8.  The dashboard will now have been created. Please note that this dashboard is the one in use by `usegalaxy.eu`, so therefore adjustments might need to be made.
