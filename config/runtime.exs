# COMMENT THIS FILE IF RUN IN DEV MODE

import Config

# Alephium Configuration
config :alephium_miner_bot, :alephium_worker, if(System.fetch_env!("ALEPHIUM_WORKER") == "true", do: true, else: false)
config :alephium_miner_bot, :alph_node_ip, System.fetch_env!("ALPH_NODE_IP")
config :alephium_miner_bot, :alph_node_port, System.fetch_env!("ALPH_NODE_PORT") |> String.to_integer()
config :alephium_miner_bot, :alph_node_api_key, System.fetch_env!("ALPH_NODE_API_KEY")
config :alephium_miner_bot, :alph_node_wallet_name, System.fetch_env!("ALPH_NODE_WALLET_NAME")
config :alephium_miner_bot, :alph_node_wallet_password, System.fetch_env!("ALPH_NODE_WALLET_PASSWORD")
config :alephium_miner_bot, :alph_hashrate_interval, System.fetch_env!("ALPH_WORKER_HASHRATE_INTERVAL") |> String.to_integer()

# Kaspa Configuration
config :alephium_miner_bot, :kaspa_worker, if(System.fetch_env!("KASPA_WORKER") == "true", do: true, else: false)
config :alephium_miner_bot, :kaspa_wallet_path, System.fetch_env!("KASPA_WALLET_PATH")
config :alephium_miner_bot, :kaspa_ctl_path, System.fetch_env!("KASPA_CTL_PATH")
config :alephium_miner_bot, :kaspa_hashrate_interval, System.fetch_env!("KASPA_WORKER_HASHRATE_INTERVAL") |> String.to_integer()

# IP Worker Configuration
config :alephium_miner_bot, :worker_ip_interval, System.fetch_env!("WORKER_IP_INTERVAL") |> String.to_integer()

# Telegram Configuration
config :alephium_miner_bot, :telegram_bot_token, System.fetch_env!("TELEGRAM_BOT_TOKEN")
config :alephium_miner_bot, :telegram_chat_id, System.fetch_env!("TELEGRAM_CHAT_ID")
