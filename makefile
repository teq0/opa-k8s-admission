
.PHONY : test

test: 
	docker run --rm --name opa-test -v $(PWD):/rego openpolicyagent/opa test /rego -v
