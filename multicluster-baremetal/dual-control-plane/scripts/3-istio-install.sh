#!/usr/bin/env bash

# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -euo pipefail
log() { echo "$1" >&2; }

install_istio () {
     helm install istio-${ISTIO_VERSION}/install/kubernetes/helm/istio --name istio --namespace istio-system \
     --values istio-${ISTIO_VERSION}/install/kubernetes/helm/istio/example-values/values-istio-multicluster-gateways.yaml
}

# set vars
ZONE="us-central1-b"
ISTIO_VERSION=${ISTIO_VERSION:=1.2.2}

PROJECT_1="${PROJECT_1:?PROJECT_1 env variable must be specified}"
CLUSTER_1="dual-cluster1"
CTX_1="${CLUSTER1}"

PROJECT_2="${PROJECT_2:?PROJECT_2 env variable must be specified}"
CLUSTER_2="dual-cluster2"
CTX_2="${CLUSTER2}"

# Cluster 1
log "Installing Istio ${ISTIO_VERSION} on Cluster 1..."

kubectl config use-context $CTX_1
install_istio
log "...done with cluster 1."


# Cluster 2
log "Installing Istio ${ISTIO_VERSION} on Cluster 2..."
kubectl config use-context $CTX_2
install_istio
log "...done with cluster 2."
