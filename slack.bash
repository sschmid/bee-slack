slack::help() {
  cat << 'EOF'
Send messages via slack - https://github.com/sschmid/bee-slack

secrets:

  SLACK_WEBHOOK
  SLACK_TOKEN

usage:

  message_webhook                                           send a message using incoming webhooks
                                                            e.g. bee slack message_webhook "Build complete"
  message <channel> <message> [<parent-timestamp>]          send a message using https://slack.com/api/chat.postMessage
                                                            e.g. bee slack message ABCD12345 "Build complete"
  upload <channels> <message> <file> [<parent-timestamp]>   send a message and upload a file using https://slack.com/api/files.upload

bee dependencies:

  none

dependencies:

  slack   https://slack.com
  curl

EOF
}

slack::message_webhook() {
  local message="$1"
  curl -s -X POST \
    -H 'Content-type: application/json' \
    --data "{\"text\":\"${message}\"}" \
    "${SLACK_WEBHOOK}"

  echo
}

slack::message() {
  local channel="$1" message="$2" parent_ts="${3:-}" json
  json=$(cat << EOF
{
  "channel": "${channel}",
  "thread_ts": "${parent_ts}",
  "text": "${message}"
}
EOF
  )
  curl -s -X POST \
    -H 'Content-type: application/json' \
    -H "Authorization: Bearer ${SLACK_TOKEN}" \
    --data "$json" \
    https://slack.com/api/chat.postMessage

  echo
}

slack::upload() {
  local channels="$1" message="$2" file="$3" parent_ts="${4:-}" json
  json=$(cat << EOF
{
  "file": "@${file}",
  "thread_ts": "${parent_ts}",
  "initial_comment": "${message}",
  "channels": "${channels}"
}
EOF
  )
  curl -s \
    -H "Authorization: Bearer ${SLACK_TOKEN}" \
    -F "thread_ts=${parent_ts}" \
    -F "initial_comment=${message}" \
    -F "channels=${channels}" \
    -F "file=@${file}" \
    https://slack.com/api/files.upload

  echo
}
