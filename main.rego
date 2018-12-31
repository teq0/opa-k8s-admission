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

isValidRequest {
  count(deny) = 0
}

############################################################
# DENY rules 
############################################################

# Check for bad dogs
deny[msg] {
  input.request.kind.kind = "Dog"
  input.request.object.spec.isGood = false
  msg = sprintf("Dog %s is a good dog, Brent", [input.request.object.spec.name])
}

############################################################
# PATCH helpers 
# Note: These rules assume that the input is an object, 
# not an AdmissionRequest, because for UPDATEs there are two 
# objects, the new one and the old one, and it may be
# necessary to reason about the previous state as well
# as the new state.
# So from the context of an AdmissionRequest they need to
# be called like
#   hasLabelValue[["foo", "bar"]] with input as input.request.object
# or
#   hasLabelValue[["foo", "bar"]] with input as input.request.oldObject
############################################################

hasLabels {
  input.metadata.labels
} 

hasLabel[label] {
  hasLabels
  input.metadata.labels[label]
} 

hasLabelValue[[key, val]] {
  hasLabels
  input.metadata.labels[key] = val
}

hasAnnotations {
  input.metadata.annotations
} 

hasAnnotation[annotation] {
  hasAnnotations
  input.metadata.annotations[annotation]
} 

hasAnnotationValue[[key, val]] {
  hasAnnotations
  input.metadata.annotations[key] = val
}

makeLabelPatch(op, key, value) = patchCode {
  patchCode = {
    "op": op,
    "path": sprintf("%s%s", ["/metadata/labels/", key]),
    "value": value,
  }
}

############################################################
# PATCH rules 
#
# Note: All patch rules should start with `isValidRequest` 
############################################################

# add foo label if not present
patch[patchCode] {
  isValidRequest
  not hasLabelValue[["foo", "bar"]] with input as input.request.object
  patchCode = makeLabelPatch("add", "foo", "bar")
}

# add baz label if it has foo
# TODO: no test for this atm
patch[patchCode] {
  isValidRequest
  hasLabelValue[["foo", "bar"]] with input as input.request.object
  patchCode = makeLabelPatch("add", "baz", "quux")
}

# add both foo and baz if annotation "allthethings" exists
patch[patchCode] {
  isValidRequest
  hasAnnotation["allthethings"] with input as input.request.object
  patchCode = makeLabelPatch("add", "baz", "quux") 
}

