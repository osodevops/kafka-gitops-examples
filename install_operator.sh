#!/bin/bash
kubectl create namespace confluent
kubectl config set-context --current --namespace=confluent
kubectl create secret docker-registry confluent-registry \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL
helm repo add confluentinc_earlyaccess \
  https://confluent.jfrog.io/confluent/helm-early-access-operator-2 \
  --username $USER \
  --password $APIKEY
helm repo update
helm upgrade --install operator \
confluentinc_earlyaccess/confluent-for-kubernetes \
--set image.registry=confluent-docker-internal-early-access-operator-2.jfrog.io
