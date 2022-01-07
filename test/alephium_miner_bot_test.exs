defmodule AlephiumMinerBotTest do
  use ExUnit.Case
  doctest AlephiumMinerBot

  test "greets the world" do
    assert AlephiumMinerBot.hello() == :world
  end
end
