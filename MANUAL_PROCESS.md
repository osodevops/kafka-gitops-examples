## Forking this repository.

In order to showcase the GitOps behaviour of the FluxCD toolkit you will require the ability to write to a repository.  Fork this repository, and update line 11 of the file `./flux-system/gotk-sync.yaml` to the new https git address.  Also make note of line 10 'branch'; this is the branch of the repository which Flux will monitor

## Deploy base Flux components
### Overview
This step will install the base Flux kubernetes components onto your kubernetes cluster.  To inspect what is being applied, simply look through the contents of `./flux-system/gotk-components.yaml`.  You will see a mix of Custom Resource Definitions, Service Accounts, Deployments, and other various components.  After application is finished, you should see the following pods running:  

* Helm-Controller
* Kustomize Controller
* Notification Controller
* Source Controller
 

### Deployment Process
* Navigate to `./flux-system`
* Run `kubectl apply -f gotk-components.yaml`



## Deploy Flux Sync
### Overview
This next step will tell Flux what repository to monitor, and, within that repository, what kustomization files to start with.
* Navigate to ./flux-system
* run `kubectl apply -f gotk-sync.yaml`

