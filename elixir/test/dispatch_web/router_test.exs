defmodule DispatchWeb.RouterTest do
  use ExUnit.Case, async: true
  import Plug.Test
  import Plug.Conn

  @opts DispatchWeb.Router.init([])

  defp post_json(path, body) do
    conn(:post, path, Jason.encode!(body))
    |> put_req_header("content-type", "application/json")
    |> DispatchWeb.Router.call(@opts)
  end

  test "health" do
    conn = conn(:get, "/health") |> DispatchWeb.Router.call(@opts)
    assert conn.status == 200
  end

  test "assigns a load to a truck" do
    conn = post_json("/loads/L-17/assign", %{origin: "CHI", destination: "DEN", pallets: 12, truck: "T-4"})
    assert conn.status == 200
    assert %{"id" => "L-17", "truck" => "T-4"} = Jason.decode!(conn.resp_body)
  end

  test "refuses an overweight load" do
    conn = post_json("/loads/L-18/assign", %{origin: "CHI", destination: "DEN", pallets: 30, truck: "T-4"})
    assert conn.status == 422
  end
end
