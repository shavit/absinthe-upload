defmodule Absinthe.Upload do
  @moduledoc """
  Documentation for `Absinthe.Upload`. Absinthe plug to support Apollo upload format

  Add the plug to your app

  ```
  # app/router.ex
  defmodule App.Router do
    plug(Absinthe.Upload)
    ...
  ```

  Requests with file uploads from Apollo clients has `"map"` and `"operations"`
  ```
  %{
  "0" => %Plug.Upload{},
    "map" => "{\"0\":[\"variables.attachment\"]}",
    "operations" => "{\"query\":\"mutation DemoUpload($attachment: Upload) {\\n  demoUpload(attachment: $attachment)\\n}\",\"variables\":{\"attachment\":null},\"operationName\":\"DemoUpload\"}"
  }
  ```

  The plug will transform the request to a format Absinthe understands
  ```
  %{
    "attachment" => %Plug.Upload{},
    "query" => "mutation DemoUpload($attachment: Upload) {  demoUpload(attachment: $attachment)}"
  }
  ```
  """

  def init(conn), do: conn

  def call(%{body_params: %{"map" => mvars}} = conn, _) do
    with {:ok, map_json} <- Jason.decode(mvars) do
      query = get_operations(conn)
      upload_params = get_upload_params(conn, map_json)
      variables = conn |> get_variables(upload_params)
      drop_keys = Map.keys(map_json) ++ ["operations", "map"]

      conn
      |> Map.update!(:params, fn x ->
        x
        |> Map.put("query", query)
        |> Map.put("variables", variables)
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

  defp get_variables(%{:body_params => %{"operations" => j}}, params) do
    vars = j |> Jason.decode!() |> Map.get("variables")

    params
    |> Enum.reduce(%{}, fn {k, _v}, acc -> Map.put(acc, k, k) end)
    |> Enum.into(vars)
  end

  defp get_variables(_conn, _params), do: %{}
end
