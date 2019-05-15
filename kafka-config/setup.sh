export PATH=$PATH:/usr/local/bin

export BROKERS=$(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.cluster.brokers)
export  USERNAME=$(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.username)

export PASSWORD=$(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.password)
export  CA_CERT_URL=$(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.urls.ca_cert)

export TOKEN_URL=$(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.urls.token)

curl -s -o rootCA.crt $(echo $VCAP_SERVICES | jq -r .kafka[0].credentials.urls.ca_cert) 

export TOKEN=$(curl  -sS -X POST \
  $TOKEN_URL \
  -u $USERNAME:$PASSWORD \
  -H 'cache-control: no-cache' \
  -H 'charset: utf-8' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -d grant_type=client_credentials | jq -r .access_token) 

bold=$(tput bold)
normal=$(tput sgr0)

echo "You can now use kafkacat. Sample below will ${bold}list all topics${normal}"

echo "${bold}kafkacat -b \$BROKERS -C -X security.protocol=SASL_SSL -X sasl.mechanism=PLAIN -X sasl.username=\$USERNAME -X sasl.password=\$TOKEN -X ssl.ca.location=rootCA.crt -L${normal}"

echo "The following will ${bold}list all the messages from the topic${normal} ddaccad0-9072-4b1e-ac0e-59b82f7a989f.com.sap.dsc.ac.equipment" 

echo "${bold}kafkacat -b \$BROKERS -C -X security.protocol=SASL_SSL -X sasl.mechanism=PLAIN -X sasl.username=\$USERNAME -X sasl.password=\$TOKEN -X ssl.ca.location=rootCA.crt -o begining -t ddaccad0-9072-4b1e-ac0e-59b82f7a989f.com.sap.dsc.ac.equipment${normal}"

echo "Read the last message from the Topic" 

echo "${bold}kafkacat -b \$BROKERS -C -X security.protocol=SASL_SSL -X sasl.mechanism=PLAIN -X sasl.username=\$USERNAME -X sasl.password=\$TOKEN -X ssl.ca.location=rootCA.crt -p 0 -o -1 -t ddaccad0-9072-4b1e-ac0e-59b82f7a989f.com.sap.dsc.ac.equipment${normal}"

echo "kafkacat documentation can be found at  ${bold}https://github.com/edenhill/kafkacat${normal}"



