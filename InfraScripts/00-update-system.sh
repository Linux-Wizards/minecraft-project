#!/bin/bash

echo "--- Beginning an upgrade ---"
echo

yum -y upgrade --refresh

exit_code=$?
if [ $exit_code -ne 0 ]; then
    echo
    echo "--- Upgrade possibly failed! ---
    echo "--- Not rebooting            ---
    exit $exit_code
fi

echo
echo "--- Rebooting ---"
reboot

