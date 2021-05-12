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

Or install the CLI by downloading precompiled binaries using a Bash script:

```sh
curl -s https://fluxcd.io/install.sh | sudo bash
```

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