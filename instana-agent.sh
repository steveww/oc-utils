#!/bin/sh

oc login -u system:admin
oc new-project instana-agent
oc create serviceaccount instana-admin
oc adm policy add-scc-to-user privileged -z instana-admin
oc annotate namespace instana-agent openshift.io/node-selector=""

oc apply -f instana-agent.yaml

