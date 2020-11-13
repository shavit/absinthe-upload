defmodule Absinthe.Upload do
  @moduledoc """
  Documentation for `Absinthe.Upload`.
  """

  def init(conn), do: conn

  def call(%{body_params: %{"map" => mvars}} = conn, _) do
    map_json = Jason.decode!(mvars)
    drop_keys = Map.keys(map_json) ++ ["operations", "map"]

    upload_params = get_upload_params(conn, map_json)
    query = get_operations(conn)

    conn
    |> Map.update(:params, conn.params, fn x ->
      x
      |> Map.put("query", query)
      |> Map.drop(drop_keys)
      |> Enum.into(upload_params)
    end)
  end

  def call(conn, _), do: conn

  defp get_upload_params(conn, json) do
    json
    |> Enum.reduce(%{}, fn {a, [b]}, acc ->
      key = b |> String.split(".") |> List.last()
      value = conn |> Map.get(:params) |> Map.get(a)

      Map.put(acc, key, value)
    end)
  end

  defp get_operations(%{:body_params => %{"operations" => j}}) do
    j |> Jason.decode!() |> Map.get("query") |> String.replace("\n", "")
  end

  defp get_operations(_conn), do: nil
end
