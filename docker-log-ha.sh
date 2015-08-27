#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

LOGSTASH_SRC_DIR='/opt/logstash'
LOGSTASH_BINARY="${LOGSTASH_SRC_DIR}/logstash/bin/logstash"

LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"
LOGSTASH_LOG_DIR01='/var/log/logstash01'
LOGSTASH_LOG_DIR02='/var/log/logstash02'
LOGSTASH_LOG_FILE01="${LOGSTASH_LOG_DIR01}/logstash.log"
LOGSTASH_LOG_FILE02="${LOGSTASH_LOG_DIR02}/logstash.log"
tableName="$(echo 'logs_'${DOCKER_APP_NAME}'_'${DOCKER_NAMESPACE})"
data="{\"LoggingApplication\":{\"key\":\"LoggingApp\", \"tables\": {\"$tableName\": { \"fields\": {\"Timestamp\": {\"type\": \"timestamp\"},\"LogLevel\": {\"type\": \"text\"},\"Message\": {\"type\": \"text\"}, \"Source\": {\"type\": \"text\"}}}}}}"

function create_doradus_table() {
   curl -X POST -H "content-type: application/json" -u ${DOCKER_DORADUS_USER}:${DOCKER_DORADUS_PWD} -d "$data" ${DORADUS_HOST}:${DORADUS_PORT}/_applications
}

function logstash_start_agent01() {
    local binary="$LOGSTASH_BINARY"
    local config_path="$LOGSTASH_CONFIG_DIR/01_logstash.conf"
    local log_file="$LOGSTASH_LOG_FILE01"
 
    case "$1" in
    # run just the agent
    'agent')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --
        ;;
    # test the logstash configuration
    'configtest')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --configtest \
             --
        ;;
    esac
}

function logstash_start_agent02() {
    local binary="$LOGSTASH_BINARY"
    local config_path="$LOGSTASH_CONFIG_DIR/02_logstash.conf"
    local log_file="$LOGSTASH_LOG_FILE02"
 
    case "$1" in
    # run just the agent
    'agent')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --
        ;;
    # test the logstash configuration
    'configtest')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --configtest \
             --
        ;;
    esac
}

create_doradus_table

logstash_start_agent01 agent
logstash_start_agent02 agent
