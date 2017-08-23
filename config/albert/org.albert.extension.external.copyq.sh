#!/bin/bash

## Exit on error, var unset and pipefail
set -e -o pipefail -o nounset

send_metadata() {
    local metadata

    metadata='{
    "iid":"org.albert.extension.external/v2.0",
    "name":"Clipboard Manager",
    "version":"1.3",
    "author":"BarbUk",
    "dependencies":["copyq"],
    "trigger":"cq "
}'
    echo -n "${metadata}"
}

## get a row from copyq history stack
copyq_get_row() {
    local copyq_row
    local count="$1"

    ## I take just the first line, in case there is a block of text
    copyq_row="$(copyq read text/plain "$count" | head -1 | sed -e 's/^[[:space:]]*//')"

    # clean from non compatible json char
    printf -v clean_copyq_row "%q" "$copyq_row"
    echo -n "$clean_copyq_row"
}

## Build json object for albert query
build_json() {
    local count="$1"
    shift 1
    local row="$*"

    read -r -d '' json << EOM
{
    "name": "$row",
    "icon": "copyq-normal",
    "description": "$count",
    "actions": [{
        "name": "copy $row to clipboard",
        "command": "copyq",
        "arguments": ["select($count); sleep(50); paste()"]
    }]
},
EOM

    echo -n "$json"
}

build_albert_query() {
    local count="$1"
    local return='{"items":['
    local json=''
    local row

    ## If the query is a number, just get that row from
    ## copyq history stack
    if [[ $count =~ ^-?[0-9]+$ ]]; then
        row=$(copyq_get_row "$count")
        json=$(build_json "$count" "$row")
    else
        ## else get the last 15
        for count in {0..14}; do
            row=$(copyq_get_row "$count")
            if [[ "$row" == "''" ]]; then
                continue
            fi
            new=$(build_json "$count" "$row")

            json="$json$new"
        done
    fi

    # remove last comma
    json=${json::-1}

    return="$return$json]}"
    echo -n "$return"
}

main() {
    case $ALBERT_OP in
        "METADATA")
            send_metadata
            exit 0
        ;;

        "QUERY")
            ALBERT_QUERY=${ALBERT_QUERY:-}
            QUERYSTRING="${ALBERT_QUERY:3}"
            build_albert_query "$QUERYSTRING"
            exit 0
        ;;
        "INITIALIZE")
            if ! which copyq >/dev/null 2>&1; then
                echo "You need to install copyq" >&2
                exit 1
            fi

            exit 0
        ;;
        "FINALIZE")
            exit 0
        ;;
        "SETUPSESSION")
            exit 0
        ;;
        "TEARDOWNSESSION")
            exit 0
        ;;
    esac
}

## Call the main function
main

