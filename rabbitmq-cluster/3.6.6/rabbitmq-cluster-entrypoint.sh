#!/bin/bash
set -x

echo "Start rabbit node. Waiting network is up ..."
sleep 5


RABBIT_HOST=`echo $RABBITMQ_NODENAME | cut -d'@' -f 2`

if [ -z "$RABBIT_HOST" ]; then
    echo "Wrong $RABBITMQ_NODENAME"
    exit 1
fi

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


setup_cluster() {
	

	if [ -z "$CLUSTER_WITH" ]; then
		echo "Setup single node ${RABBITMQ_NODENAME} in High Availability"
		rabbitmqctl wait /var/lib/rabbitmq/mnesia/$RABBITMQ_NODENAME.pid && sleep 10 && \
		rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all", "ha-sync-mode": "automatic"}' &
		
	else
		echo "Setup Cluster with $CLUSTER_WITH for node ${RABBITMQ_NODENAME}"
		rabbitmqctl wait /var/lib/rabbitmq/mnesia/$RABBITMQ_NODENAME.pid && sleep 10 && \
		rabbitmqctl stop_app && \
		rabbitmqctl join_cluster ${CLUSTER_WITH} && \
		rabbitmqctl start_app &
	fi
}

setup_cluster

# run rabbitmq-server
/docker-entrypoint.sh rabbitmq-server



