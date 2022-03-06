defmodule AlephiumMinerBot.Kaspa.Worker.WorkerHashrate do
  use GenServer
  alias AlephiumMinerBot.Telegram

  def start_link() do
    IO.puts "[Kaspa][Worker.WorkerHashrate] started."
    GenServer.start_link(__MODULE__, :kaspa_worker_hashrate)
  end

  @impl true
  def init(_) do
    Process.send_after(self(), :check_hashrate, 2_000)
    {:ok, nil}
  end

  @impl true
  def handle_info(:check_hashrate, _state) do
    case check_hashrate()  do
      {:ok, hashrate} ->
        message = generate_message(hashrate)
        IO.puts(message)
        Telegram.send_message(message)
        schedule_check_hashrate()
        {:noreply, nil}
      :error ->
        schedule_check_hashrate()
        {:noreply, nil}
    end
  end

  defp schedule_check_hashrate do
    interval = Application.get_env(:alephium_miner_bot, :kaspa_hashrate_interval)
    Process.send_after(self(), :check_hashrate, interval)
  end

  def generate_message(hashrate) do
    new_timestamp = NaiveDateTime.utc_now()
    new_timestamp_string = new_timestamp
    |> NaiveDateTime.add(7*60*60, :second)
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
    |> String.slice(0..-4)

    "#{new_timestamp_string} [Kaspa] Network Hashrate: #{hashrate} TH/s"
  end

  def check_hashrate do
    kaspactl_path = Application.get_env(:alephium_miner_bot, :kaspa_ctl_path)
    case System.cmd(kaspactl_path, ["GetBlockDagInfo"]) do
      {message, 0} ->
        hashrate = extract_hashrate_from_message(message)
        {:ok, hashrate}
      {"", 1} ->
        IO.puts "[Kaspa][Worker.WorkerHashrate][check_hashrate/0] Ensure that you can run `kaspactl GetBlockDagInfo` manually."
        :error
    end
  end

  def extract_hashrate_from_message(message) do
    Jason.decode!(message)
    |> Map.get("getBlockDagInfoResponse")
    |> Map.get("difficulty")
    |> Decimal.from_float()
    |> Decimal.mult(2)
    |> Decimal.div(1_000_000_000_000)
    |> Number.Currency.number_to_currency([format: "%n", precision: 2])
  end
end
