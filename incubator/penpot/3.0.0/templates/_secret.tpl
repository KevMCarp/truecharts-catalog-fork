{{/* Define the secret */}}
{{- define "penpot.secret" -}}

{{- $commonSecretName := printf "%s-common-secret" (include "tc.common.names.fullname" .) }}
{{- $exporterSecretName := printf "%s-exporter-secret" (include "tc.common.names.fullname" .) }}
{{- $frontendSecretName := printf "%s-frontend-secret" (include "tc.common.names.fullname" .) }}
{{- $backendAndExporterSecretName := printf "%s-backend-exporter-secret" (include "tc.common.names.fullname" .) }}

{{- $backendFlags := list }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-smtp" (ternary "enable" "disable" .Values.penpot.smtp.enabled)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-email-verification" (ternary "enable" "disable" .Values.penpot.flags.mail_verification)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-log-invitation-tokens" (ternary "enable" "disable" .Values.penpot.flags.log_invitation_token)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-log-emails" (ternary "enable" "disable" (and .Values.penpot.flags.log_emails (not .Values.penpot.smtp.enabled)))) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-secure-session-cookies" (ternary "enable" "disable" .Values.penpot.flags.secure_session_cookies)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-insecure-register" (ternary "enable" "disable" .Values.penpot.flags.insecure_register)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-cors" (ternary "enable" "disable" .Values.penpot.flags.backend_api_doc)) }}
{{- $backendFlags = mustAppend $backendFlags (printf "%s-backend-api-doc" (ternary "enable" "disable" .Values.penpot.flags.backend_api_doc)) }}

{{- $frontendFlags := list }}
{{- $frontendFlags = mustAppend $frontendFlags (printf "%s-demo-warning" (ternary "enable" "disable" .Values.penpot.flags.demo_warning)) }}

{{- $commonFlags := list }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login" (ternary "enable" "disable" .Values.penpot.flags.login)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-registration" (ternary "enable" "disable" .Values.penpot.flags.registration)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-demo-users" (ternary "enable" "disable" .Values.penpot.flags.demo_users)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-user-feedback" (ternary "enable" "disable" .Values.penpot.flags.user_feedback)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login-with-google" (ternary "enable" "disable" .Values.penpot.identity_providers.google.enabled)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login-with-github" (ternary "enable" "disable" .Values.penpot.identity_providers.github.enabled)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login-with-gitlab" (ternary "enable" "disable" .Values.penpot.identity_providers.gitlab.enabled)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login-with-oidc" (ternary "enable" "disable" .Values.penpot.identity_providers.oidc.enabled)) }}
{{- $commonFlags = mustAppend $commonFlags (printf "%s-login-with-ldap" (ternary "enable" "disable" .Values.penpot.identity_providers.ldap.enabled)) }}

