{{/* Define the cronjob */}}
{{- define "linkace.cronjob" -}}
{{- if .Values.secret.CRON_TOKEN }}
{{- $jobName := include "tc.common.names.fullname" . }}

---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: {{ printf "%s-cronjob" $jobName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
spec:
  schedule: "{{ .Values.cronjob.schedule }}"
  concurrencyPolicy: Forbid
  {{- with .Values.cronjob.failedJobsHistoryLimit }}
  failedJobsHistoryLimit: {{ . }}
  {{- end }}
  {{- with .Values.cronjob.successfulJobsHistoryLimit }}
  successfulJobsHistoryLimit: {{ . }}
  {{- end }}
  jobTemplate:
    metadata:
    spec:
      template:
        metadata:
        spec:
          securityContext:
            runAsUser: 568
            runAsGroup: 568
          restartPolicy: Never
          containers:
            - name: {{ .Chart.Name }}
              securityContext:
                privileged: false
                readOnlyRootFilesystem: true
                allowPrivilegeEscalation: false
                runAsNonRoot: true
                capabilities:
                  drop:
                    - ALL
              env:
                - name: CRON_TOKEN
                  value: {{ .Values.secret.CRON_TOKEN }}
              image: "{{ .Values.ubuntuImage.repository }}:{{ .Values.ubuntuImage.tag }}"
              args:
              - curl
              - "http://{{ $jobName }}.ix-{{ .Release.Name }}.svc.cluster.local:{{ .Values.service.main.ports.main.port }}/cron/$(CRON_TOKEN)"
              resources:
{{ toYaml .Values.resources | indent 16 }}

{{- end -}}
{{- end }}
