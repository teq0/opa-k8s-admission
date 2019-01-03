
.PHONY : test

test: 
	docker run --rm --name opa-test -v $(PWD)/rego:/rego openpolicyagent/opa test /rego -v


.PHONY : install install-core install-validation install-mutation

install-core:
	kubectl -n opa create configmap opa-core --from-file=rego/core.rego --dry-run -o yaml | kubectl apply -f -

install-validation:
	kubectl -n opa create configmap opa-validation --from-file=rego/validation.rego --dry-run -o yaml | kubectl apply -f -

install-mutation:
	kubectl -n opa create configmap opa-mutation --from-file=rego/mutation.rego --dry-run -o yaml | kubectl apply -f -

install-rego: install-core install-validation install-mutation

.PHONY: remove-rego

remove-rego:
	kubectl -n opa delete cm opa-mutation
	kubectl -n opa delete cm opa-validation
	kubectl -n opa delete cm opa-corem