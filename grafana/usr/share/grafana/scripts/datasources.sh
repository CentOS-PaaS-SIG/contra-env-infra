#!/bin/bash


influxdb_ds() {

  cat <<EOF
---

# config file version
apiVersion: 1

# list of datasources that should be deleted from the database
deleteDatasources:

# list of datasources to insert/update depending
# whats available in the database
datasources:
  # <string, required> name of the datasource. Required
- name: Influxdb
  # <string, required> datasource type. Required
  type: influxdb
  # <string, required> access mode. direct or proxy. Required
  access: proxy
  # <int> org id. will default to orgId 1 if not specified
  orgId: 1
  # <string> url
  url: $INFLUXDB_URL
  # <string> database password, if used
  password: $INFLUXDB_PASSWORD
  # <string> database user, if used
  user: $INFLUXDB_USER
  # <string> database name, if used
  database: db0
  # <bool> enable/disable basic auth
  basicAuth: false
  # <string> basic auth username
  basicAuthUser: 
  # <string> basic auth password
  basicAuthPassword:
  # <bool> enable/disable with credentials headers
  withCredentials:
  # <bool> mark as default datasource. Max one per org
  isDefault: true
  # <map> fields that will be converted to json and stored in json_data
  jsonData:
     tlsSkipVerify: true
     keepCookies: []
  # <string> json object of data that will be encrypted.
  version: 1
  # <bool> allow users to edit datasources from the UI.
  readOnly: false
EOF
}