---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $commonSecretName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
stringData:
  PENPOT_TELEMETRY_ENABLED: {{ .Values.penpot.telemetry_enabled | quote }}
  {{- with .Values.penpot.registration_domain_whitelist }}
  PENPOT_REGISTRATION_DOMAIN_WHITELIST: {{ join "," . }}
  {{- end }}
  {{- if .Values.penpot.identity_providers.google.enabled }}
  PENPOT_GOOGLE_CLIENT_ID: {{ .Values.penpot.identity_providers.google.client_id | quote }}
  PENPOT_GOOGLE_CLIENT_SECRET: {{ .Values.penpot.identity_providers.google.client_secret | quote }}
  {{- end }}
  {{- if .Values.penpot.identity_providers.github.enabled }}
  PENPOT_GITHUB_CLIENT_ID: {{ .Values.penpot.identity_providers.github.client_id | quote }}
  PENPOT_GITHUB_CLIENT_ID: {{ .Values.penpot.identity_providers.github.client_secret | quote }}
  {{- end }}
  {{- if .Values.penpot.identity_providers.gitlab.enabled }}
  PENPOT_GITLAB_BASE_URI: {{ .Values.penpot.identity_providers.gitlab.base_uri | quote }}
  PENPOT_GITLAB_CLIENT_ID: {{ .Values.penpot.identity_providers.gitlab.client_id | quote }}
  PENPOT_GITLAB_CLIENT_SECRET: {{ .Values.penpot.identity_providers.gitlab.client_secret | quote }}
  {{- end }}
  {{- if .Values.penpot.identity_providers.oidc.enabled }}
  PENPOT_OIDC_BASE_URI: {{ .Values.penpot.identity_providers.oidc.base_uri | quote }}
  PENPOT_OIDC_CLIENT_ID: {{ .Values.penpot.identity_providers.oidc.client_id | quote }}
  PENPOT_OIDC_CLIENT_SECRET: {{ .Values.penpot.identity_providers.oidc.client_secret | quote }}
  {{- end }}
  {{- if .Values.penpot.identity_providers.ldap.enabled }}
  PENPOT_LDAP_HOST: {{ .Values.penpot.identity_providers.ldap.host | quote }}
  PENPOT_LDAP_PORT: {{ .Values.penpot.identity_providers.ldap.port | quote }}
  PENPOT_LDAP_SSL: {{ .Values.penpot.identity_providers.ldap.ssl | quote }}
  PENPOT_LDAP_STARTTLS: {{ .Values.penpot.identity_providers.ldap.starttls | quote }}
  PENPOT_LDAP_BASE_DN: {{ .Values.penpot.identity_providers.ldap.base_dn | quote }}
  PENPOT_LDAP_BIND_DN: {{ .Values.penpot.identity_providers.ldap.bind_dn | quote }}
  PENPOT_LDAP_BIND_PASSWORD: {{ .Values.penpot.identity_providers.ldap.bind_pass | quote }}
  PENPOT_LDAP_ATTRS_USERNAME: {{ .Values.penpot.identity_providers.ldap.attrs_username | quote }}
  PENPOT_LDAP_ATTRS_EMAIL: {{ .Values.penpot.identity_providers.ldap.attrs_email | quote }}
  PENPOT_LDAP_ATTRS_FULLNAME: {{ .Values.penpot.identity_providers.ldap.attrs_fullname | quote }}
  {{- end }}
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $exporterSecretName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
stringData:
  PENPOT_PUBLIC_URI: http://penpot-frontend:{{ .Values.service.main.ports.main.targetPort }}
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $backendAndExporterSecretName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
stringData:
  PENPOT_FLAGS: {{ join " " (concat $commonFlags $backendFlags) | quote }}
  PENPOT_PUBLIC_URI: {{ .Values.penpot.public_uri | quote }}
  {{- with (lookup "v1" "Secret" .Release.Namespace $backendAndExporterSecretName) }}
  PENPOT_SECRET_KEY: {{ index .data "PENPOT_SECRET_KEY" }}
  {{- else }}
  PENPOT_SECRET_KEY: {{ randAlphaNum 32 | b64enc }}
  {{- end }}
  {{/* Dependencies */}}
  PENPOT_DATABASE_URI: {{ printf "postgresql://%v/%v" (.Values.postgresql.url.plainport | trimAll "\"") .Values.postgresql.postgresqlDatabase }}
  PENPOT_DATABASE_USERNAME: {{ .Values.postgresql.postgresqlUsername }}
  PENPOT_DATABASE_PASSWORD: {{ .Values.postgresql.postgresqlPassword | trimAll "\"" }}
  PENPOT_REDIS_URI: {{ printf "redis://%v:%v@%v/%v" "default" (.Values.redis.redisPassword | trimAll "\"") (.Values.redis.url.plainport | trimAll "\"") "0" }}
  {{/* Penpot */}}
  {{- if .Values.penpot.smtp.enabled }}
  PENPOT_SMTP_DEFAULT_FROM: {{ .Values.penpot.smtp.default_from | quote }}
  PENPOT_SMTP_DEFAULT_REPLY_TO: {{ .Values.penpot.smtp.default_reply_to | quote }}
  PENPOT_SMTP_HOST: {{ .Values.penpot.smtp.host | quote }}
  PENPOT_SMTP_PORT: {{ .Values.penpot.smtp.port | quote }}
  PENPOT_SMTP_USERNAME: {{ .Values.penpot.smtp.user | quote }}
  PENPOT_SMTP_PASSWORD: {{ .Values.penpot.smtp.pass | quote }}
  PENPOT_SMTP_TLS: {{ .Values.penpot.smtp.tls | quote }}
  PENPOT_SMTP_SSL: {{ .Values.penpot.smtp.ssl | quote }}
  {{- end }}
  PENPOT_STORAGE_ASSETS_FS_DIRECTORY: {{ .Values.persistence.assets.mountPath }}
  PENPOT_ASSETS_STORAGE_BACKEND: assets-fs
  PENPOT_HTTP_SERVER_HOST: "0.0.0.0"
---
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: {{ $frontendSecretName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
stringData:
  PENPOT_PUBLIC_URI: {{ .Values.penpot.public_uri | quote }}
  PENPOT_FLAGS: {{ join " " (concat $commonFlags $frontendFlags) | quote }}
{{- end }}
