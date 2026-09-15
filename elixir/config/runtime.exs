import Config

if config_env() == :prod do
  config :dispatch,
    port: String.to_integer(System.get_env("PORT", "4040")),
    anthropic_api_key: System.fetch_env!("ANTHROPIC_API_KEY")
end
