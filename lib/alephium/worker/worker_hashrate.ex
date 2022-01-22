defmodule AlephiumMinerBot.Alephium.Worker.WorkerHashrate do
  use GenServer
  alias AlephiumMinerBot.Telegram

  @api_path "/infos/current-hashrate"


  def start_link() do
    IO.puts "[Worker.WorkerHashrate] started."
    GenServer.start_link(__MODULE__, :worker_hashrate)
  end


  @impl true
  def init(_) do
    Process.send_after(self(), :check_hashrate, 2_000)
    {:ok, nil}
  end


  @impl true
  def handle_info(:check_hashrate, _state) do
    case check_hashrate() do
      {:ok, hashrate} ->
        message = generate_message(hashrate)
        IO.puts message
        Telegram.send_message(message)
        schedule_check_hashrate()
        {:noreply, nil}
      :error ->
        schedule_check_hashrate()
        {:noreply, nil}
    end
  end

  defp schedule_check_hashrate do
    interval = Application.get_env(:alephium_miner_bot, :worker_hashrate_interval)
    Process.send_after(self(), :check_hashrate, interval)
  end

  def generate_message(hashrate) do
    new_timestamp = NaiveDateTime.utc_now()
    new_timestamp_string = new_timestamp
    |> NaiveDateTime.add(7*60*60, :second)
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()
    |> String.slice(0..-4)

    hashrate_string = hashrate
    |> String.replace(" MH/s", "")
    |> String.to_integer()
    |> Kernel./(1_000_000)
    |> Float.round(2)

    "#{new_timestamp_string} Global Hashrate: #{hashrate_string} TH/s"
  end

  def check_hashrate do
    case  HTTPoison.get(api_url(), api_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        hashrate = response
        |> Map.get(:body)
        |> Jason.decode!()
        |> Map.get("hashrate")
        {:ok, hashrate}
      {:ok, response} ->
        error_message = response
        |> Map.get(:body)
        |> Jason.decode!()
        |> Map.get("detail")
        IO.puts "[Worker.WorkerHashrate][check_hashrate/0] #{error_message}"
        :error
      {:error, %HTTPoison.Error{reason: error_message}} ->
        IO.puts "[Worker.WorkerHashrate][check_hashrate/0] #{error_message}"
        :error
    end
  end

  def api_url do
    ip = Application.get_env(:alephium_miner_bot, :alph_node_ip)
    port = Application.get_env(:alephium_miner_bot, :alph_node_port)
    "#{ip}:#{port}#{@api_path}"
  end


  def api_headers  do
    api_key = Application.get_env(:alephium_miner_bot, :alph_node_api_key)
    [
      {"Content-Type", "application/json"},
      {"X-API-KEY", api_key}
    ]
  end
end
