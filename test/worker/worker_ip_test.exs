defmodule AlephiumMinerBot.Worker.WorkerIPTest do
  use ExUnit.Case
  alias AlephiumMinerBot.Worker.WorkerIP

  doctest AlephiumMinerBot

  test "generate_message" do
    utc_now = NaiveDateTime.utc_now()
    old_state = %{
      ip: "1.2.3.4",
      latest_timestamp: utc_now
    }

    new_state = %{
      ip: "5.6.7.8",
      latest_timestamp: NaiveDateTime.add(utc_now, 27*60, :second)
    }
    message = WorkerIP.generate_message(old_state, new_state)
    IO.puts message
    assert(true)
  end

  test "generate_message_2" do
    utc_now = NaiveDateTime.utc_now()
    old_state = %{
      ip: nil,
      latest_timestamp: nil
    }

    new_state = %{
      ip: "5.6.7.8",
      latest_timestamp: NaiveDateTime.add(utc_now, 27*60, :second)
    }
    message = WorkerIP.generate_message(old_state, new_state)
    IO.puts message
    assert(true)
  end
end
