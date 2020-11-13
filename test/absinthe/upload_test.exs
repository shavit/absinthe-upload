defmodule Absinthe.UploadTest do
  use ExUnit.Case
  doctest Absinthe.Upload
  alias Absinthe.Upload

  test "init/1 pass the conn" do
    assert Upload.init(%{}) == %{}
  end
end
