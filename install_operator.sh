#!/bin/bash
kubectl create namespace confluent
kubectl config set-context --current --namespace=confluent
kubectl create secret -n confluent docker-registry confluent-registry \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL
helm repo add confluentinc_earlyaccess \
  https://confluent.jfrog.io/confluent/helm-early-access-operator-2 \
  --username $USER \
  --password $APIKEY
helm repo update

# AKA /infrastructure/confluent/confluent-operators.yaml
#helm upgrade --install operator \
#confluentinc_earlyaccess/confluent-for-kubernetes \
#--set image.registry=confluent-docker-internal-early-access-operator-2.jfrog.io

# AKA /infrastructure/tools/openldap.yaml
#helm upgrade --install -f ./resources/openldap/ldaps-rbac.yaml test-ldap ./resources/openldap --namespace confluent