#!/usr/bin/env bash

slack::_new() {
  echo '# slack'
  echo '# Potentially sensitive data. Do not commit.
SLACK_WEBHOOK_URL="https://hooks.slack.com/services/abc123"
SLACK_AUTH_TOKEN="xoxa-xxxxxxxxx-xxxx"'
}

slack::message_webhook() {
  local message="$1"
  curl -s -X POST \
    -H 'Content-type: application/json' \
    --data "{\"text\":\"${message}\"}" \
    "${SLACK_WEBHOOK_URL}"

  echo
}

slack::message() {
  local channel="$1"
  local message="$2"
  local parent_ts="${3:-}"
  local json=$(cat <<EOF
{
  "channel": "${channel}",
  "thread_ts": "${parent_ts}",
  "text": "${message}"
}
EOF
)
  curl -s -X POST \
    -H 'Content-type: application/json' \
    -H "Authorization: Bearer ${SLACK_AUTH_TOKEN}" \
    --data "$json" \
    https://slack.com/api/chat.postMessage

  echo
}

slack::upload() {
  local channels="$1"
  local message="$2"
  local file="$3"
  local parent_ts="${4:-}"
  local json=$(cat <<EOF
{
  "file": "@${file}",
  "thread_ts": "${parent_ts}",
  "initial_comment": "${message}",
  "channels": "${channels}"
}
EOF
)
  curl -s \
    -H "Authorization: Bearer ${SLACK_AUTH_TOKEN}" \
    -F "thread_ts=${parent_ts}" \
    -F "initial_comment=${message}" \
    -F "channels=${channels}" \
    -F "file=@${file}" \
    https://slack.com/api/files.upload

  echo
}
