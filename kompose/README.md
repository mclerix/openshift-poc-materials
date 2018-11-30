# Instructions

```
# Convert to OpenShift Objects
kompose convert --provider=openshift

# Deploy to OpenShift (You must be logged to an openshift cluster using oc login)
kompose up --provider=openshift

# Once deployed, you can expose the apps and access it via a route
oc expose svc mlbparks
```
