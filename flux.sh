#!/bin/bash
flux bootstrap github \
--owner=mccullya \
--repository=kakfa-gitops \
--path=clusters/dev \
--branch=andrew
--personal