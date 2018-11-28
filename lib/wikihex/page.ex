defmodule Wikihex.Page do
  def get(page_id) when is_number(page_id), do: Wikihex.ApiClient.get(%{pageid: page_id, action: "parse"})
  def get(title), do: Wikihex.ApiClient.get(%{page: title, action: "parse"})
end
