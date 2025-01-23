#!/usr/bin/env bash

# Copyright 2018 The Kubeflow Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

CURRENT_DIR=$(dirname "${BASH_SOURCE[0]}")
OPERATOR_ROOT=$(realpath "${CURRENT_DIR}/..")
OPERATOR_PKG="github.com/dongjiang1989/customapi"
CODEGEN_PKG=$(go list -m -mod=readonly -f "{{.Dir}}" k8s.io/code-generator)

cd "${CURRENT_DIR}/.."

echo ${CODEGEN_PKG}

source "${CODEGEN_PKG}/kube_codegen.sh"

kube::codegen::gen_helpers \
  --boilerplate "${OPERATOR_ROOT}/hack/custom-boilerplate.go.txt" \
  "${OPERATOR_ROOT}/pkg/apis"

kube::codegen::gen_openapi \
  --boilerplate "${OPERATOR_ROOT}/hack/custom-boilerplate.go.txt" \
  --output-dir "${OPERATOR_ROOT}/pkg/apis/custom/v1" \
  --output-pkg "${OPERATOR_PKG}/pkg/apis/custom/v1" \
  --update-report \
  "${OPERATOR_ROOT}/pkg/apis/custom/v1"

kube::codegen::gen_client \
  --with-watch \
  --with-applyconfig \
  --output-dir "${OPERATOR_ROOT}/pkg/client" \
  --output-pkg "${OPERATOR_PKG}/pkg/client" \
  --boilerplate "${OPERATOR_ROOT}/hack/custom-boilerplate.go.txt" \
  "${OPERATOR_ROOT}/pkg/apis"
