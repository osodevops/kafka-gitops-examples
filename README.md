# GitOps for Apache Kafka Example

For this example we assume a single clusters simulated a production environment. The end goal is to leverage Flux and Kustomize to manage [Confluent Operator for Kubernetes](https://github.com/confluentinc/operator-earlyaccess). You can extend the with another cluster while minimizing duplicated declarations.

We will configure [Flux](https://fluxcd.io/) to install, deploy and config the [Confluent Platform](https://www.confluent.io/product/confluent-platform) using their private `HelmRepository` and `HelmRelease` custom resources.
Flux will monitor the Helm repository, and it will automatically upgrade the Helm releases to their latest chart version based on semver ranges.

You may find this project helpful by simply referencing the documentation, code, and strategies for managing Kafka resources on Kubernetes. Additionally, if you just wish to operate a working example of the new Confluent operator, the following usage instructions will guide you.

## Prerequisites
You will need a Kubernetes cluster version 1.16 or newer and kubectl version 1.18.

In order to follow the guide you'll need a GitHub account and a
[personal access token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)
that can create repositories (check all permissions under `repo`).

Install the Flux CLI on MacOS and Linux using Homebrew:

```sh
brew install fluxcd/tap/flux
```

Install the Confluent CLI 
```she
curl -sL --http1.1 https://cnfl.io/cli | sh -s -- latest
```

Get early access by registering interest here: [Confluent Operator Early Access Registration](https://events.confluent.io/confluentoperatorearlyaccess) For this Early Access program, you will have received an API key (associated with your email address) to the Confluent JFrog Artifactory. This is required to pull down the Helm charts and Confluent Docker images.

## Repository structure

The Git repository contains the following top directories:

- **apps** dir contains Helm releases with a custom configuration per cluster
- **infrastructure** dir contains common infra tools such as Confluent Operator, example LDAP controller and Helm repository definitions
- **clusters** dir contains the Flux configuration per cluster

```
├── apps
│   ├── base
│   │   ├── kafka
│   │   └── rolebindings   
│   ├── production 
├── infrastructure
│   ├── confluent
│   ├── sources
│   └── tools
└── clusters
    └── production
```
### /apps
The apps configuration contains all the Confluent Platform configuration and is structured into:

- **apps/base/kakfa/** dir common values for all clusters: namespaces, certificates, secrets, Confluent components via Helm release definitions and Deployments
- **apps/base/rolebings/** dir contains the common RBAC bindings for all deployments
- **apps/production/** dir contains the production values 

### /infrastructure
The infrastructure `sources` folder contains the [Flux Source Controller](https://fluxcd.io/docs/components/source/) configuration and some common tooling which is required for this Confluent LDAP / RBAC example.
```yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: confluent-private
  namespace: flux-system
spec:
  url: https://confluent.jfrog.io/confluent/helm-early-access-operator-2
  secretRef:
    name: https-credentials
  interval: 5m
```
Note secretRef: The Confluent helm repository is private and requires a username and password which we must create.
Note that with interval: 5m we configure Flux to pull the Helm repository index every five minutes. If the index contains a new chart version that matches a HelmRelease semver range, Flux will upgrade the release.

The `confluent` folder contains the Helm release which is performed by the [Helm Controller](https://fluxcd.io/docs/components/helm/helmreleases/) and also requires access to the private Docker registry to pull down the Confluent images.  
```yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: confluent
  namespace: confluent
spec:
  interval: 1m
  chart:
    spec:
      chart: confluent-for-kubernetes
      sourceRef:
        kind: HelmRepository
        name: confluent-private
        namespace: flux-system
  values:
    image:
      registry: confluent-docker-internal-early-access-operator-2.jfrog.io
```
Note: The Helm automatically looks for a secret called `confluent-registry` which we must create in the confluent namespace.

## Setup
Following this example, you'll set up secure Confluent Platform clusters with SASL PLAIN authentication, role-based access control (RBAC) authorization, and inter-component TLS. The clusters dir contains the Kustomization definitions::
```
./clusters/
└── production
    ├── apps.yaml
    └── infrastructure.yaml
```
1.  Using GitOps will require the FluxCD toolkit to have read and write access to the repository. For your own local version, you must create a fork of this repository and clone it locally; otherwise, the GitOps automation will not be authorized to read and write from the repository. Fork this repository on your personal GitHub account and export your GitHub access token, username and repo name:
```sh
export GITHUB_TOKEN=<your-token>
export GITHUB_USER=<your-username>
export GITHUB_REPO=<repository-name (i.e. kafka-gitops)>
```
    
2. After forking and cloning the repository, navigate to the project root and verify that your production cluster folder satisfies the prerequisites with:
```sh
flux check --pre
```

3. Flux will now need connectivity do your cluster, ensure the correct kubectl context to your cluster and bootstrap Flux:
```sh
flux bootstrap github \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/production
```

```sh
flux bootstrap github \
    --owner=${GITHUB_USER} \
    --repository=${GITHUB_REPO} \
    --branch=main \
    --personal \
    --path=clusters/production
```

4. Deploy the secrets required by the application.  The secrets referenced in `./resources/populate_secrets.sh` will match up to the LDAP/LDIFs located at `./infrastructure/tools/ldap.yaml`
```sh
./resources/populate_secrets.sh
```

5. The source controller will be unable to pull the Helm chart or connect to the Docker registry. You now should create the following secrets using Confluent early access credentials:
```sh
export USER=<user id here (often same as email)>
export APIKEY=<API KEY sent via email>
export EMAIL=<user email here>

kubectl create secret docker-registry confluent-registry -n dev \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL && \
kubectl create secret -n flux-system generic https-credentials \
--from-literal=username=$USER \
--from-literal=password=$APIKEY

```
Watch for the Helm releases being installed in production cluster:

```console
$ watch flux get helmreleases --all-namespaces 
```


## Appendix
### Useful commands

* Force Flux Reconciliation
  `flux reconcile source git flux-system`

* Decode secrets
  `kubectl get secrets -n flux-system https-credentials -o json | jq '.data | map_values(@base64d)'`

* Access Control Centre
  `kubectl port-forward -n confluent controlcenter-0 9021:9021`. The web UI credentials will be c3/c3-secret (as defined by the populated secrets)

* LDAP Testing.  Exec onto the ldap container by running: `kubectl exec -it -n tools ldap -- bash`. Running  
  `ldapsearch -LLL -x -H ldap://ldap.tools.svc.cluster.local:389 -b 'dc=test,dc=com' -D "cn=mds,dc=test,dc=com" -w 'Developer!'` will return a list of LDAP users presently configured

* For testing a repeatable deployment process, for example on a local minikube, a `tldr.sh` script which captures the above steps has been included at the root of this project