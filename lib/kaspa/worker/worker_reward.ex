defmodule AlephiumMinerBot.Kaspa.Worker.WorkerReward do
  use GenServer
  alias AlephiumMinerBot.Telegram

  def start_link() do
    IO.puts "[Kaspa][Worker.WorkerReward] started."
    GenServer.start_link(__MODULE__, :worker_reward)
  end


  @impl true
  def init(_) do
    state = %{
      total_balance_hint: nil,
      latest_timestamp: nil
    }

    Process.send_after(self(), :check_balance, 2_000)
    {:ok, state}
  end


  @impl true
  def handle_info(:check_balance, state) do
    old_balance_hint = Map.get(state, :total_balance_hint)
    case check_balance() do
      {:ok, new_balance_hint} ->
        if new_balance_hint != old_balance_hint do
          new_state = %{
            total_balance_hint: new_balance_hint,
            latest_timestamp: NaiveDateTime.utc_now()
          }
          message = generate_message(state, new_state)
          IO.puts message
          Telegram.send_message(message)
          schedule_check_balance()
          {:noreply, new_state}
        else
          schedule_check_balance()
          {:noreply, state}
        end
      :error ->
        schedule_check_balance()
        {:noreply, state}
    end
  end

  defp schedule_check_balance do
    Process.send_after(self(), :check_balance, 5_000)
  end

  def generate_message(old_state, new_state) do
    old_timestamp = Map.get(old_state, :latest_timestamp)
    new_timestamp = Map.get(new_state, :latest_timestamp)
    new_timestamp_string = new_timestamp
    |> NaiveDateTime.add(7*60*60, :second)
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
    |> String.slice(0..-4)

    total_balance_hint = Map.get(new_state, :total_balance_hint)


    if old_timestamp == nil do
      "#{new_timestamp_string} [Kaspa] Total Balance: #{total_balance_hint}"
    else
      interval_minute = NaiveDateTime.diff(new_timestamp, old_timestamp, :second)
      |> Kernel./(60)
      |> Float.round(1)
      "#{new_timestamp_string} [Kaspa] Won a block after #{interval_minute} minute(s). Total Balance Hint: #{total_balance_hint}"
    end
  end



  def check_balance do
    kaspa_wallet_path = Application.get_env(:alephium_miner_bot, :kaspa_wallet_path)
    case System.cmd(kaspa_wallet_path, ["balance"]) do
      {message, 0} ->
        balance = extract_balance_from_message(message)
        {:ok, balance}
      {"", 1} ->
        IO.puts "[Kaspa][Worker.WorkerReward][check_balance/0] Ensure to run `kaspawallet start-daemon`"
        :error
    end
  end

  def extract_balance_from_message(message) do
    message
    |> String.replace("Total balance, KAS", "")
    |> String.trim()
    |> String.split(" ")
    |> Enum.at(0)
    |> String.to_float()
    |> Number.Currency.number_to_currency([format: "%n", precision: 3])
  end
end
