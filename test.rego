package system

import data.kubernetes.test as k8s

test_main_default_allow {
  res :=  main with input as k8s.request_default
  res.response.allowed
}

test_main_dog_good_allow {
  res :=  main with input as k8s.request_dog_good
  res.response.allowed = true
}

test_main_dog_bad_deny {
  res :=  main with input as k8s.request_dog_bad
  res.response.allowed = false
}

test_main_dog_good_missing_label {
  res :=  main with input as k8s.request_dog_no_label
  res.response.allowed = true
  res.response.patchType = "JSONPatch"
}

test_haslabels_true {
  haslabels with input as k8s.object_with_label_foo_bar
}

test_no_labels_true {
  not haslabels with input as k8s.object_without_labels
}