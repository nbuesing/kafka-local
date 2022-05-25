#!/bin/sh

API_URL=http://localhost:28088/api/v1

LOGIN='{ "password": "admin", "provider": "db", "refresh": true, "username": "admin" }'
TOKEN=$(curl -s -X POST -H "Content-Type:application/json"  --data "${LOGIN}"  ${API_URL}/security/login | jq -r ".access_token")

echo "TOKEN: ${TOKEN}"


curl -s -X GET -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" -H "Accept:application/json"  "${API_URL}/chart/" | jq -r ".result"

