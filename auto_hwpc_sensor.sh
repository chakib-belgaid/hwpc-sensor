#!/bin/bash

# This script is used to automatically generate the config file for hwpc-sensor based on the CPU model.
get_events() {

    declare -A cpu_model_event_map=(
        ["Skylake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Whiskey Lake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Coffe Lake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Sandy Bridge"]="CPU_CLK_UNHALTED:REF_P, CPU_CLK_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Comet Lake"]="CPU_CLK_UNHALTED:REF_P, CPU_CLK_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Broadwell"]="CPU_CLK_UNHALTED:REF_P, CPU_CLK_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["AMD"]='CYCLES_NOT_IN_HALT, RETIRED_INSTRUCTIONS, RETIRED_UOPS '
    )
    logs=$(hwpc-sensor)
    logs=${logs,,}
    if [[ $logs == *"amd"* ]]; then
        cpu_model="AMD"
    elif [[ $logs == *"skylake"* ]]; then
        cpu_model="Skylake"
    elif [[ $logs == *"whiskey lake"* ]]; then
        cpu_model="Whiskey Lake"
    elif [[ $logs == *"coffee lake"* ]]; then
        cpu_model="Coffee Lake"
    elif [[ $logs == *"sandy bridge"* ]]; then
        cpu_model="Sandy Bridge"
    elif [[ $logs == *"comet lake"* ]]; then
        cpu_model="Comet Lake"
    elif [[ $logs == *"Broadwell"* ]]; then
        cpu_model="Broadwell"
    else
        echo "Unknown CPU family"
        exit 1
    fi

    events=${cpu_model_event_map[$cpu_model]}
    echo $events
}

function events_to_json() {
    local events=$@
    echo $events | tr -d '\n' | tr -d ' ' | awk -v RS="," 'BEGIN{print "    \"container\": {\n        \"core\": {\n            \"events\": ["} {if (NR > 1) printf ","; printf "\n                \"" $0 "\""} END { printf "\n            ]\n        }\n    }\n"}'
}

update_config_file() {
    events=$(get_events)
    config_file=$1

    # Create a backup of the config file
    cp "$config_file" "$config_file.bak"

    # Remove the last } from the config file
    sed -i '$ d' "$config_file.bak"

    # Replace the last } with }, in the config file
    sed -i '$ s/$/,/' "$config_file.bak"

    # Add the events to the config file
    events_to_json "$events" >>"$config_file.bak"

    # Add the last } to the config file
    echo "}" >>"$config_file.bak"

}

update_config_file $1
hwpc-sensor --config-file $1.bak
