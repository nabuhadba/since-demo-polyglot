defmodule DispatchWeb.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug Plug.Parsers, parsers: [:json], json_decoder: Jason
  plug :dispatch

  get "/health" do
    send_resp(conn, 200, "ok")
  end

  post "/loads/:id/assign" do
    params = conn.body_params
    load = %{id: id, origin: params["origin"], destination: params["destination"], pallets: params["pallets"]}

    case Dispatch.Loads.assign(load, params["truck"]) do
      {:ok, assigned} -> json(conn, 200, assigned)
      {:error, :too_heavy} -> json(conn, 422, %{error: "too many pallets for one truck"})
    end
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

  defp json(conn, status, body) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Jason.encode!(body))
  end
end
