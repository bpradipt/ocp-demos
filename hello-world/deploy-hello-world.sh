#!/usr/bin/env bash

set -o errexit          # Exit on most errors 


oc apply -f hello-world.yaml
oc create route edge --service=hello-world-service 
HOST=$(oc get route hello-world-service --template='{{ .spec.host }}')
curl -kL https://${HOST}

