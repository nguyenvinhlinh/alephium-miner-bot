defmodule AlephiumMinerBot.Worker.WorkerRewardTest do
  use ExUnit.Case
  alias AlephiumMinerBot.Worker.WorkerReward

  doctest AlephiumMinerBot

  # test "greets the world" do
  #   assert AlephiumMinerBot.hello() == :world
  # end

  test "generate_message" do
    utc_now = NaiveDateTime.utc_now()
    old_state = %{
      total_balance_hint: "0.00 ALPH",
      latest_timestamp: utc_now
    }

    new_state = %{
      total_balance_hint: "3.8 ALPH",
      latest_timestamp: NaiveDateTime.add(utc_now, 27*60, :second)
    }
    message = WorkerReward.generate_message(old_state, new_state)
    IO.puts message
    assert(true)
  end
end
