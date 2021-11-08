{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "aistemplate.name" -}}
{{- default .Chart.Name .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "aistemplate.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*

*/}}
{{- define "aistemplate.cotainerName" -}}
{{- if contains "candidate" .Values.release.stage -}}
{{ include "aistemplate.fullname" . | trunc 53 }}-candidate
{{- else -}}
{{ include "aistemplate.fullname" . }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "aistemplate.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "aistemplate.labels" -}}
app: {{ include "aistemplate.name" . }}
release: {{ .Values.release.stage }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "aistemplate.selectorLabels" -}}
app: {{ include "aistemplate.name" . }}
release: {{ .Values.release.stage }}
{{- end -}}

{{/*
Service Selector labels
*/}}
{{- define "aistemplate.selectorServiceLabels" -}}
app: {{ include "aistemplate.name" . }}
{{- end -}}


{{/*
Replicas Count
*/}}
{{- define "aistemplate.replicas" -}}
{{- if eq .Values.release.stage "candidate" -}}
    1
{{- else -}}
{{- if eq .Values.deploymentEnvironment "dev" -}}
    {{ .Values.environment.dev.replicaCount | default 1 }}
{{- end -}}
{{- if eq .Values.deploymentEnvironment "sit" -}}
    {{ .Values.environment.sit.replicaCount | default 1 }}
{{- end -}}
{{- if eq .Values.deploymentEnvironment "uat" -}}
    {{ .Values.environment.uat.replicaCount | default 3 }}
{{- end -}}
{{- if eq .Values.deploymentEnvironment "prd" -}}
    {{ .Values.environment.prd.replicaCount | default 3 }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Image Repository
*/}}
{{- define "aistemplate.imageRepositry" -}}
{{- $environment := get .Values.environment .Values.deploymentEnvironment -}}
{{ $environment.containerRegistry }}{{ dir .Values.image.repository }}
{{- if hasPrefix  "prd" .Values.deploymentEnvironment  -}}
{{- end -}}
{{ base .Values.image.repository }}
{{- end -}}

{{/*
Container Registry URL
*/}}
{{- define "aistemplate.containerRegistryURL" -}}
{{- $environment := get .Values.environment .Values.deploymentEnvironment -}}
{{ $environment.containerRegistry }}{{ .Values.image.repository }}
{{- end -}}

{{/*
Ingress Hostname
*/}}
{{- define "aistemplate.ingressHostname" -}}
{{- $environment := get .Values.environment .Values.deploymentEnvironment -}}
{{- if $environment.prefixNamespace -}}
    {{ .Values.deploymentEnvironment }}-
{{- end -}}
{{ .Values.projectDomainName}}.{{ $environment.dnsName }}
{{- end -}}

{{/*
Environment Uppercase
*/}}
{{- define "aistemplate.envUpper" -}}
{{ .Values.deploymentEnvironment | upper }}
{{- end -}}

{{/*
Namespace
*/}}
{{- define "aistemplate.namespace" -}}
{{ .Values.projectName}}
{{- $environment := get .Values.environment .Values.deploymentEnvironment -}}
{{- if $environment.suffixNamespace -}}
-{{ .Values.deploymentEnvironment }}
{{- end -}}
{{- end -}}


{{/*
Elastic Hostname
*/}}
{{- define "aistemplate.elasticHost" -}}
{{- $environment := get .Values.environment .Values.deploymentEnvironment -}}
{{ $environment.elasticHost }}
{{- end -}}


{{/*
Mock Weight - External
*/}}
{{- define "aistemplate.externalWeight" -}}
{{- $candidate := index . -}}
{{- if $candidate -}}
{{ "0" }}
{{- else -}}
{{ "100" }}
{{- end -}}
{{- end -}}

{{/*
Mock Weight - Mock
*/}}
{{- define "aistemplate.mockWeight" -}}
{{- $candidate := index . -}}
{{- if $candidate -}}
{{ "100" }}
{{- else -}}
{{ "0" }}
{{- end -}}
{{- end -}}