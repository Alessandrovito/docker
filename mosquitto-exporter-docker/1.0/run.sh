#!/bin/bash
set -e

JAVA_OPTS="-Dlogging.level.com.vitale.exporter.mosquitto=DEBUG -Dmosquitto.exporter.account.username=${MOSQUITTO_USER:-mosquitto} -Dmosquitto.exporter.account.password=${MOSQUITTO_PASSWORD:-pwmosquitto} -Dmosquitto.exporter.broker.name=${MOSQUITTO_HOSTNAME:-mosquitto}"

java $JAVA_OPTS -jar /app.jar
