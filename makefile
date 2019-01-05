
.PHONY : test trace

test: 
	docker run --rm --name opa-test -v $(PWD)/rego:/rego openpolicyagent/opa test /rego -v

trace: 
	docker run --rm --name opa-test -v $(PWD)/rego:/rego openpolicyagent/opa test /rego -v | grep -i note


.PHONY : install install-core install-validation install-mutation

install-core:
	kubectl -n opa create configmap opa-core --from-file=rego/core.rego --dry-run -o yaml | kubectl apply -f -
	@kubectl -n opa get cm opa-core -o json | jq '.metadata.annotations["openpolicyagent.org/policy-status"]'

install-validation:
	kubectl -n opa create configmap opa-validation --from-file=rego/validation.rego --dry-run -o yaml | kubectl apply -f -
	@kubectl -n opa get cm opa-validation -o json | jq '.metadata.annotations["openpolicyagent.org/policy-status"]'

install-mutation:
	kubectl -n opa create configmap opa-mutation --from-file=rego/mutation.rego --dry-run -o yaml | kubectl apply -f -
	@kubectl -n opa get cm opa-mutation -o json | jq '.metadata.annotations["openpolicyagent.org/policy-status"]'

install-rego: install-core install-validation install-mutation

.PHONY: remove-rego

remove-rego:
	kubectl -n opa delete cm opa-mutation
	kubectl -n opa delete cm opa-validation
	kubectl -n opa delete cm opa-core