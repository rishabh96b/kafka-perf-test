#!/usr/bin/env bash

./generate_endpoints.sh

while [[ true ]]
do
    for i in $(seq 1 $NUM_TOPICS)
    do
        bin/kafka-producer-perf-test.sh --producer.config config/producer.properties --print-metrics --throughput ${PRODUCER_THROUGHPUT} --num-records ${NUM_RECORDS} --topic "test_topic_${i}" --record-size ${RECORD_SIZE}
        sleep ${TEST_INTERVAL_SECONDS}
    done
done
