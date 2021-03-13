# slack
Send messages via slack

## `slack::message_webhook <message>`
Send a message using incoming webhooks

### Example
```sh
bee slack::message_webhook "Build complete"
```

## `slack::message <channel> <message> [<parent-timestamp>]`
Send a message using https://slack.com/api/chat.postMessage

### Example
```sh
bee slack::message ABCD12345 "Build complete"
```

## `slack::upload <channels> <message> <file> [<parent-timestamp]>`
Send a message and upload a file using https://slack.com/api/files.upload

----------------------------------------

## Dependencies

### 3rd party
- `Slack` - https://slack.com
- `curl`
