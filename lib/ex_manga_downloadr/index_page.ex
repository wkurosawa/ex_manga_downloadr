defmodule ExMangaDownloadr.IndexPage do
  def chapters(manga_name) do
    case HTTPotion.get("http://www.mangareader.net/#{manga_name}") do
      %HTTPotion.Response{ body: body, headers: _headers, status_code: 200 } ->
        {:ok, fetch_manga_title(body), fetch_chapters(body) }
      _ ->
        {:err, "not found"}
    end
  end

  defp fetch_manga_title(html) do
    Floki.find(html, "#mangaproperties h1")
    |> Enum.map(fn {"h1", [], [title]} -> title end)
    |> Enum.at(0)
  end

  defp fetch_chapters(html) do
    Floki.find(html, "#listing a")
    |> Enum.map fn {"a", [{"href", url}], _} -> url end
  end
end