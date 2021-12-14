#!/usr/bin/env bash

slack::_new() {
  echo '# slack'
  echo '# secrets:
# slack.webhook
# slack.token'
}

slack::message_webhook() {
  local message="$1" webhook
  webhook="$(bee::secrets slack.webhook)"
  curl -s -X POST \
    -H 'Content-type: application/json' \
    --data "{\"text\":\"${message}\"}" \
    "${webhook}"

  echo
}

slack::message() {
  local channel="$1" message="$2" parent_ts="${3:-}" json token
  token="$(bee::secrets slack.token)"
  json=$(cat <<EOF
{
  "channel": "${channel}",
  "thread_ts": "${parent_ts}",
  "text": "${message}"
}
EOF
)
  curl -s -X POST \
    -H 'Content-type: application/json' \
    -H "Authorization: Bearer ${token}" \
    --data "$json" \
    https://slack.com/api/chat.postMessage

  echo
}

slack::upload() {
  local channels="$1" message="$2" file="$3" parent_ts="${4:-}" json token
  token="$(bee::secrets slack.token)"
  json=$(cat <<EOF
{
  "file": "@${file}",
  "thread_ts": "${parent_ts}",
  "initial_comment": "${message}",
  "channels": "${channels}"
}
EOF
)
  curl -s \
    -H "Authorization: Bearer ${token}" \
    -F "thread_ts=${parent_ts}" \
    -F "initial_comment=${message}" \
    -F "channels=${channels}" \
    -F "file=@${file}" \
    https://slack.com/api/files.upload

  echo
}
