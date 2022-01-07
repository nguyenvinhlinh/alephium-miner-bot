defmodule AlephiumMinerBot.Telegram  do
  @api_url "https://api.telegram.org/botBOT_TOKEN/sendMessage"

  def send_message(message) do
    headers = [
      {"Content-Type", "application/json"}
    ]

    body = %{
      "chat_id" => Application.get_env(:alephium_miner_bot, :telegram_chat_id),
      "text" => message
    }
    |> Jason.encode!


    api_url = @api_url
    |> String.replace("BOT_TOKEN", Application.get_env(:alephium_miner_bot, :telegram_bot_token))

    HTTPoison.post(api_url, body, headers)
  end
end
