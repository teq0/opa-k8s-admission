package system

############################################################
# Boilerplate--implementation of the k8s admission control external webhook interface.
############################################################

main = {
	"apiVersion": "admission.k8s.io/v1beta1",
	"kind": "AdmissionReview",
	"response": response,
}

default response = {"allowed": true}

# non-patch response
response = x {

  count(patch) = 0

	x := {
		"allowed": false,
		"status": {"reason": reason},
	}

	reason = concat(", ", deny)
	reason != ""
}

# patch response
response = x {

  count(patch) > 0
  
	x := {
		"allowed": true,
    "patchType": "JSONPatch",
    "patch": base64url.encode(json.marshal(patch)),
	}
}

############################################################
# Specific rules below here 
############################################################

# Check for bad dogs
deny[msg] {
  input.request.kind.kind = "Dog"
  input.request.object.spec.isGood = false
  msg = sprintf("Dog %s is a good dog, Brent", [input.request.object.spec.name])
}

# add foo label if missing or incorrect

patch[patchCode] {
  input.request.kind.kind = "Dog"
  input.request.object.spec.isGood = true
  isPatch := true
  patchCode := [
    {"op": "add", "path": "/metadata/labels/foo", "value": "bar"},
  ]
}

haslabels {
  input.metadata.labels
} 

haslabel(label) {
  haslabels
  input.metadata.labels[label]
} 

haslabelvalue(key, val) {
  input.metadata.labels[key] = val
}

hasannotations {
  input.metadata.annotations
} 

hasannotation(annotation) {
  hasannotations
  input.metadata.annotations[annotation]
} 

hasannotationvalue(key, val) {
  input.metadata.annotations[key] = val
}
