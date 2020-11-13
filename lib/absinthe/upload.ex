defmodule Absinthe.Upload do
  @moduledoc """
  Documentation for `Absinthe.Upload`.
  """

  def init(conn), do: conn

  def call(%{body_params: %{"map" => mvars}} = conn, _) do
    with {:ok, map_json} <- Jason.decode(mvars) do
      query = get_operations(conn)
      upload_params = get_upload_params(conn, map_json)
      drop_keys = Map.keys(map_json) ++ ["operations", "map"]

      conn
      |> Map.update!(:params, fn x ->
        x
        |> Map.put("query", query)
        |> Map.drop(drop_keys)
        |> Enum.into(upload_params)
      end)
    else
      _ -> conn
    end
  end

  def call(conn, _), do: conn

  defp get_upload_params(conn, json) do
    Enum.reduce(json, %{}, fn {a, [b]}, acc ->
      key = b |> String.split(".") |> List.last()
      value = conn |> Map.get(:params) |> Map.get(a)

      Map.put(acc, key, value)
    end)
  end

  defp get_operations(%{:body_params => %{"operations" => j}}) do
    case Jason.decode(j) do
      {:ok, m} -> m |> Map.get("query") |> String.replace("\n", "")
      {:error, _reason} -> nil
    end
  end

  defp get_operations(_conn), do: nil
end
