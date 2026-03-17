#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0


set -euo pipefail


PROJECT_ROOT=$(pwd)
cd generator
uv sync
SOURCE_CONFIG=${PROJECT_ROOT}/generator/source-config.yaml

DOC_DIR="${PROJECT_ROOT}/generator/doc"
GEN_DIR="${PROJECT_ROOT}/generator/gen"
CONFIG_TEMPLATE_DIR="${PROJECT_ROOT}/backendconfig/templates"
CMD=(uv run -m generator -c "${SOURCE_CONFIG}" -do "${DOC_DIR}" -to "${GEN_DIR}")
echo "${CMD[@]}"
${CMD[@]}
for file in $(ls "${CONFIG_TEMPLATE_DIR}/"); do
    echo "overwriting ${file} with ${GEN_DIR}/generated_src-${file}"
    cp "${GEN_DIR}/generated_src-${file}" "${CONFIG_TEMPLATE_DIR}/${file}"
done
