FROM rabbitmq:3.6.6

RUN rabbitmq-plugins enable --offline rabbitmq_management

RUN apt-get update && apt-get install -y --no-install-recommends ldnsutils && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;

ADD rabbitmq-cluster-entrypoint.sh /
RUN chmod +x /rabbitmq-cluster-entrypoint.sh
ENTRYPOINT ["/rabbitmq-cluster-entrypoint.sh"]
CMD []
