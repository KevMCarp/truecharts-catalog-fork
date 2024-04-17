{{/* Define the secrets */}}
{{- define "linkace.secrets" -}}
---

apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: linkace-secrets
{{- $linkaceprevious := lookup "v1" "Secret" .Release.Namespace "linkace-secrets" }}
{{- $app_key := "" }}
data:
  {{- if $linkaceprevious}}
  APP_KEY: {{ index $linkaceprevious.data "APP_KEY" }}
  {{- else }}
  {{- $app_key := randAlphaNum 32 }}
  APP_KEY: {{ $app_key | b64enc }}
  {{- end }}

{{- end -}}
