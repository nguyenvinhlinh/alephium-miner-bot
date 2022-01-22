defmodule AlephiumMinerBot.Alephium.Worker.WorkerReward do
  use GenServer
  alias AlephiumMinerBot.Telegram

  @api_unlock_path "/wallets/WALLET_NAME/unlock"
  @api_balance_path "/wallets/WALLET_NAME/balances"

  def start_link() do
    IO.puts "[Worker.WorkerReward] started."
    GenServer.start_link(__MODULE__, :worker_reward)
  end


  @impl true
  def init(_) do
    state = %{
      total_balance_hint: nil,
      latest_timestamp: nil
    }
    unlock_wallet()
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
        unlock_wallet()
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
      "#{new_timestamp_string} Total Balance Hint: #{total_balance_hint}"
    else
      interval_minute = NaiveDateTime.diff(new_timestamp, old_timestamp, :second)
      |> Kernel./(60)
      |> Float.round(1)
      "#{new_timestamp_string} Won a block after #{interval_minute} minute(s). Total Balance Hint: #{total_balance_hint}"
    end

  end


  def unlock_wallet do
    body = %{
      "password" => Application.get_env(:alephium_miner_bot, :alph_node_wallet_password)
    }
    |> Jason.encode!()
    case HTTPoison.post(api_unlock_url(), body, api_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200}} -> :ok
      {:ok, response} ->
        error_message = response
        |> Map.get(:body)
        |> Jason.decode!()
        |> Map.get("detail")
        IO.puts "[Worker.WorkerReward][unlock_wallet/0] #{error_message}"
        :error
      {:error, %HTTPoison.Error{reason: error_message}} ->
        IO.puts "[Worker.WorkerReward][unlock_wallet/0] #{error_message}"
        :error
    end
  end

  def check_balance do
    case  HTTPoison.get(api_balance_url(), api_headers()) do
      {:ok, %HTTPoison.Response{status_code: 200} = response} ->
        balance_hint = response
        |> Map.get(:body)
        |> Jason.decode!()
        |> Map.get("totalBalanceHint")
        {:ok, balance_hint}
      {:ok, response} ->
        error_message = response
        |> Map.get(:body)
        |> Jason.decode!()
        |> Map.get("detail")
        IO.puts "[Worker.WorkerReward][check_balance/0] #{error_message}"
        :error
      {:error, %HTTPoison.Error{reason: error_message}} ->
        IO.puts "[Worker.WorkerReward][check_balance/0] #{error_message}"
        :error
    end
  end

  def api_unlock_url do
    ip = Application.get_env(:alephium_miner_bot, :alph_node_ip)
    port = Application.get_env(:alephium_miner_bot, :alph_node_port)
    wallet_name = Application.get_env(:alephium_miner_bot, :alph_node_wallet_name)
    path = @api_unlock_path
    |> String.replace("WALLET_NAME", wallet_name)


    "#{ip}:#{port}#{path}"
  end

  def api_balance_url do
    ip = Application.get_env(:alephium_miner_bot, :alph_node_ip)
    port = Application.get_env(:alephium_miner_bot, :alph_node_port)
    wallet_name = Application.get_env(:alephium_miner_bot, :alph_node_wallet_name)
    path = @api_balance_path
    |> String.replace("WALLET_NAME", wallet_name)


    "#{ip}:#{port}#{path}"
  end

  def api_headers  do
    api_key = Application.get_env(:alephium_miner_bot, :alph_node_api_key)
    [
      {"Content-Type", "application/json"},
      {"X-API-KEY", api_key}
    ]
  end

end
