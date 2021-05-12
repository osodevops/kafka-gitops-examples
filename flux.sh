#!/bin/bash
1


flux bootstrap github \
--context=minikube \
--owner=${GITHUB_USER} \
--repository=kakfa-gitops \
--path=clusters/dev
--branch=main \
--personal \
