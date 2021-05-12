#!/bin/bash
flux bootstrap github \
--context=minikube \
--owner=${GITHUB_USER} \
--repository=kakfa-gitops \
--path=clusters/dev
--branch=andrew \
--personal \
