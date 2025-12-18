# Capturing data from PostgreSQL to ElasticSearch

## What is ElasticSearch?

## Why we need to stream data to ElasticSearch?

## How can we implement?

### Services needed

- PostgreSQL
- Kafka broker - cluster
- Kafka Connect (Debezium)
- ElasticSearch
- Kafka-UI (optional)
- Kibana (optional) (ElasticSearch UI)

### Steps

1. Deploy database PostgreSQL and Setting Up

   ```yml
   postgres-source:
     image: postgres:17.5-bullseye
     container_name: postgres-source
     environment:
     POSTGRES_USER: postgres
     POSTGRES_PASSWORD: post
     POSTGRES_DB: xyz_db
     command: # Allow debezium to read the logs of PostgreSQL
       - "postgres"
       - "-c"
       - "wal_level=logical"
     ports:
       - "5168:5432"
     volumes:
       - ./init_scripts/init.sql:/docker-entrypoint-initdb.d/postgres_init.sql
       - itp-postgres-vol:/var/lib/postgresql/data
     networks:
       - itp-debezium-net
   ```

2. Deploy kafka single node or cluster

   ```yml
   broker:
     image: confluentinc/cp-kafka:latest
     container_name: broker
     ports:
       - "9092:9092"
       - "9093:9093"
     environment:
     KAFKA_NODE_ID: 1
     KAFKA_PROCESS_ROLES: broker,controller

     KAFKA_LISTENERS: PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093
     KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://broker:9092

     KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
     KAFKA_CONTROLLER_QUORUM_VOTERS: 1@broker:9093

     KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT
     KAFKA_BROKER_LISTENER_NAME: PLAINTEXT

     CLUSTER_ID: 3FpJ2yElQ5--5AbkUE6GlQ

     KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
     KAFKA_TRANSACTION_STATE_LOG_MIN_ISR: 1
     KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR: 1

     KAFKA_LOG_DIRS: /var/lib/kafka/data
     volumes:
       - kafka-data:/var/lib/kafka/data
     networks:
       - itp-debezium-net
   ```

3.
