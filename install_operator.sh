#!/bin/bash
flux bootstrap github \
--context=minikube \
--owner=${GITHUB_USER} \
--repository=kakfa-gitops \
--path=clusters/dev \
--branch=andrew \
--personal
kubectl create secret -n confluent docker-registry confluent-registry \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL && \
kubectl create secret -n flux-system generic https-credentials \
  --from-literal=username=$USER \
  --from-literal=password=$APIKEY


