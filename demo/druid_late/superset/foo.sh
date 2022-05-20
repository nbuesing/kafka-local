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
#LOGIN='{ "password": "admin", "provider": "db", "refresh": true, "username": "aaa" }'
LOGIN='{ "password": "admin", "provider": "chart", "refresh": true, "username": "admin" }'


TOKEN=$(curl -s -X POST -H "Content-Type:application/json"  --data "${LOGIN}"  ${API_URL}/security/login | jq -r ".access_token")

#echo "TOKEN: ${TOKEN}"
#echo $1

#curl -s -X GET -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" -H "Accept:application/json" ${API_URL}/dataset/$1
#curl -s -X PUT -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" -H "Accept:application/json" --data "{\"cache_timeout\": 0}" ${API_URL}/chart/$1


#curl -s -X GET ${API_URL}/chart/$1

curl -s -X GET -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" -H "Accept:application/json"  "${API_URL}/chart/1"

#curl -s -X GET -H "Authorization:Bearer ${TOKEN}" -H "Content-Type:application/json" -H "Accept:application/json" -H "Cookie: ai_user=q7h0OlJQ7x5MRACeZnmoG2|2022-02-21T17:11:01.204Z; session=.eJyFkMFqxDAMRP9F54Alx4ll_0opQbblZiE0S-w9lNJ_r9u9t-g06Glm0Cds9dK2Q-zXQyfYbgUiSEhSK6Ij9ujUkYrM3lOVmlOmErzzTGvyY0GOnFOcLVtGsSETJlLl5BgXwbVWzRqKekaXrOUg6xhZHbIkmhebayBKQoRahuWSgsAEx5nl0NFF34e6y5tu-6318_qA-AJ77_dozC-0n63Hkc1sHk2vZo7BmXH0JySl_Ic8fV4n-JHPxxB8fQNneF2t.YoZxdw.aYfHHfiNogQH3uka35DI_xUlj2w" "${API_URL}/chart/?q=(filters:!((col:owners,opr:rel_m_m,value:1)),order_column:changed_on_delta_humanized,order_direction:desc,page:0,page_size:25)"
