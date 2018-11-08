defmodule Wikihex.ApiClientTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Wikihex.ApiClient

  doctest Wikihex.ApiClient

  test "should query API" do
    use_cassette "wikipedia/pageprops", custom: true do
      response = ApiClient.get(%{action: "query", titles: "Canada"})

      assert {:ok,
              %{
                "query" => %{
                  "pages" => [%{"ns" => 0, "pageid" => 5_042_916, "title" => "Canada"}]
                }
              }} = response
    end
  end

  test "handle JSON parse errors" do
    use_cassette "wikipedia/badjson", custom: true do
      response = ApiClient.get(%{action: "query", titles: "Canada"})
      assert {:error, _} = response
    end
  end

  test "handle unexpected HTTP codes" do
    use_cassette "wikipedia/404", custom: true do
      response = ApiClient.get(%{action: "query", titles: "Canada"})
      assert {:error, "Wikipedia returned an HTTP 404"} = response
    end
  end

  test "handle wikipedia errors" do
    use_cassette "wikipedia/error", custom: true do
      response = ApiClient.get(%{action: "querie", titles: "Canada"})
      assert {:error, _} = response
    end
  end
end
