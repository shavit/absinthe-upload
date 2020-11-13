defmodule Absinthe.UploadTest do
  use ExUnit.Case
  doctest Absinthe.Upload
  alias Absinthe.Upload

  test "init/1 pass the conn" do
    assert Upload.init(%{}) == %{}
  end

  test "conn/2 transforms request parameters" do
    params_ = %{
      "0" => %{
        content_type: "text/rtf",
        filename: "San Francisco.rtf",
        path: "/tmp/plug-1605/multipart-1605259564-858222931410900-3"
      },
      "map" => "{\"0\":[\"variables.attachment.0\"]}",
      "operations" =>
        "{\"query\":\"mutation DemoUpload($attachment: Upload) {\\n  demoUpload(attachment: $attachment)\\n}\",\"variables\":{\"attachment\":[null]},\"operationName\":\"DemoUpload\"}"
    }

    opts = []

    conn = Upload.call(%{body_params: params_, params: params_}, opts)
    assert %{params: params} = conn

    assert params["query"] ==
             "mutation DemoUpload($attachment: Upload) {  demoUpload(attachment: $attachment)}"

    assert params["0"] == %{
             content_type: "text/rtf",
             filename: "San Francisco.rtf",
             path: "/tmp/plug-1605/multipart-1605259564-858222931410900-3"
           }

    assert Map.get(conn, "map") == nil
    assert Map.get(conn, "operations") == nil
  end

  test "conn/2 ignore parse errors" do
    assert %{params: %{}} == Upload.call(%{params: %{}}, [])
    assert %{body_params: %{}} == Upload.call(%{body_params: %{}}, [])
    assert %{:body_params => nil, "operations" => nil} == Upload.call(%{:body_params => nil, "operations" => nil}, [])
  end
end
