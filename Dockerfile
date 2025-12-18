FROM quay.io/debezium/connect:2.6

USER root

ENV PLUGIN_PATH=/kafka/connect
ENV ES_PLUGIN_PATH=${PLUGIN_PATH}/debezium-connect-elasticsearch

RUN mkdir -p ${PLUGIN_PATH}

RUN mkdir ${ES_PLUGIN_PATH}
COPY ./confluentinc-kafka-connect-elasticsearch-15.1.0/lib/ ${ES_PLUGIN_PATH}