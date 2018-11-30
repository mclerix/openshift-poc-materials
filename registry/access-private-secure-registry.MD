
# Configure OpenShift host to access a private secure OpenShift registry
This document aims to explain how to configure OpenShift host to access a private secure OpenShift registry that does not have trusted certificates signed by a know authority
## Add registry CA as a trusted root CA
Todo on each node
```
export REGISTRY_URL=docker-registry-default.apps.openshift-mclerix.com

# You can find registry certificate in project default: secrets > registry-certificates > registry.crt. Append this certificate to the following file:

vi /etc/pki/ca-trust/source/anchors/$REGISTRY_URL.crt

update-ca-trust check && update-ca-trust extract

systemctl restart docker
systemctl restart atomic-openshift-master-api
systemctl restart atomic-openshift-master-controllers
```

## Create ServiceAccount to be used to authenticate against OpenShift registry
```
oc create sa registry-admin -n default
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:default:registry-admin

export TOKEN=$(oc sa get-token registry-admin -n default)
```

## Configure pull secret (per project)
```
export REGISTRY_URL=my.registry.url:port
# Create a secret to access the external docker registry
oc secret new-dockercfg \
    --docker-server=$REGISTRY_URL \
    --docker-username=registry-admin \
    --docker-password=$TOKEN \
    --docker-email=registry@email.com \
    private-registry

# Link to default SA
oc secrets link default private-registry --for=pull
oc secrets link builder private-registry

# Import the image
oc import-image my-external-stream --from=docker-registry-default.apps.openshift-mclerix.com:443/build-strategy/php-app --confirm
```
