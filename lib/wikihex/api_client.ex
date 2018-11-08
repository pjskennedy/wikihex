defmodule Wikihex.ApiClient do
  @moduledoc """
  This is a very thin client to the Wikipedia API. See notes on API at https://www.mediawiki.org/wiki/API:Query
  """

  @default_arguments %{
    format: "json",
    formatversion: 2
  }
  @api_endpoint "https://en.wikipedia.org/w/api.php"

  @doc """
  Query the Wikipedia API for data given some URL arguments in a map.

  Retuns `{:ok, parsed_json}` on success, `{:error, reason}` otherwise

  ## Examples

    iex> Wikihex.ApiClient.get(%{action: "query", titles: "Main Page"})
    {:ok, %{"query" => %{"pages" => [%{"ns" => 0, "pageid" => 15580374, "title" => "Main Page"}]}, "batchcomplete" => true}}


  """
  def get(arguments) when is_map(arguments) do
    arguments
    |> Map.merge(@default_arguments)
    |> URI.encode_query()
    |> (&"#{@api_endpoint}?#{&1}").()
    |> query_wikipedia
  end

  def get(_), do: get(%{})

  defp query_wikipedia(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_response(body)

      {:ok, %HTTPoison.Response{status_code: http_code}} ->
        {:error, "Wikipedia returned an HTTP #{http_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_response(body) do
    case Poison.decode(body) do
      {:error, _} ->
        {:error, "Invalid JSON"}

      {:ok, %{"error" => error}} ->
        {:error, error}

      {:ok, parsed_response} ->
        {:ok, parsed_response}
    end
  end
end
