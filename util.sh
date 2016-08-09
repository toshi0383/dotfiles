#!/bin/bash
function checkStatus {
status=$?
if [ $status -ne 0 ];then
    echo "Encountered an error, aborting!" >&2
    echo $@
    exit $status
fi
}
