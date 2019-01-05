package system

###########################################################################
# Implementation of the k8s admission control external webhook interface.
###########################################################################

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

	# if there are missing leaves e.g. trying to add a label to something that doesn't
	# yet have any, we need to create the leaf nodes as well

	fullPatches := ensure_parent_paths_exist(cast_array(patch))

	x := {
		"allowed": true,
		"patchType": "JSONPatch",
		"patch": base64url.encode(json.marshal(fullPatches)),
	}
}

isValidRequest {
	# not sure if this might be a race condition, it might get called before 
	# all the validation rules have been run
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

###########################################################################
# PATCH helpers 
# Note: These rules assume that the input is an object
# not an AdmissionRequest, because labels and annotations 
# can apply to various sub-objects within a request
# So from the context of an AdmissionRequest they need to
# be called like
#   hasLabelValue[["foo", "bar"]] with input as input.request.object
# or
#   hasLabelValue[["foo", "bar"]] with input as input.request.oldObject
###########################################################################

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

###########################################################################
# makeLabelPatch creates a label patch
# Labels can exist on numerous child objects e.g. Deployment.template.metadata
# Use pathPrefix to specify a lower level object, or pass "" to select the 
# top level object
# Note: pathPrefix should have a leading '/' but no trailing '/'
###########################################################################

makeLabelPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "metadata/labels", key]),
		"value": value,
	}
}

makeAnnotationPatch(op, key, value, pathPrefix) = patchCode {
	patchCode = {
		"op": op,
		"path": concat("/", [pathPrefix, "metadata/annotations", key]),
		"value": value,
	}
}

# (Thanks to Tim Hinrichs for the following...)

# Given array of JSON patches create and prepend new patches that create missing paths.
#   CAUTION: Implementation only creates leaves.
ensure_parent_paths_exist(patches) = result {
	paths := {p.path | p := patches[_]}
	newpatches := {make_path(prefix_array) |
		paths[path]
		full_length := count(path)
		path_array := split(path, "/")
		last_element_length := count(path_array[minus(count(path_array), 1)])

		# this assumes paths starts with '/'
		prefix_path := substring(path, 1, (full_length - last_element_length) - 2)
		trace(sprintf("[ensure_parent_paths_exist] prefix_path = %s", [prefix_path]))
		prefix_array := split(prefix_path, "/")
		not input_path_exists(prefix_array) with input as input.request.object
	}

	result := array.concat(cast_array(newpatches), patches)

	trace(sprintf("[ensure_parent_paths_exist] paths = %s", [paths]))
	trace(sprintf("[ensure_parent_paths_exist] newpatches = %s", [newpatches]))
	trace(sprintf("[ensure_parent_paths_exist] result = %s", [result]))
}

# Create the JSON patch to ensure the @path_array exists
make_path(path_array) = result {
	# Need a slice of the path_array with all but the last element.
	#   No way to do that with arrays, but we can do it with strings.
	path_str := concat("/", array.concat([""], path_array))
	trace(sprintf("[make_path] path_array = %s", [path_array]))
	trace(sprintf("[make_path] path_str = %s", [path_str]))

	result = {
		"op": "add",
		"path": path_str,
		"value": {},
	}
}

# Check that the given @path exists as part of the input object.
input_path_exists(path) {
	trace(sprintf("[input_path_exists] input = %s", [input]))
	trace(sprintf("[input_path_exists] path = %s", [path]))
	walk(input, [path, walkval])
	trace(sprintf("[input_path_exists] walk = %s", [walkval]))
	walk(input, [path, _])
}

# Dummy deny and patch to please the compiler

deny[msg] {
	input.request.kind == "AdmissionReview"
	msg = "Input must be Kubernetes AdmissionRequest"
}

patch[patchCode] {
	input.kind == "ThisHadBetterNotBeARealKind"
	patchCode = {}
}
