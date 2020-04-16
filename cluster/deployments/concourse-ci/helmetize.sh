#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

helm repo add concourse https://concourse-charts.storage.googleapis.com/
helm template --name-template "concourse-ci" --values values.yaml concourse/concourse > test-no-changes.yml
