###
#
# A simple image for installing the mongodb-mms-monitoring-agent
#
###
FROM phusion/baseimage:0.9.11

####
# Install prequisites + cleanup
RUN apt-get update && apt-get install -y curl logrotate && \
	apt-get clean && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

ADD configure.sh /

####
# Install Agent itself
RUN curl -sSL https://mms.mongodb.com/download/agent/monitoring/mongodb-mms-monitoring-agent_latest_amd64.deb -o mms.deb && \
	dpkg -i mms.deb && \
   	rm mms.deb

####
# Make sure the app is configured correctly
ENTRYPOINT ["/configure.sh"]
USER mongodb-mms-agent

CMD ["mongodb-mms-monitoring-agent", "-conf", "/etc/mongodb-mms/monitoring-agent.config"]
