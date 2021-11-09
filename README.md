# example-cd-pipeline


## STEP TO DEPLOY (LOGICAL PROCESS)

### 1. Istio Deployement

1. install namespace istio

```bash
kubectl apply -f istio/istio-ns.yaml
```

2. config manifest yaml at host & push to git

```bash
#for istio build
istioctl manifest generate -f ./manifest-uat.yaml > istio-uat.yaml
```

3. apply config

```bash
kubectl apply -f istio/istio-uat.yaml
```


### 2. Common Deployment

1. run build common helm template

```bash
helm template ./helm/aistemplate --values helm/aistemplate/example/_common-values.yaml --set projectName=example --set istio.enabled=true --set deploymentEnvironment=dev --output-dir helm/output
``` 

2. run kube apply result for namespace, virtualservice,gateway

```bash
kubectl apply -f helm/output/aistemplate/templates/namespace.yaml

kubectl apply -f helm/output/aistemplate/templates/virtual-service.yaml -n example-dev

kubectl apply -f helm/output/aistemplate/templates/gateway.yaml -n default
```

### 3. Application Deployment

1. config deployment at aistemplate/example

2. build helm template

```bash
helm template ./helm/aistemplate --values helm/aistemplate/example/node-express-app.yaml --set deploymentEnvironment=dev --set imageVersion=0.0.1-SNAPSHOT --set buildNumber=1 --output-dir helm/output
```

3. kube apply

```bash
kubectl apply -f helm/output/aistemplate/templates/deployment.yaml -n example

kubectl apply -f helm/output/aistemplate/templates/service.yaml -n example

kubectl apply -f helm/output/aistemplate/templates/destinationrule.yaml -n example

kubectl rollout status deployment dev -n example

```
