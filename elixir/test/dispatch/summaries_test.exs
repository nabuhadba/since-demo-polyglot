defmodule Dispatch.SummariesTest do
  use ExUnit.Case, async: true

  test "the request names the configured model" do
    body = Dispatch.Summaries.request_body(%{id: "L-17", origin: "CHI", destination: "DEN", pallets: 12})
    assert body.model == Application.fetch_env!(:dispatch, :summary_model)
    assert body.max_tokens == 200
  end
end
