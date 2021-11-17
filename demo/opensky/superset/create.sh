#!/bin/sh

DIR=$(dirname $0)
cd $DIR

if ! [ -x "$(command -v jq)" ]; then
    echo ""
    echo "jq is not found, please install and make it available on your path, https://stedolan.github.io/jq"
    echo ""
    exit
fi

API_URL=http://localhost:28088/api/v1

#
# Payload needed to obtain a token that is required for additional operations
#
LOGIN='{ "password": "admin", "provider": "db", "refresh": true, "username": "admin" }'


TOKEN=$(curl -s -X POST -H "Content-Type:application/json"  --data "${LOGIN}"  ${API_URL}/security/login | jq -r ".access_token")

echo "TOKEN: ${TOKEN}"

#
# Payload to build the database connecto for Apache Druid.
# 
DATABASE_DRUID=$(cat <<EOF
{
  "allow_csv_upload": true,
  "allow_ctas": true, "allow_cvas": true,
  "allow_dml": true,
  "allow_multi_schema_metadata_fetch": true,
  "allow_run_async": true,
  "cache_timeout": 0,
  "configuration_method": "sqlalchemy_form",
  "database_name": "druid",
  "expose_in_sqllab": true, "impersonate_user": true,
  "parameters": {},
  "sqlalchemy_uri": "druid://druid-router:8888/druid/v2/sql"
}
EOF
)

DB_ID=$(curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "${DATABASE_DRUID}" ${API_URL}/database/ | jq -r ".id")

echo "DATABASE ID: $DB_ID"

#
# The Dataset for flight_summary from Druid
#
DATASET=$(cat <<EOF
{
 "database": $DB_ID,
  "schema": "druid",
  "table_name": "flight_summary"
}
EOF
)


DATASET_ID=$(curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "${DATASET}" ${API_URL}/dataset/ | jq -r ".id")

echo "DATASET ID: $DATASET_ID"

mkdir -p ./tmp

declare -a COUNTRIES=(usa canada india russia germany france uk china)

for country in ${COUNTRIES[@]}; do
  echo $country

  cat ./chart_country.json | sed "s/#COUNTRY#/${country}/g" | sed "s/#DATASOURCE_ID#/${DATASET_ID}/g" > ./tmp/chart_${country}.json

  curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "@./tmp/chart_${country}.json" ${API_URL}/chart/

done

