FROM anapsix/alpine-java 

ADD mosquitto-exporter-1.0.jar /app.jar
ADD run.sh /run.sh

EXPOSE 9180

CMD [ "/run.sh"]

