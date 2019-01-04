package system

import data.kubernetes.test as k8s

############################################################
# DENY tests 
############################################################

#-----------------------------------------------------------
# Test: the default validation rule is ALLOW
#-----------------------------------------------------------

test_main_default_allow {
	res := main with input as k8s.request_default
	res.response.allowed
}

#-----------------------------------------------------------
# Test: Dogs with isGood = true are allowed
#-----------------------------------------------------------

test_main_dog_good_allow {
	res := main with input as k8s.request_dog_good
	res.response.allowed = true
}

#-----------------------------------------------------------
# Test: Dogs with isGood = false are rejected (They're good dogs, Brent)
#-----------------------------------------------------------

test_main_dog_bad_deny {
	res := main with input as k8s.request_dog_bad
	res.response.allowed = false
}

############################################################
# PATCH helper tests 
############################################################

#-----------------------------------------------------------
# Test: hasLabels is true when there are labels
#-----------------------------------------------------------

test_hasLabels_true {
	hasLabels with input as k8s.object_with_label_foo_bar
}

#-----------------------------------------------------------
# Test: hasLabels is false when there are no labels
#-----------------------------------------------------------

test_no_labels_true {
	not hasLabels with input as k8s.object_without_labels
}

#-----------------------------------------------------------
# Test: hasLabel is true when the label exists
#-----------------------------------------------------------

test_hasLabel_foo {
	hasLabel.foo with input as k8s.object_with_label_foo_bar
}

#-----------------------------------------------------------
# Test: hasLabel is false when the label doesn't exist
#-----------------------------------------------------------

test_not_hasLabel_foo1 {
	not hasLabel.foo1 with input as k8s.object_with_label_foo_bar
}

#-----------------------------------------------------------
# Test: hasLabelValue is true when the label has the correct value
#-----------------------------------------------------------

test_hasLabelValue_fooeqbar {
	hasLabelValue[["foo", "bar"]] with input as k8s.object_with_label_foo_bar
}

#-----------------------------------------------------------
# Test: hasAnnotations is true when there are annotations
#-----------------------------------------------------------

test_hasAnnotations_true {
	hasAnnotations with input as k8s.object_with_annotation_foo_bar
}

#-----------------------------------------------------------
# Test: hasAnnotations is false when there are no annotations
#-----------------------------------------------------------

test_no_annotations_true {
	not hasAnnotations with input as k8s.object_without_annotations
}

#-----------------------------------------------------------
# Test: hasAnnotation is true when the annotation exists
#-----------------------------------------------------------

test_hasAnnotation_foo {
	hasAnnotation.foo with input as k8s.object_with_annotation_foo_bar
}

#-----------------------------------------------------------
# Test: hasAnnotation is false when the annotation doesn't exist
#-----------------------------------------------------------

test_not_hasAnnotation_foo1 {
	not hasAnnotation.foo1 with input as k8s.object_with_annotation_foo_bar
}

#-----------------------------------------------------------
# Test: hasAnnotationValue is true when the annotation has the correct value
#-----------------------------------------------------------

test_hasAnnotation_fooeqbar {
	hasAnnotationValue[["foo", "bar"]] with input as k8s.object_with_annotation_foo_bar
}

#-----------------------------------------------------------
# Test: makeLabelPatch creates a valid patch
#-----------------------------------------------------------

test_makeLabelPatch {
	l := makeLabelPatch("add", "foo", "bar", "") with input as k8s.object_with_label_foo_bar
	l = {"op": "add", "path": "/metadata/labels/foo", "value": "bar"}

	# test pathPrefix
	m := makeLabelPatch("add", "foo", "bar", "/template") with input as k8s.object_with_label_foo_bar
	m = {"op": "add", "path": "/template/metadata/labels/foo", "value": "bar"}
}

############################################################
# PATCH tests 
############################################################

#-----------------------------------------------------------
# Sample patch values to test against
#-----------------------------------------------------------

# TODO - should these values live with the test data rather than the tests? 

patchCode_foobar_existing_labels = {
	"op": "add",
	"path": "/metadata/labels/foo",
	"value": "bar",
}

# TODO - k8s expects a different patch to add a label if no labels already exist
# (and ditto for annotations). Haven't implemented this yet, and could be tricky because opa doesn't 
# guarantee execution order

patchCode_foobar_no_existing_labels = {
	"op": "add",
	"path": "/metadata/labels",
	"value": {"foo": "bar"},
}

patchCode_bazquux_existing_labels = {
	"op": "add",
	"path": "/metadata/labels/baz",
	"value": "quux",
}

patchCode_quuzcorge_existing_labels = {
	"op": "add",
	"path": "/metadata/labels/quuz",
	"value": "corge",
}

patchCode_rating_annotation = {
	"op": "add",
	"path": "/metadata/annotations/rating",
	"value": "14/10",
}

#-----------------------------------------------------------
# Test: Correct patch is created for Dogs with no foo label
# TODO: Need versions of this for Dogs with no labels, Dogs with
#  existing labels but not foo, and Dogs with foo label with wrong value
#-----------------------------------------------------------

test_main_dog_good_missing_label_foobar {
	res := main with input as k8s.request_dog_no_label
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	resPatch = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf(">>>> resPatch = '%s'", [resPatch]))
	resPatch[_] = patchCode_foobar_existing_labels
}

test_main_dog_good_missing_label_quuzcorge {
	res := main with input as k8s.request_dog_no_label
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	resPatch = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf(">>>> resPatch = '%s'", [resPatch]))
	resPatch[_] = patchCode_quuzcorge_existing_labels
}

#-----------------------------------------------------------
# Test: Correct patch is created for Dogs with allthethings annotation and no labels
#-----------------------------------------------------------

test_main_dog_good_allthethings {
	res := main with input as k8s.request_dog_with_annotation_allthethings
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	resPatch = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf(">>>> resPatch = '%s'", [resPatch]))
	resPatch[_] = patchCode_foobar_existing_labels
	resPatch[_] = patchCode_bazquux_existing_labels
}

#-----------------------------------------------------------
# Test: Correct annotation patch is created for Cats named tom
#-----------------------------------------------------------

# TODO - waiting on answer for idiomatic way to check for the existence of an element in an array

test_main_dog_good_allthethings {
	res := main with input as k8s.request_dog_good
	res.response.allowed = true
	res.response.patchType = "JSONPatch"
	resPatch = json.unmarshal(base64url.decode(res.response.patch))
	trace(sprintf(">>>> resPatch = '%s'", [resPatch]))
	resPatch[_] = patchCode_rating_annotation
}
