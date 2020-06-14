defmodule YoutubeRelatedBot.Parser do
  def extract_urls(text) do
    text
    |> String.split(~r/(\s|\n)/, trim: true)
    |> Enum.filter(&String.match?(&1, ~r/^(http|https):\/\/(www\.|)(youtube.com|youtu.be)/))
  end

  def get_video_id(url) do
    case Regex.run(
           ~r/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/,
           url
         ) do
      nil -> :no_match
      matches -> {:ok, List.last(matches)}
    end
  end
end
