# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.17.0] - 2026-03-03

- Update module to new name for github

## [0.16.10] - 2026-03-06

- fix: add year to copyright headers
- fix: disable automounting in validator chart dummy-function

## [0.16.9] - 2026-02-23

- fix: update examples

## [0.16.8] - 2026-02-23

- fix: fix license identifier for python packages

## [0.16.7] - 2026-02-23

- chore: add licenses for python packages

## [0.16.6] - 2026-02-19

- fix: remove unused submodules

## [0.16.5] - 2026-02-19

- fix: fix linting errors

## [0.16.4] - 2026-02-19

- chore: add licenses, github issue templates, and markdown files for open source. Included linting in order to ensure that the license header is on every file.

## [0.16.3] - 2025-06-05

- fix: nvbug 5326520  - function container named init drops metrics

## [0.16.2] - 2025-06-05

- feat(gfn): enable gpu metrics at icms instance level
- fix(gfn): drop metrics which have label pod=workload-0

## [0.16.1] - 2025-06-05

- fix(gfn-task-helm): update the blacklist

## [0.16.0] - 2025-06-05

- fix: update the configuration according to the golden test result
    - Container type NVCF/NVCT on GFN
        - only keep pod workload-0
        - exclude the metrics which has label interface=\~(STORAGE|.*_cali.*)
    - Helm type NVCF/NVCT on GFN
        - exclude the metrics which has label deployment="worker-0", replicaset=~"worker-0-.*", pod=~"worker-0-.*"
        - exclude the metrics which has label service="worker-0"
        - exclude the metrics which has label secret=~"mini-service-.*|worker-0-core"

## [0.15.9] - 2025-06-04

- fix: NVBUG-5298052 drop metrics with kube_secret_created label

## [0.15.8] - 2025-06-04

- fix: add missing otelcol_receiver_[accepted|refused]_spans_total metric to allow list

## [0.15.7] - 2025-06-03

- chore: update docs for azuremonitor

## [0.15.6] - 2025-06-03

- fix: allow labels image, resource, unit for container type functions/tasks

## [0.15.5] - 2025-06-02

- fix: NVCF-4977 fix tracing environment variable name

## [0.15.4] - 2025-06-02

- chore: update otelcol-contrib version NVCF-5385

## [0.15.3] - 2025-05-27

- feat: add span events to azuremonitor

## [0.15.2] - 2025-05-27

- fix: NVBUG-5298052 drop metrics with kube_secret_created label and NVBUG-5298044 drop metrics with unexpected container labels

## [0.15.1] - 2025-05-26

- fix: processors order and batch size/timeout value

## [0.15.0] - 2025-05-22

- feat(traces): NVCF-4977 add internal traces telemetry rendering logic to otelconfig

## [0.14.1] - 2025-05-22

- fix: kratos logs collector id

## [0.14.0] - 2025-05-21

- feat: support azure monitor provider NVCF-5168

## [0.13.1] - 2025-05-21

- fix: scrape internal for otelcol job nvbug5247913

## [0.13.0] - 2025-05-19

- feat: kratos logs provider support NVCF-5111

## [0.12.9] - 2025-05-14

- fix: nvbug-5242534 drop metrics which have label container=nvcf-cert-inject

## [0.12.8] - 2025-05-13

- feat: NVCF-4095 add generator pre-commit, ci job and update the config template

## [0.12.7] - 2025-05-12

- fix: kube_service_create must not exists for byoo-otel-collector

## [0.12.6] - 2025-05-08

- feat: include healthcheck v2 extensions in all configs
- fix: NVCF-5011 rename the envs "INSTANCE_ID" and "ZONE_NAME"

## [0.12.5] - 2025-05-07

- feat: add public key/value for exposing byoo logs

## [0.12.4] - 2025-05-06

- feat: NVCF-4095 add config template and markdown generator

## [0.12.3] - 2025-04-30

- fix: drop unneeded metrics for those with label configmap=kube-root-ca.crt

## [0.12.2] - 2025-04-24

- fix: drop unneeded metrics for those with label container=gxcache-lib-install

## [0.12.1] - 2025-04-21

- fix: NVCF-4055 remove the old prometheus-nvcf-byoo from scraping target

## [0.12.0] - 2025-04-16

- feat: NVCF-3858 support new telemetry provider "Kratos Thanos"

## [0.11.2] - 2025-04-15

- fix(byoo): NVCF-3686 update 0.0.0.0 to OTEL_POD_IP

## [0.11.1] - 2025-04-09

- fix: NVCF-4055 federate the metrics from new nvcf-byoo-prometheus URL

## [0.11.0] - 2025-04-07

- feat!: use SRE recommended ports for collector

## [0.10.2] - 2025-04-01

- fix(k8s-helm): remove metrics that should not be exported

## [0.10.1] - 2025-03-31

