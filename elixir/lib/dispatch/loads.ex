defmodule Dispatch.Loads do
  @moduledoc "The loads waiting for a truck. Backed by the ledger API in production."

  @type load :: %{id: String.t(), origin: String.t(), destination: String.t(), pallets: pos_integer()}

  @spec assign(load(), String.t()) :: {:ok, map()} | {:error, :too_heavy}
  def assign(%{pallets: pallets}, _truck) when pallets > 26, do: {:error, :too_heavy}
  def assign(load, truck), do: {:ok, Map.put(load, :truck, truck)}
end
