defmodule Dispatch.Summaries do
  @moduledoc "Writes the one-line summary the dispatch board shows for each load."

  def request_body(load) do
    %{
      model: Application.fetch_env!(:dispatch, :summary_model),
      max_tokens: 200,
      temperature: Application.fetch_env!(:dispatch, :summary_temperature),
      messages: [
        %{role: "user", content: "Summarize this load for a dispatcher in one line: #{Jason.encode!(load)}"}
      ]
    }
  end

  def summarize(load) do
    url = Application.fetch_env!(:dispatch, :anthropic_url)
    key = Application.get_env(:dispatch, :anthropic_api_key, "")
    headers = [{~c"x-api-key", String.to_charlist(key)}, {~c"anthropic-version", ~c"2023-06-01"}]
    body = Jason.encode!(request_body(load))

    case :httpc.request(:post, {url, headers, ~c"application/json", body}, [timeout: 15_000], []) do
      {:ok, {{_, 200, _}, _, response}} ->
        %{"content" => [%{"text" => text} | _]} = Jason.decode!(response)
        {:ok, String.trim(text)}

      {:ok, {{_, status, _}, _, _}} ->
        {:error, {:status, status}}

      {:error, reason} ->
        {:error, reason}
    end
  end
end
