### Getting Started

#### Install secrets
To install the secrets required by RBAC/Confluent, run the script: `$./populate_secrets.sh`.  This will create secrets based on the sources found in `./resources/certs` & `./resources/users`



In order to access the Confluent early-access operator you must register at https://events.confluent.io/confluentoperatorearlyaccess.  Once these credentials have been obtained, export them as the following environment variables:

```
export USER=<user name here (often same as EMAIL)>
export APIKEY=<API KEY>
export EMAIL=<user email here >
export GITHUB_USER=<your github usernmae>
```


#### Bootstrap Flux v2
```
flux bootstrap github \
--context=minikube \
--owner=${GITHUB_USER} \
--repository=kakfa-gitops \
--path=clusters/dev \
--branch=andrew \
--personal
```

### Deploy secrets for Confluent Operator Early-Access Docker Regsitry

```
kubectl create secret -n confluent docker-registry confluent-registry \
--docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
--docker-username=$USER \
--docker-password=$APIKEY \
--docker-email=$EMAIL && \
kubectl create secret -n flux-system generic https-credentials \
--from-literal=username=$USER \
--from-literal=password=$APIKEY
```


To deploy the operator, ensure 'kubectl' is pointing to the correct context, and run `$ source ./install_operator.sh`.

To verify the operator has installed successfully, run kubectl `get pods -n confluent` where you should see:

```
NAMESPACE     NAME                                  READY   STATUS    RESTARTS   AGE
confluent     confluent-operator-5b99cdd9d9-pcx2p   1/1     Running   0          3m44s
```


#### Useful commands

* Force Flux Reconciliation
`flux reconcile source git flux-system`

* Decode secrets
`kubectl get secrets -n flux-system https-credentials -o json | jq '.data | map_values(@base64d)'`