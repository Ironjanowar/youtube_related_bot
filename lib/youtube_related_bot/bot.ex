defmodule YoutubeRelatedBot.Bot do
  @bot :youtube_related_bot

  use ExGram.Bot,
    name: @bot,
    setup_commands: true

  command("start", description: "Says hi!")
  command("help", description: "Print the bot's help")

  middleware(ExGram.Middleware.IgnoreUsername)

  require Logger

  alias YoutubeRelatedBot.YoutubeClient
  alias YoutubeRelatedBot.Model.Video

  def bot(), do: @bot

  def handle({:command, :start, _msg}, context) do
    answer(context, "Hi!")
  end

  def handle({:command, :help, _msg}, context) do
    answer(context, "There is no help command by now :/")
  end

  def handle({:text, text, %{chat: %{id: chat_id}}}, context) do
    with [url | _] <- YoutubeRelatedBot.Parser.extract_urls(text),
         {:ok, video_id} <- YoutubeRelatedBot.Parser.get_video_id(url),
         {:ok, %{"items" => items}} <- YoutubeClient.search_related_to(video_id) do
      video_details_results =
        items
        |> Enum.map(fn item -> YoutubeClient.get_video_details(item["id"]["videoId"]) end)

      videos =
        Enum.filter(video_details_results, fn item -> elem(item, 0) == :ok end)
        |> Enum.map(fn {:ok, item} -> Video.from_api(item) end)
        |> Enum.filter(fn item -> elem(item, 0) == :ok end)

      Enum.map(videos, fn {:ok, video} ->
        ExGram.send_photo(chat_id, video.thumbnail,
          caption: "[#{video.title}](#{video.url})",
          parse_mode: "Markdown"
        )
      end)
    else
      err ->
        err |> inspect() |> Logger.error()
        answer(context, "There was an error")
    end
  end
end
