#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2026 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
# SPDX-License-Identifier: Apache-2.0


set -euo pipefail

export ESS_SECRETS_PATH="$(pwd)/byoo-otel-collector/secrets"

local_secrets_path="$(pwd)/byoo-otel-collector/secrets"
real_secrets_path="/etc/byoo-otel-collector/secrets"

mkdir -p _output
for input_file in testdata/*.json; do
    echo "=== Test $input_file ==="
    basename=$(basename "${input_file}" .json)
    for backend_type in vm k8s; do
        for compute_type in task function; do
            for req_type in container helm; do
                echo "Generating configs backend_type=${backend_type} request_type=${req_type} compute_type=${compute_type}..."
                go run testdata/create/main.go $input_file _output ${backend_type} ${req_type} ${compute_type}
                generated_file=$(ls _output/byoo-otel-collector/config.${compute_type}_${backend_type}_${req_type}.yaml)
                cp $generated_file byoo-otel-collector/${backend_type}/config_${compute_type}_${req_type}_${basename}.yaml
                sed -i "s|${local_secrets_path}|${real_secrets_path}|g" byoo-otel-collector/${backend_type}/config_${compute_type}_${req_type}_${basename}.yaml
                rm $generated_file
            done
        done
    done
done
