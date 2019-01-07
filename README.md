# opa-k8s-admission

Open Policy Agent framework to implement kubernetes validating and mutating admission controllers. 

## Usage on minikube

`bootstrap.sh` contains most of the steps from the example at [https://www.openpolicyagent.org/docs/kubernetes-admission-control.html](https://www.openpolicyagent.org/docs/kubernetes-admission-control.html). It generates intermediate files in `./tmp`.

The examples use a CRD for a resource called Dog. The default RoleBinding for kube-mgmt is the standard ClusterRole `view`, so we need to extend that ClusterRole using aggregation (`k8s/clusterrrole-dogs.yaml`) so that `view` also has read access to Dog resources.

Once installed you can play with the `k8s/dog-*.yaml` files to see the results e.g.

```
kubectl apply -f k8s/dog-rex.yaml
Error from server (InternalError): error when creating "k8s/dog-rex.yaml": Internal error occurred: admission webhook "mutating-webhook.openpolicyagent.org" denied the request: Rex is a good dog, Brent
```

or 

```
kubectl apply -f k8s/dog-chief.yaml
dog "chief" configured
kubectl get dog chief -o yaml

apiVersion: frens.teq0.com/v1
kind: Dog
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"frens.teq0.com/v1","kind":"Dog","metadata":{"annotations":{},"name":"chief","namespace":""},"spec":{"food":"corn chips","isGood":true,"name":"Master Chief"}}
    rating: 14/10
  creationTimestamp: 2019-01-05T05:51:10Z
  generation: 2
  labels:
    foo: bar
    quuz: corge
  name: chief
  resourceVersion: "282046"
  selfLink: /apis/frens.teq0.com/v1/dogs/chief
  uid: e70b845e-10ad-11e9-b8f0-080027f60d22
spec:
  food: corn chips
  isGood: true
  name: Master Chief
  ```


Note: VS Code OPA plugin currently tries to parse everything in the workspace, so you will get warnings about some of the non-rego files when saving files etc. This will potentially be addressed in [#1087](https://github.com/open-policy-agent/opa/issues/1087)
