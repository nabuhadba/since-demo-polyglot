import Config

config :dispatch,
  port: 4040,
  # Load summaries for the dispatch board. Claude writes them; dispatchers read every one.
  summary_model: "claude-sonnet-5-5",
  anthropic_url: ~c"https://api.anthropic.com/v1/messages"

import_config "#{config_env()}.exs"
