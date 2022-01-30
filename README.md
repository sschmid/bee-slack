# slack
Send messages via slack

https://github.com/sschmid/bee-slack

```
secrets:

  SLACK_WEBHOOK
  SLACK_TOKEN

usage:

  message_webhook                                           send a message using incoming webhooks
                                                            e.g. bee slack message_webhook "Build complete"
  message <channel> <message> [<parent-timestamp>]          send a message using https://slack.com/api/chat.postMessage
                                                            e.g. bee slack message ABCD12345 "Build complete"
  upload <channels> <message> <file> [<parent-timestamp]>   send a message and upload a file using https://slack.com/api/files.upload

requirements:

  slack   https://slack.com
  curl
```
