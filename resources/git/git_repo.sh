#!/bin/bash
kubectl create ns flux-system &&
kubectl create secret -n flux-system generic flux-system  \
--from-file=identity=./identity \
--from-file=identity.pub=./identity.pub \
--from-file=known_hosts=./known_hosts