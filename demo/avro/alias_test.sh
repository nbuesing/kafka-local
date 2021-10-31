#!/bin/sh

TOPIC=test

value_v1_schema=$(cat <<EOF
{
  "type": "record",
  "name": "$TOPIC",
  "fields": [
    {
      "name": "name",
      "type": "string",
      "default": ""
    }
  ]
}
EOF
)

value_v2_schema=$(cat <<EOF
{
  "type": "record",
  "name": "$TOPIC",
  "fields": [
    {
      "name": "name",
      "alias": "firstName",
      "type": "string",
      "default": ""
    }
  ]
}
EOF
)

value_v3_schema=$(cat <<EOF
{
  "type": "record",
  "name": "$TOPIC",
  "fields": [
    {
      "name": "name",
      "alias": "first_name",
      "type": "string",
      "default": ""
    }
  ]
}
EOF
)

PAYLOAD=$(cat <<EOF
{"name":"john"}
EOF
)

curl -X PUT http://localhost:8081/config -d '{"compatibility": "FULL_TRANSITIVE"}' -H "Content-Type:application/json"
echo ""

echo $PAYLOAD |
kafka-avro-console-producer \
	--broker-list localhost:19092 \
	--property schema.registry.url="http://localhost:8081" \
	--topic $TOPIC \
	--property value.schema="${value_v1_schema}" 


echo $PAYLOAD |
kafka-avro-console-producer \
	--broker-list localhost:19092 \
	--property schema.registry.url="http://localhost:8081" \
	--topic $TOPIC \
	--property value.schema="${value_v2_schema}" 

echo $PAYLOAD |
kafka-avro-console-producer \
	--broker-list localhost:19092 \
	--property schema.registry.url="http://localhost:8081" \
	--topic $TOPIC \
	--property value.schema="${value_v3_schema}" 

kafka-console-consumer \
	--bootstrap-server localhost:19092 \
	--value-deserializer=org.apache.kafka.common.serialization.BytesDeserializer  \
	--from-beginning \
	--topic $TOPIC
