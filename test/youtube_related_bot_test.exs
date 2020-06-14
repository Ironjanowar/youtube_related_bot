defmodule YoutubeRelatedBotTest do
  use ExUnit.Case
  doctest YoutubeRelatedBot

  test "greets the world" do
    assert YoutubeRelatedBot.hello() == :world
  end
end
