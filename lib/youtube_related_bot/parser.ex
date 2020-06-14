defmodule YoutubeRelatedBot.Parser do
  def extract_urls(text) do
    text
    |> String.split(~r/(\s|\n)/, trim: true)
    |> Enum.filter(&String.match?(&1, ~r/^(http|https):\/\/(www\.|)youtube.com/))
  end

  def get_video_id(url) do
    case Regex.run(~r/v=([^&]*)/, url) do
      [_full_match, video_id | _] -> {:ok, video_id}
      _ -> :no_match
    end
  end
end
