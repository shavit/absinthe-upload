# AbsintheUpload

[![Build Status](https://travis-ci.org/shavit/absinthe-upload.svg?branch=master)](https://travis-ci.org/shavit/absinthe-upload)

> Absinthe plug to support Apollo upload format

## Installation

If [available in Hex](https://hexdocs.pm/absinthe_upload), the package can be installed
by adding `absinthe_upload` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:absinthe_upload, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm/absinthe_upload). Once published, the docs can
be found at [https://hexdocs.pm/absinthe_upload](https://hexdocs.pm/absinthe_upload).

Add the plug to a Phoenix app:
```
# phoenix_app_web/router.ex
defmodule PhoenixAppWeb.Router do
  use PhoenixAppWeb, :router
  
  pipeline :api do
    plug(:accepnts, ["json"])
	
	plug(Absinthe.Upload)
	...

  scope "/graphql" do
    
	forward("/", Absinthe.Plug,
	...
```

Add the plug to a Plug router:
```
# app/router.ex
defmodule App.Router do

  plug(Absinthe.Upload)
  ...
```

## Example

Requests with file uploads from Apollo clients has `"map"` and `"operations"`
```
%{
  "0" => %Plug.Upload{
    content_type: "text/rtf",
    filename: "San Francisco.rtf",
    path: "/tmp/plug-1605/multipart-1605199833-755605321722586-2"
  },
  "map" => "{\"0\":[\"variables.attachment\"]}",
  "operations" => "{\"query\":\"mutation DemoUpload($attachment: Upload) {\\n  demoUpload(attachment: $attachment)\\n}\",\"variables\":{\"attachment\":null},\"operationName\":\"DemoUpload\"}"
}
```

The plug will transform the request to a format Absinthe understands
```
%{
  "attachment" => %Plug.Upload{
    content_type: "text/rtf",
    filename: "San Francisco.rtf",
    path: "/tmp/plug-1605/multipart-1605199833-755605321722586-2"
  },
  "query" => "mutation DemoUpload($attachment: Upload) {  demoUpload(attachment: $attachment)}"
}
```

## Test

```
MIX_ENV=test mix test --cover
```
