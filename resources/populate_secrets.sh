#!/bin/bash
kubectl create secret generic credential \
--from-file=plain-users.json=./users/creds-kafka-sasl-users.json \
--from-file=digest-users.json=./users/creds-zookeeper-sasl-digest-users.json \
--from-file=digest.txt=./users/creds-kafka-zookeeper-credentials.txt \
--from-file=plain.txt=./users/creds-client-kafka-sasl-user.txt \
--from-file=basic.txt=./users/creds-control-center-users.txt \
--from-file=ldap.txt=./users/ldap.txt
kubectl create secret generic mds-token \
--from-file=mdsPublicKey.pem=./certs/mds-publickey.txt \
--from-file=mdsTokenKeyPair.pem=./certs/mds-tokenkeypair.txt

# Kafka RBAC credential
kubectl create secret generic mds-client \
--from-file=bearer.txt=./users/bearer.txt
# Control Center RBAC credential
kubectl create secret generic c3-mds-client \
--from-file=bearer.txt=./users/c3-mds-client.txt
# Connect RBAC credential
kubectl create secret generic connect-mds-client \
--from-file=bearer.txt=./users/connect-mds-client.txt
# Schema Registry RBAC credential
kubectl create secret generic sr-mds-client \
--from-file=bearer.txt=./users/sr-mds-client.txt
# ksqlDB RBAC credential
kubectl create secret generic ksqldb-mds-client \
--from-file=bearer.txt=./users/ksqldb-mds-client.txt
# Kafka REST credential
kubectl create secret generic rest-credential \
--from-file=bearer.txt=./users/bearer.txt \
--from-file=basic.txt=./users/bearer.txt