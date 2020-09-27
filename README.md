# Kafka Performance Tester

[![CircleCI](https://circleci.com/gh/rishabh96b/kafka-perf-test.svg?style=svg)](https://circleci.com/gh/rishabh96b/kafka-perf-test)

### Introduction ###
Kafka Performance Tester is a tool to load test your Kafka cluster. It uses Apache Kafka's inbuilt `kafka-producer-perf-test.sh` and `kafka-consumer-perf-test.sh` utilities and additional tools to make the test suit ready to roll.

### Requirements ###
- Docker
- A running Kafka cluster(With one or multiple brokers)

### Supported Platforms ###
Kafka Performance Tester can be used on any platform, thanks to Docker! Currently the standard configuration is created for DC/OS only which resides in `options.json`. In coming days, a standard deployable config for Kubernetes will also be added.

### Quick Start ###
Set the necessary environment variables.
- For DC/OS, set the parameters in `options.json`.
- For Kubernetes, use `deployment.yaml`
- For local system, set the vars manually inside the docker container using:
	- ```bash
		docker run -it rishabh96b/kafka-workload:latest bash
		export NUM_TOPICS=30
		export NUM_RECORDS=1024
		export RECORD_SIZE=50
		export PRODUCER_THROUGHPUT=10
		export TEST_INTERVAL_SECONDS=5
		export BOOTSTRAP_SERVERS="http://localhost:9092"
	```
To run Producer benchmarks:
```bash
./producer_test.sh
```
To run Consumer benchmarks:
```bash
./consumer_test.sh
```
