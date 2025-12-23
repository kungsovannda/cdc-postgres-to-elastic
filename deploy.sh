#!/bin/bash

source="postgres-connector"
sink="elastic-connector"

echo -e "DELETE EXISTING CONNECTORS"
curl -X DELETE http://localhost:8083/connectors/$source
echo ""
curl -X DELETE http://localhost:8083/connectors/$sink
echo ""

echo -e "CREATE SOURCE CONNECTOR"
curl -X PUT http://localhost:8083/connectors/$source/config \
  -H "Content-Type: application/json" \
  -d '@./connectors/postgres.json'
echo -e "\n\nWAITING FOR SOURCE CONNECTOR TO INITIALIZE..."
sleep 10

echo "CREATE SINK CONNECTOR"
curl -X PUT http://localhost:8083/connectors/$sink/config \
 -H "Content-Type: application/json" \
 -d '@./connectors/elastic.json'

echo -e "\n\nWAITING FOR SINK CONNECTOR TO INITIALIZE..."
sleep 10

echo -e "\n\n=== CONNECTORS STATUS ==="
echo "CHECKING '$source'..."
curl http://localhost:8083/connectors/$source/status

echo -e "\n\nCHECKING '$sink'..."
curl http://localhost:8083/connectors/$sink/status
