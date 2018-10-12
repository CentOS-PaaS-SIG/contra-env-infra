influxdb_json() {

    cat <<EOF
{
  "orgId": 1,
  "name": "influxdb",
  "type": "influxdb",
  "typeLogoUrl": "",
  "access": "proxy",
  "url": "${INFLUXDB_URL}",
  "password": "${INFLUXDB_PASSWORD}",
  "user": "${INFLUXDB_USER}",
  "database": "db0",
  "basicAuth": false,
  "basicAuthUser": "",
  "basicAuthPassword": "",
  "withCredentials": false,
  "isDefault": false,
  "jsonData": {
    "keepCookies": [],
    "tlsSkipVerify": true
  },
  "secureJsonFields": {},
  "version": 1,
  "readOnly": false
}
EOF
}

