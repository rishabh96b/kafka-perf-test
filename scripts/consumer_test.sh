#!/usr/bin/env bash



./generate_endpoints.sh

while [[ true ]]
do
    for i in $(seq 1 ${NUM_TOPICS})
    do
        bin/kafka-consumer-perf-test.sh --broker-list ${BOOTSTRAP_SERVERS} --topic "test_topic_${i}" --messages ${NUM_RECORDS}
        sleep ${TEST_INTERVAL_SECONDS}
    done
done
