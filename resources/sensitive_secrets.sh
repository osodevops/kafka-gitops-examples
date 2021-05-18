kubectl create secret docker-registry confluent-registry -n dev \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL --dry-run=client --output=yaml > ./sensitive-docker-registry-dev.yaml && \
kubectl create secret docker-registry confluent-registry -n staging \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL --dry-run=client --output=yaml > ./sensitive-docker-registry-staging.yaml && \
kubectl create secret docker-registry confluent-registry -n staging \
  --docker-server=confluent-docker-internal-early-access-operator-2.jfrog.io \
  --docker-username=$USER \
  --docker-password=$APIKEY \
  --docker-email=$EMAIL --dry-run=client --output=yaml > ./sensitive-docker-registry-production.yaml && \
kubectl create secret -n flux-system generic https-credentials \
--from-literal=username=$USER \
--from-literal=password=$APIKEY \
--dry-run=client --output=yaml > ./sensitive-https-credential.yaml