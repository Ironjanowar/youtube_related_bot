defmodule YoutubeRelatedBot.Model.Video do
  defstruct [:id, :title, :description, :thumbnail, :url]

  alias __MODULE__

  def from_api(details) do
    case details do
      %{"items" => [data]} ->
        {:ok,
         %Video{
           id: data["id"],
           title: data["snippet"]["title"],
           description: data["snippet"]["description"],
           thumbnail: data["snippet"]["thumbnails"]["medium"]["url"],
           url: "https://youtube.com/watch?v=#{data["id"]}"
         }}

      _ ->
        {:error, "Video without details"}
    end
  end
end
