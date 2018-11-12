#!/bin/bash

function usage()
{
	echo "$(basename "$0") input.xmi namespace outputFolder"
	echo "   namespace: e.g. tsd/bt/handsfree/status/call/stm"
	exit 1
}

if [ ! $# -eq 3 ]; then
	usage
fi

java -jar /home/user/jpcc/tools/stmgen/tsd.common.tools.stmgen/lib/tsd.common.tools.stmgen.jar \
    -overview \
    -show-error-location \
    -name="${2}" \
    -import-format=sparxea \
    -i="${1}" \
    -o="${3}" \
    -generateEnumToStringMethods
