defmodule YoutubeRelatedBot.YoutubeClient do
  use Tesla

  # https://www.googleapis.com/youtube/v3/search
  plug(Tesla.Middleware.BaseUrl, "https://www.googleapis.com/youtube/v3")
  plug(Tesla.Middleware.JSON)
  plug(Tesla.Middleware.Query, key: get_api_key())

  require Logger

  defp get_api_key(), do: ExGram.Config.get(:youtube_related_bot, :api_key)

  def get_video(video_id) do
    case get("/videos", query: [part: "id", id: video_id]) do
      {:ok, %{body: body}} -> {:ok, body}
      err -> err
    end
  end

  def get_video_details(video_id) do
    Logger.debug("Getting video details of: '#{video_id}'")

    case get("/videos", query: [part: "snippet", id: video_id]) do
      {:ok, %{body: body}} -> {:ok, body}
      err -> err
    end
  end

  def search_related_to(video_id) do
    case get("/search", query: [part: "id", type: "video", relatedToVideoId: video_id]) do
      {:ok, %{body: body}} -> {:ok, body}
      err -> err
    end
  end
end
