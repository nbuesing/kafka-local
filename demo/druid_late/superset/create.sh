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

###########
#
# database
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
if [ "${DB_ID}" == "null" ]; then
  echo "database may already exist, using value of 1"
  DB_ID=1
fi
echo "DATABASE ID: $DB_ID"



##########
#
# dataset
#
DATASET=$(cat <<EOF
{
 "database": $DB_ID,
  "schema": "druid",
  "table_name": "orders"
}
EOF
)

DATASET_ID=$(curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "${DATASET}" ${API_URL}/dataset/ | jq -r ".id")
if [ "${DATASET_ID}" == "null" ]; then
  echo "dataset may already exist, using value of 1"
  DB_ID=1
fi
echo "DATASET ID: $DATASET_ID"



##########
#
# dataset
#
DATASET=$(cat <<EOF
{
 "database": $DB_ID,
  "schema": "druid",
  "table_name": "skus"
}
EOF
)

DATASET_ID=$(curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "${DATASET}" ${API_URL}/dataset/ | jq -r ".id")
if [ "${DATASET_ID}" == "null" ]; then
  echo "dataset may already exist, using value of 2"
  DB_ID=2
fi
echo "DATASET ID: $DATASET_ID"



########
#
# chart
#

#curl -s -X POST -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" --data "@./chart.json" ${API_URL}/chart/ 

curl -s -X GET -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" ${API_URL}/chart/3
