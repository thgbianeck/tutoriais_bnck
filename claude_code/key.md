key: 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

curl https://api.anthropic.com/v1/messages \
  --header "x-api-key: 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" \
  --header "anthropic-version: 2023-06-01" \
  --header "content-type: application/json" \
  --data '{"model": "claude-sonnet-4-6", "max_tokens": 1024,
    "messages": [{"role": "user", "content": "Hello, world"}]}'