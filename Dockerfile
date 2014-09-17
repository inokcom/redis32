###
#
# A simple image for installing the mongodb-mms-monitoring-agent
#
###
FROM phusion/baseimage:0.9.11

# Install using one RUN line to get around 42 AUFS layers limit.
RUN \
  echo "# Base" ;\
  apt-get update -qq ;\
  apt-get install -q -y build-essential python-dev python-setuptools wget ;\
  \
echo "# Install pymongo" ;\
  easy_install pymongo ;\
  \
echo "# Install MMS" ;\
  cd /opt ;\
  wget https://mms.mongodb.com/settings/mms-monitoring-agent.tar.gz --no-check-certificate ;\
  tar zxf mms-monitoring-agent.tar.gz ;\
  rm mms-monitoring-agent.tar.gz ;\
  \
echo "# Generate start script" ;\
  cd /usr/bin ;\
  echo '#!/bin/bash' > mms-agent ;\
  echo 'sed -i "s/@API_KEY@/$MMS_API_KEY/g" /opt/mms-agent/settings.py' >> mms-agent ;\
  echo 'sed -i "s/@SECRET_KEY@/$MMS_SECRET_KEY/g" /opt/mms-agent/settings.py' >> mms-agent ;\
  echo "python /opt/mms-agent/agent.py" >> mms-agent ;\
  chmod +x mms-agent ;\
  \
true
# END RUN

CMD ["mms-agent"]
