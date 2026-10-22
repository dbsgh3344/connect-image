# Strimzi KafkaConnect 이미지: Stream Reactor MQTT source + Confluent Avro 컨버터.
ARG STRIMZI_BASE=quay.io/strimzi/kafka:1.3.0-kafka-4.3.1

FROM alpine:3.22 AS plugins
ARG MQTT_VERSION=12.1.2
ARG MQTT_SHA256=98db0b23f728767211db26b4b8507c46b97be074a049eba6028bdedb9305f140
ARG AVRO_VERSION=8.3.2
ARG AVRO_SHA256=f849f49ae500d1c02f94a50d1dd4b3e63d26433843007ac114a7f8e9fb3d6be8
RUN apk add --no-cache curl unzip
WORKDIR /plugins
RUN curl -fsSL -o mqtt.zip "https://github.com/lensesio/stream-reactor/releases/download/${MQTT_VERSION}/kafka-connect-mqtt-${MQTT_VERSION}.zip" \
 && echo "${MQTT_SHA256}  mqtt.zip" | sha256sum -c - \
 && unzip -q mqtt.zip -d out && rm mqtt.zip
RUN curl -fsSL -o avro.zip "https://hub-downloads.confluent.io/api/plugins/confluentinc/kafka-connect-avro-converter/versions/${AVRO_VERSION}/confluentinc-kafka-connect-avro-converter-${AVRO_VERSION}.zip" \
 && echo "${AVRO_SHA256}  avro.zip" | sha256sum -c - \
 && unzip -q avro.zip -d out && rm avro.zip

FROM ${STRIMZI_BASE}
USER root:root
COPY --from=plugins /plugins/out/ /opt/kafka/plugins/
USER 1001
