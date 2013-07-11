#!/bin/sh

cd ~/icinga_notifier

running_host="mcl@dirt"
error_url="http://localhost:8080/icinga/cgi-bin/status.cgi?host=all&type=detail&servicestatustypes=16&jsonoutput"
warn_url="http://localhost:8080/icinga/cgi-bin/status.cgi?host=all&type=detail&servicestatustypes=4&jsonoutput"

error_out="status-error.json"
warn_out="status-warn.json"

host="root@172.16.45.6"
user_pass="icingaadmin:icingaadmin"

ssh -N -L 8080:localhost:80 $host &
ssh_pid=$!
sleep 2

curl -s -u $user_pass -X GET -o $error_out $error_url 
curl -s -u $user_pass -X GET -o $warn_out $warn_url 

kill $ssh_pid

error_msg=`./notifier.py $error_out`
warn_msg=`./notifier.py $warn_out`


if [ "$error_msg" != "" -o "$warn_msg" != "" ]; then

echo "
ERRORS:
$error_msg

WARNINGS:
$warn_msg

--
I'm self-aware script checking Icinga server on host $host
I'm being run from host $running_host via cron " | mail -s "Icinga alerts for host $host" address@email

fi

