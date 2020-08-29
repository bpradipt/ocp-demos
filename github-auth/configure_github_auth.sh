#!/usr/bin/env bash

set -o errexit          # Exit on most errors 
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


function trap_err() {
    local exit_code=1

    # Disable the error trap handler to prevent potential recursion
    trap - ERR

    # Consider any further errors non-fatal to ensure we run to completion
    set +o errexit
    set +o pipefail

    # Validate any provided exit code
    if [[ ${1-} =~ ^[0-9]+$ ]]; then
        exit_code="$1"
    fi

    # Exit with failure status
    exit "$exit_code"
}

function create_github_cr() {
    oc apply -f github-cr.yaml
}

function create_secret() {
    oc create secret generic github-secret --from-literal=clientSecret=${client_secret} -n openshift-config
}

function parse_params() {
    if [ "$#" -ne 3 ]; then
       echo "usage: ${0} client_id client_secret github_organization"
       exit 1
    fi
    client_id=${1}
    client_secret=${2}
}

    
trap trap_err ERR
parse_params "$@"

cat <<EOF > github-cr.yaml
apiVersion: config.openshift.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
  - name: github
    mappingMethod: claim
    type: GitHub
    github:
      clientID: ${client_id}
      clientSecret:
        name: github-secret
      organizations:
      - ${github_organization}
EOF

create_secret
create_github_cr
