#!/bin/bash
set -x

echo "Start rabbit node. Waiting network is up ..."
sleep 5

IFS='@'
tokens=($RABBITMQ_NODENAME)

echo ${tokens[*]}

RABBIT_HOST=${tokens[1]}


n=1
while [[ $(drill $RABBIT_HOST | grep $RABBIT_HOST | tail -n +2 | awk '{print $5}' | grep '^10.0' | wc -c) -eq 0 ]] && [[ $n -le 10 ]]
do
     n=$(( n+1 ))
     sleep 5
done


if [ $n -gt 10 ]; then
    echo "Problem to resolv IP for $RABBITMQ_NODENAME"
    exit 1
fi

IP_RESOLV=$(drill $RABBIT_HOST | grep $RABBIT_HOST | tail -n +2 | awk '{print $5}')


echo "Rabbit IP $IP_RESOLV for Rabbit nodename $RABBITMQ_NODENAME" 


if [ -z "$CLUSTER_WITH" ]; then
    sleep 15 && rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all", "ha-sync-mode": "automatic"}' &
else
    sleep 15 && rabbitmqctl stop_app && rabbitmqctl reset && rabbitmqctl join_cluster ${CLUSTER_WITH} && rabbitmqctl start_app &
fi

/docker-entrypoint.sh rabbitmq-serverdocker-entrypoint.sh rabbitmq-server