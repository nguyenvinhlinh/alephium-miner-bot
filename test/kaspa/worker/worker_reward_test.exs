defmodule AlephiumMinerBot.Kaspa.Worker.WorkerRewardTest do
  use ExUnit.Case
  alias AlephiumMinerBot.Kaspa.Worker.WorkerReward

  doctest AlephiumMinerBot

  test "extract_balance_from_message_1" do
    message = "Total balance, KAS     211850.03579015                    \n"
    test_value = WorkerReward.extract_balance_from_message(message)
    expected_value = "211,850.036"
    assert(expected_value == test_value)

  end

  test "extract_balance_from_message_2" do
    message = "Total balance, KAS     211850.03579015        500.00000000 (pending)\n"
    test_value = WorkerReward.extract_balance_from_message(message)
    expected_value = "211,850.036"
    assert(expected_value == test_value)
  end



end
