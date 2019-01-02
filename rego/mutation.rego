package system

############################################################
# PATCH rules 
#
# Note: All patch rules should start with `isValidRequest` and `isCreateOrUpdate`
############################################################

# add foo label to Dogs if not present
patch[patchCode] {
  isValidRequest
  isCreateOrUpdate
  input.request.kind.kind = "Dog"
  not hasLabelValue[["foo", "bar"]] with input as input.request.object
  patchCode = makeLabelPatch("add", "foo", "bar")
}

# add baz label if it has foo
# TODO: no test for this atm
patch[patchCode] {
  isValidRequest
  isCreateOrUpdate
  input.request.kind.kind = "Dog"
  hasLabelValue[["foo", "bar"]] with input as input.request.object
  patchCode = makeLabelPatch("add", "baz", "quux")
}

# add both foo and baz if annotation "allthethings" exists
patch[patchCode] {
  isValidRequest
  isCreateOrUpdate
  input.request.kind.kind = "Dog"
  hasAnnotation["allthethings"] with input as input.request.object
  patchCode = makeLabelPatch("add", "baz", "quux") 
}

# cats named tom get an extra annotation
patch[patchCode] {
  isValidRequest
  isCreateOrUpdate
  input.request.kind.kind = "Cat"
  input.request.object.metadata.name = "tom"
  not hasAnnotation["rating"] with input as input.request.object
  patchCode = makeAnnotationPatch("add", "rating", "14/10") 
}
