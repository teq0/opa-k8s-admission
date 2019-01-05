package kubernetes.test

request_default = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {""},
}

request_dog_good = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar"},
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar1"},
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_some_labels_and_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {
					"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n",
					"allthethings": "automate",
				},
				"labels": {
					"gamma-rays": "on",
					"yobba-rays": "on",
				},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_existing_labels_and_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"rating": "14/10"},
				"labels": {
					"foo": "bar",
					"quuz": "corge",
				},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_no_labels_or_annotations = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "spike",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": true,
				"name": "Spike",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "spike",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Spike",
			},
		},
		"dryRun": false,
	},
}

request_dog_bad = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Dog",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "dogs",
		},
		"name": "rex",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo": "bar1"},
				"name": "rex",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Rex",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Dog",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"labels": {"foo1": "bar1"},
				"name": "rex",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"food": "meat",
				"isGood": false,
				"name": "Rex",
			},
		},
		"dryRun": false,
	},
}

request_cat_named_tom = {
	"kind": "AdmissionReview",
	"apiVersion": "admission.k8s.io/v1beta1",
	"request": {
		"uid": "836c0cc6-096c-11e9-9a47-080027f60d22",
		"kind": {
			"group": "frens.teq0.com",
			"version": "v1",
			"kind": "Cat",
		},
		"resource": {
			"group": "frens.teq0.com",
			"version": "v1",
			"resource": "cats",
		},
		"name": "tom",
		"operation": "UPDATE",
		"userInfo": {
			"username": "minikube-user",
			"groups": [
				"system:masters",
				"system:authenticated",
			],
		},
		"object": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Cat",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "tom",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"friendly": true,
				"personality": "awesome",
				"name": "Thomas",
			},
		},
		"oldObject": {
			"apiVersion": "frens.teq0.com/v1",
			"kind": "Cat",
			"metadata": {
				"annotations": {"kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"frens.teq0.com/v1\",\"kind\":\"Dog\",\"metadata\":{\"annotations\":{},\"labels\":{\"foo\":\"bar1\"},\"name\":\"rex\",\"namespace\":\"\"},\"spec\":{\"food\":\"meat\",\"isGood\":false,\"name\":\"Rex\"}}\n"},
				"creationTimestamp": "2018-12-26T02:36:30Z",
				"generation": 1,
				"name": "tom",
				"resourceVersion": "61919",
				"uid": "0d0f9b6a-08b7-11e9-9a47-080027f60d22",
			},
			"spec": {
				"friendly": true,
				"personality": "awesome",
				"name": "Thomas",
			},
		},
		"dryRun": false,
	},
}

object_with_label_foo_bar = {"metadata": {"labels": {"foo": "bar"}}}

object_without_labels = {"metadata": {"annotations": {"foo": "bar"}}}

object_with_annotation_foo_bar = {"metadata": {"annotations": {"foo": "bar"}}}

object_without_annotations = {"metadata": {"labels": {"foo": "bar"}}}

object_without_labels_or_annotations = {"metadata": {}}
