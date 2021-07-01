# GitOps for Apache Kafka Example

For this example we assume a single clusters simulated a production environment. The end goal is to leverage Flux and Kustomize to manage [Confluent Operator for Kubernetes](https://github.com/confluentinc/operator-earlyaccess). You can extend the with another cluster while minimizing duplicated declarations.

We will configure [Flux](https://fluxcd.io/) to install, deploy and config the [Confluent Platform](https://www.confluent.io/product/confluent-platform) using their `HelmRepository` and `HelmRelease` custom resources.
Flux will monitor the Helm repository, and it will automatically upgrade the Helm releases to their latest chart version based on semver ranges.

You may find this project helpful by simply referencing the documentation, code, and strategies for managing Kafka resources on Kubernetes. Additionally, if you just wish to operate a working example of the new Confluent operator, the following usage instructions will guide you.


## Repository structure

The Git repository contains the following top directories:

- **flux-system** dir contains the required flux 
- **kustomize/base** dir contains the base definition of the confluent stack.  
- **kustomize/environments** dir containing an example environment, folders could be copied to create additional environments.  Files within are 'patches' which are layered on top of the definitions found in kustomize/base
- **kustomize/operator** dir the helm chart definition for confluent-for-kubernetes (CFK).


```
├── flux-system
├── kustomize
│   ├── base
│   │   ├── confluent
│   ├── environments
│   │   └── sandbox
│   └── operator
```

## Forking this repository.
In order to showcase the GitOps behaviour of the FluxCD toolkit you will require the ability to write to a repository.  Fork this repository, and update line 11 of the file `./flux-system/gotk-sync.yaml` to the new https git address.  Also make note of line 10 'branch'; this is the branch of the repository which Flux will monitor

## Deploy base Flux components
### Overview
This step will install the base Flux kubernetes components onto your kubernetes cluster.  To inspect what is being applied, simply look through the contents of `./flux-system/gotk-components.yaml`.  You will see a mix of Custom Resource Definitions, Service Accounts, Deployments, and other various components.  After application is finished, you should see the following pods running:  

* Helm-Controller
* Kustomize Controller
* Notification Controller
* Source Controller

For more information on what these controllers do, please review [the documentation here](https://fluxcd.io/docs/components/).
 

### Deployment Process
* Navigate to `./flux-system`
* Run `kubectl apply -f gotk-components.yaml`


## Deploy Flux Sync
### Overview
This next step will tell Flux what repository to monitor, and, within that repository, what kustomization files to start with.  The first Kustomize resource that Flux will look for to is located at `./kustomize/operator`.  This will install the confluent-for-kubernetes Helm chart.   After a successful health check of the operator (which will run as a pod), Flux will then proceed to deploy our first environment located at  `./kustomize/environments/sandbox`.

### Deployment Process
* Navigate to `./flux-system`
* run `kubectl apply -f gotk-sync.yaml`

## Watch Flux in action



