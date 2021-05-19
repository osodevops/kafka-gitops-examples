## Deploy base Flux components
* Navigate to ./flux-system
* Run `kubectl apply -f gotk-components.yaml`

## Add GitHub Deploy Key
* Navigate to ./resources/git
* Generate identity, identity.pub, knownhosts file
* Add identity.pub to 'deploy keys' in github  
* run git_repo.sh

## Deploy confluent-helm chart secrets
* Navigate to ./resources/confluent-helm
* Set ENV Vars
* run `senstive_secrets.sh`

## Deploy Flux Sync
* Navigate to ./flux-system
* run `kubectl apply -f gotk-sync.yaml`

