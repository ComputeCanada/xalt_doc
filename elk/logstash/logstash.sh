#!/bin/sh

logstash -f $1 \
    --path.settings   /etc/logstash   \
    --path.logs       ./logs          \
    --path.data       ./data          \
    --log.level       debug           \
    --config.reload.automatic
