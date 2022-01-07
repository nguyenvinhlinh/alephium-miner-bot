defmodule AlephiumMinerBot.Worker.WorkerIP do
  use GenServer
  alias AlephiumMinerBot.Telegram

  @api_url "https://api.ipify.org"

  def start_link() do
    IO.puts "[Worker.WorkerIP] started."
    GenServer.start_link(__MODULE__, :worker_hashrate)
  end


  @impl true
  def init(_) do
    state = %{
      last_timestamp: nil,
      ip: nil
    }

    Process.send_after(self(), :check_ip, 2_000)
    {:ok, state}
  end


  @impl true
  def handle_info(:check_ip, state) do
    case check_ip() do
      {:ok, new_ip} ->
        old_ip = Map.get(state, :ip)

        if old_ip != new_ip do
          new_state = %{
            ip: new_ip,
            latest_timestamp: NaiveDateTime.utc_now()
          }
          message = generate_message(state, new_state)
          IO.puts message
          Telegram.send_message(message)
          schedule_check_ip()
          {:noreply, new_state}
        else
          schedule_check_ip()
          {:noreply, state}
        end
      :error ->
        schedule_check_ip()
        {:noreply, nil}
    end
  end

  defp schedule_check_ip do
    interval = Application.get_env(:alephium_miner_bot, :worker_ip_interval)
    Process.send_after(self(), :check_ip, interval)
  end

  def generate_message(old_state, new_state) do
    old_timestamp = Map.get(old_state, :latest_timestamp)
    new_timestamp = Map.get(new_state, :latest_timestamp)
    new_timestamp_string = new_timestamp
    |> NaiveDateTime.add(7*60*60, :second)
    |> NaiveDateTime.truncate(:second)
    |> NaiveDateTime.to_string()

    ip = Map.get(new_state, :ip)

    if old_timestamp == nil do
      "#{new_timestamp_string} IP: #{ip}"
    else
      interval_hour = NaiveDateTime.diff(new_timestamp, old_timestamp, :second)
      |> Kernel./(60 * 60)
      |> Float.round(2)
      "#{new_timestamp_string} IP changed after #{interval_hour} hour(s). IP: #{ip}"
    end
  end

  def check_ip do
    case  HTTPoison.get(@api_url) do
      {:ok, response} ->
        ip = response
        |> Map.get(:body)

        {:ok, ip}
      {:error, %HTTPoison.Error{reason: error_message}} ->
        IO.puts "[Worker.WorkerIP][check_ip/0] #{error_message}"
        :error
    end
  end
end
