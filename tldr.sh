#!/bin/bash
flux bootstrap github \
--context=minikube \
--owner=${GITHUB_USER} \
--repository=kakfa-gitops \
--path=clusters/dev \
--branch=andrew \
--personal
sleep 10
echo "Sleeping for 10 seconds to ensure namespace is created"
kubectl create secret -n confluent docker-registry confluent-registry \
--docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
--docker-username=$USER \
--docker-password=$APIKEY \
--docker-email=$EMAIL && \
kubectl create secret -n flux-system generic https-credentials \
--from-literal=username=$USER \
--from-literal=password=$APIKEY
kubectl create secret -n confluent generic credential \
--from-file=plain-users.json=./resources/users/creds-kafka-sasl-users.json \
--from-file=digest-users.json=./resources/users/creds-zookeeper-sasl-digest-users.json \
--from-file=digest.txt=./resources/users/creds-kafka-zookeeper-credentials.txt \
--from-file=plain.txt=./resources/users/creds-client-kafka-sasl-user.txt \
--from-file=basic.txt=./resources/users/creds-control-center-users.txt \
--from-file=ldap.txt=./resources/users/ldap.txt
kubectl create secret -n confluent generic mds-token \
--from-file=mdsPublicKey.pem=./resources/certs/mds-publickey.txt \
--from-file=mdsTokenKeyPair.pem=./resources/certs/mds-tokenkeypair.txt
# Kafka RBAC credential
kubectl create secret -n confluent generic mds-client \
--from-file=bearer.txt=./resources/users/bearer.txt
# Control Center RBAC credential
kubectl create secret -n confluent generic c3-mds-client \
--from-file=bearer.txt=./resources/users/c3-mds-client.txt
# Connect RBAC credential
kubectl create secret -n confluent generic connect-mds-client \
--from-file=bearer.txt=./resources/users/connect-mds-client.txt
# Schema Registry RBAC credential
kubectl create secret -n confluent generic sr-mds-client \
--from-file=bearer.txt=./resources/users/sr-mds-client.txt
# ksqlDB RBAC credential
kubectl create secret -n confluent generic ksqldb-mds-client \
--from-file=bearer.txt=./resources/users/ksqldb-mds-client.txt
# Kafka REST credential
kubectl create secret -n confluent generic rest-credential \
--from-file=bearer.txt=./resources/users/bearer.txt \
--from-file=basic.txt=./resources/users/bearer.txt