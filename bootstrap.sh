# This is derived from the tutorial at https://www.openpolicyagent.org/docs/kubernetes-admission-control.html
mkdir -p tmp

kubectl create ns opa

kubectl config set-context opa-tutorial --user minikube --cluster minikube --namespace opa
kubectl config use-context opa-tutorial

openssl genrsa -out tmp/ca.key 2048
openssl req -x509 -new -nodes -key tmp/ca.key -days 100000 -out tmp/ca.crt -subj "/CN=admission_ca"

cat >tmp/server.conf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
EOF

openssl genrsa -out tmp/server.key 2048
openssl req -new -key tmp/server.key -out tmp/server.csr -subj "/CN=opa.opa.svc" -config tmp/server.conf
openssl x509 -req -in tmp/server.csr -CA tmp/ca.crt -CAkey tmp/ca.key -CAcreateserial -out tmp/server.crt -days 100000 -extensions v3_req -extfile tmp/server.conf

kubectl create secret tls opa-server --cert=tmp/server.crt --key=tmp/server.key

# our CRD
kubectl apply -f k8s/crd-dog.yaml
kubectl apply -f k8s/clusterrole-dogs.yaml
kubectl apply -f k8s/admission-controller.yaml
kubectl apply -f k8s/webhook-configuration-mutating.yaml

make install-rego