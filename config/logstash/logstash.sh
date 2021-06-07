#!/bin/sh

function find_logstash {
    cmd=$(which logstash)
    BIN=/usr/share/logstash/bin/logstash
    if [ -z "$cmd" ]; then
        if [ -f $BIN ]; then
            cmd=$BIN
        else
            echo "The logstash executable was not found" >&2
        fi
    fi
    echo $cmd
}

CMD=$(find_logstash)

$CMD -f $1 \
    --path.settings   /etc/logstash   \
    --path.logs       ./logs          \
    --path.data       ./data          \
    --log.level       debug           
    #--config.reload.automatic