- fix: secrets and configmap metrics only for non nvcf containers

## [0.10.0] - 2025-03-31

- update: drop support to inference:8002 (triton) metrics
- fix: nvbug-5194849 add attribute host.id

## [0.9.4] - 2025-03-26

- fix: container_network metrics, container is empty label

## [0.9.3] - 2025-03-25

- fix: kube_replicaset_status_ready_replicas instead of kube_replicaset_status_replicas_ready

## [0.9.2] - 2025-03-21

- fix(k8s-*): rename the kubelet job to kubernetes-cadvisor
- fix: add cloud region for non-GFN
- chore: improve readme

## [0.9.1] - 2025-03-19

- fix: attribute name for GFN
- fix: metrics path for cadvisor

## [0.9.0] - 2025-03-18

- fix: unity the job names for metrics
- fix: move the filtering logic from processors to the Prometheus receiver
- fix: update the metrics/labels allowlist for Prometheus jobs
- fix(vm-*): remove labelmap from job kubernetes-cadvisor to delete redundant labels
- fix(vm-*): fix tls_config and relabel_configs for job kubernetes-cadvisor

## [0.8.11] - 2025-03-17

- fix(k8s-container): update the pod and container filter
- fix(*-container): replace labeldrop with labelkeep
- fix(k8s-container): add cloud_provider attribute/label
- fix(k8s-container): fix federate query for job nvidia-dcgm-exporter
- fix(vm-*): change the cloud_provider value to lowercase

## [0.8.10] - 2025-03-14

- fix(k8s-container): add pod filter for nvidia-dcgm-exporter job
- fix(vm-container): only collect metrics from default namespace for job kubernetes-nodes-cadvisor and metrics-dcgm
- fix(vm-helm): only collect metrics from mini-service namespace for job metrics-dcgm
- fix(helm): add kube_job_status_completed into the allowlist
- fix(k8s-container): remove redundant kube_.* metrics from the allowlist

## [0.8.9] - 2025-03-12

- fix: pod name for container non-gfn functions

## [0.8.8] - 2025-03-12

- fix: timestamp from client for cadvisor

## [0.8.7] - 2025-03-11

- fix: non-gfn container metrics

## [0.8.6] - 2025-03-11

- fix: cadvisor metrics

## [0.8.5] - 2025-03-10

- feat: zoneName label

## [0.8.4] - 2025-02-27

- fix: > 40 labels for Grafana Cloud
- chore: clean up processors
- feat: add instanceID to metadata

## [0.8.3] - 2025-02-26

- fix: remove infra related metrics

## [0.8.2] - 2025-02-25

- fix: delete datapoints for otel and mutating-webhook

## [0.8.1] - 2025-02-24

- fix: pattern instead of key
- fix: labels to be dropped
- feat: add cloud_provider as per SRD

## [0.8.0] - 2025-02-20

- feat: support NVCT
- fix: drop all up metrics except for byoo

## [0.7.3] - 2025-02-19

- fix: rm inference for helm and drop labels

## [0.7.2] - 2025-02-18

- fix: label for NVCT

## [0.7.1] - 2025-02-18

- chore: filter metrics and labels

## [0.7.0] - 2025-02-14

- feat: add metadata processor to logs and traces

## [0.6.8] - 2025-02-14

- chore: add example with long path

## [0.6.7] - 2025-02-14

- chore: bump otel collector for validation

## [0.6.6] - 2025-02-12

- feat: expose metrics endpoint

## [0.6.5] - 2025-02-07

- fix: update the federate job of prometheus receiver

## [0.6.4] - 2025-02-04

- fix: protocol is always lowercase for the lib

## [0.6.3] - 2025-01-29

- fix: metrics for GFN container and kube
- feat: filter not required metrics

## [0.6.2] - 2025-01-24

- fix: helm string

## [0.6.2] - 2025-01-24

- fix: tagging

## [0.6.1] - 2025-01-24

- fix: rm backends from config

## [0.6.0] - 2025-01-24

- feat: template function vars MR19
- feat: function types

## [0.5.0] - 2025-01-24

- feat: GFN config for Helm and container functions

## [0.4.3] - 2025-01-24

- fix: update basic otel configruation for non-GFN env
- fix: use filepath.join to concat the file path

## [0.4.2] - 2025-01-23

- fix: add kube_deployment_status_condition to BYOC metrics list

## [0.4.1] - 2025-01-23

- fix: autotag

## [0.4.0] - 2025-01-23

- fix: explicit list of KSM

## [0.3.2] - 2025-01-23

- fix: ci pipeline, metrics query

## [0.3.1] - 2025-01-22

- chore: ci pipeline autotag

## [0.3.0] - 2025-01-21

- fix: support prometheus receiver

## [0.2.0] - 2025-01-17

- fix: add top level telemetries field
