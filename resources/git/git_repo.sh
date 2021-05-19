#!/bin/bash
kubectl create secret -n flux-system generic flux-system  \
--from-file=identity=./identity \
--from-file=identity.pub=./identity.pub \
--from-file=known_hosts=./known_hosts \
--dry-run=client --output=yaml > ./sensitive-git-flux-secrets.yaml
kubectl apply -f sensitive-git-flux-secrets.yaml