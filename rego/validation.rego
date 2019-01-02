package system

############################################################
# DENY rules 
############################################################

# Check for bad dogs
deny[msg] {
  isCreateOrUpdate
  input.request.kind.kind = "Dog"
  input.request.object.spec.isGood = false
  msg = sprintf("Dog %s is a good dog, Brent", [input.request.object.spec.name])
}

