#!/usr/bin/env bash
set -E -e -o pipefail

prometheus_config="/data/prometheus/config/prometheus.yml"

set_umask() {
    # Configure umask to allow write permissions for the group by default
    # in addition to the owner.
    umask 0002
}

start_prometheus() {
    echo "Starting Prometheus ..."
    echo

    local config="${PROMETHEUS_CONFIG:-${prometheus_config:?}}"
    unset PROMETHEUS_CONFIG
    unset prometheus_config

    exec prometheus \
        --config.file ${config:?} \
        --storage.tsdb.path /data/prometheus/data \
        --web.console.libraries /data/prometheus/console_libraries \
        --web.console.templates /data/prometheus/consoles \
        "$@"
}

set_umask
start_prometheus "$@"
