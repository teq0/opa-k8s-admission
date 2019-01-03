package system

############################################################
# Implementation of the k8s admission control external webhook interface.
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

isCreateOrUpdate {
  isCreate
}

isCreateOrUpdate {
  isUpdate
}

isCreate {
  input.request.operation == "CREATE"
}

isUpdate {
  input.request.operation == "UPDATE"
}

############################################################
# PATCH helpers 
# Note: These rules assume that the input is an object
# not an AdmissionRequest, because labels and annotations 
# can apply to various sub-objects within a request
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


############################################################
# makeLabelPatch creates a label patch
# Labels can exist on numerous child objects e.g. Deployment.template.metadata
# Use pathPrefix to specify a lower level object, or pass "" to select the 
# top level object
# Note: pathPrefix should have a leading '/' but no trailing '/'
############################################################



makeLabelPatch(op, key, value, pathPrefix) = patchCode {
  patchCode = {
    "op": op,
    "path": concat("/", [pathPrefix, "metadata/labels", key]),
    "value": value,
  }
} 
# {
  # patchCode = {
  #   "op": op,
  #   "path": "/metadata/labels",
  #   "value": sprintf("{ \"%s\": \"%s\" }", [ key, value]),
  # }
# }


makeAnnotationPatch(op, key, value, pathPrefix) = patchCode {
  patchCode = {
    "op": op,
    "path": concat("/", [pathPrefix, "metadata/annotations", key]),
    "value": value,
  }
}

############################################################
# Dummy deny and patch to keep compiler happy
############################################################

deny[msg] {
  msg := "n/a"
  1=2
}

patch[patchCode] {
  patchCode := "n/a"
  1=2
}