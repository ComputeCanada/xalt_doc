#!/bin/sh

DEFAULT_CONFIG=xalt.conf
DEBUG=no

# Find the logstash command to run
function find_logstash {
    cmd=$(which logstash 2> /dev/null)
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

CONFIG=$1

# Check if config file has been specified
if [ -z "$1" ]; then
    >&2 echo "No config file was specified. Using default ($DEFAULT_CONFIG)."
    CONFIG=$DEFAULT_CONFIG
fi

CMD=$(find_logstash)

args="       --path.settings	/etc/logstash"
args+="$args --path.logs	./logs"
args+="$args --path.data	./data"

if [ "$DEBUG" == "yes" ]; then
    args+="$args --log.level 	debug"
fi

$CMD -f $CONFIG $args
    #--config.reload.automatic
