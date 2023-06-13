#!/usr/bin/env bash
chartVersion="${CHART_VERSION:-0.1.0}"
appVersion="${IMG_TAG:-0.1.0}"
helmDir="config/helm"
set -e

mkdir -p $helmDir/templates $helmDir/crds
# create Helm chart standard files
cat <<EOF > $helmDir/Chart.yaml
apiVersion: v2
name: eventing-auth-manager
description: A Helm chart for Eventing Auth Manager component
type: application
version: $chartVersion
appVersion: "$appVersion"
EOF

kustomize="${KUSTOMIZE:-kustomize}"
touch $helmDir/values.yaml
$kustomize build config/crd  > $helmDir/crds/crd.yaml

cd config/manager && kustomize edit set image controller=$IMG_REPO:$IMG_TAG && cd ../../
$kustomize build config/default  > $helmDir/templates/resources.yaml