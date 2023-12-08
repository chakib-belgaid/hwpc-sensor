#!/bin/bash

config_file=$1

get_events() {
    declare -A cpu_family_codename_map=(
        ["6"]="Skylake"
        ["7"]="Whiskey Lake"
        ["8"]="Coffee Lake"
        ["42"]="Sandy Bridge"
        ["10"]="Comet Lake"
    )

    declare -A cpu_model_event_map=(
        ["Skylake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        [" Whiskey Lake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Coffe Lake"]="CPU_CLK_THREAD_UNHALTED:REF_P, CPU_CLK_THREAD_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Intel Sandy Bridge"]="CPU_CLK_UNHALTED:REF_P, CPU_CLK_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["Comet Lake"]="CPU_CLK_UNHALTED:REF_P, CPU_CLK_UNHALTED:THREAD_P, LLC_MISSES,INSTRUCTIONS_RETIRED"
        ["AMD"]='CYCLES_NOT_IN_HALT, RETIRED_INSTRUCTIONS, RETIRED_UOPS '
    )

    cpu_family=$(cat /proc/cpuinfo  | grep "vendor_id" | awk '{print $3}' | head -n 1)
    if [ "$cpu_family" == "GenuineIntel" ]; then
        cpu_family=$(lscpu | grep "cpu family" | awk '{print $3}' | head -n 1)
        cpu_model=${cpu_family_codename_map[$cpu_family]}
    elif [ "$cpu_family" == "AuthenticAMD" ]; then
        cpu_model="AMD"
    else
        echo "Unknown CPU family"
        exit 1
    fi
        events=${cpu_model_event_map[$cpu_model]}
        echo $events
}

function events_to_json() {
    local events=$@
    echo $events | tr -d '\n' |tr -d ' ' |  awk -v RS="," 'BEGIN{print "    \"container\": {\n        \"core\": {\n            \"events\": ["} {if (NR > 1) printf ","; printf "\n                \"" $0 "\""} END { printf "\n            ]\n        }\n    }\n"}'
}

events=`get_events`
sed -i '$ d' $config_file
echo "," >> $config_file
events_to_json $events >> $config_file
echo "}" >> $config_file


hwpc-sensor --config-file $config_file