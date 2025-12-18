#!/bin/bash

source="postgres-connector"
sink="elastic-connector"

echo -e "DELETE EXISTING CONNECTORS"
curl -X DELETE http://localhost:8083/connectors/$source
echo ""
curl -X DELETE http://localhost:8083/connectors/$sink
echo ""

echo -e "CREATE SOURCE CONNECTOR"
curl -X POST http://localhost:8083/connectors \
  -H "Content-Type: application/json" \
  -d '{
    "name": "'"$source"'",
    "config": {
     "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
     "database.hostname": "postgres-source",
     "database.port": "5432",
     "database.user": "postgres",
     "database.password": "post",
     "database.dbname": "xyz_db",
     "plugin.name": "pgoutput",
     "slot.name": "debezium_slot",
     "publication.name": "dbz_publication",
     "topic.prefix": "topic",
     "table.include.list": "public.products",
     "key.converter": "org.apache.kafka.connect.json.JsonConverter",
     "value.converter": "org.apache.kafka.connect.json.JsonConverter",
     "transforms": "unwrap",
      "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState"

    }
  }'

echo -e "\n\nWAITING FOR SOURCE CONNECTOR TO INITIALIZE..."
sleep 10

echo "CREATE SINK CONNECTOR"
curl -X POST http://localhost:8083/connectors \
 -H "Content-Type: application/json" \
 -d '{
  "name": "'"$sink"'",
  "config": {
    "connector.class": "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector",
    "tasks.max": "1",
    "topics": "topic.public.products",
    "connection.url": "http://elasticsearch:9200",
    "type.name": "_doc",
    "key.ignore": "true",
    "schema.ignore": "true"
  }
 }'

echo -e "\n\nWAITING FOR SINK CONNECTOR TO INITIALIZE..."
sleep 10

echo -e "\n\n=== CONNECTORS STATUS ==="
echo "CHECKING '$source'..."
curl http://localhost:8083/connectors/$source/status

echo -e "\n\nCHECKING '$sink'..."
curl http://localhost:8083/connectors/$sink/status

echo -e "\n\nACCESS POINTS:"
echo "  - Kafka UI: http://localhost:8080"
echo "  - Kibana: http://localhost:5601"
echo "  - Kafka Connect: http://localhost:8083"
echo "  - Elasticsearch: http://localhost:9200"