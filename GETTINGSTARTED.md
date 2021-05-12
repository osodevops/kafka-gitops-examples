### Getting Started
In order to access the Confluent early-access operator you must register at https://events.confluent.io/confluentoperatorearlyaccess.  Once these credentials have been obtained, export them as the following environment variables:

```
export USER=<user email here>
export APIKEY=<API KEY>
export EMAIL=<user email here>
```

To deploy the operator, ensure 'kubectl' is pointing to the correct context, and run `$ ./install_operator.sh`.

To verify the operator has installed successfully, run kubectl `get pods -n confluent` where you should see:

```
NAMESPACE     NAME                                  READY   STATUS    RESTARTS   AGE
confluent     confluent-operator-5b99cdd9d9-pcx2p   1/1     Running   0          3m44s
```


#### Bootstrap this repository
You will need SSH access to this repository


flux bootstrap github \
--owner=mccullya \
--repository=kakfa-gitops \
--path=dev/flux-system \
--personal



#### Useful commands
