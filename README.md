# Alephium Miner Bot

**Alephium Miner Bot is a telegram bot that sends the following messages**
- Global network hashrate
- Current IP
- Balance & mining reward

![Telegram](./images/telegram.png?raw=true "Telegram")

This bot is inspired by [Diomark](https://www.facebook.com/diomark/). His shell script about checking alph balance & mining time reward is really cool.

## Dependencies
- Alephium Node: 1.2.0 (if used alephium worker)
- Kaspa Node: 0.11.9 (if use kaspa worker)
- Erlang: 22.3
- Elixir: 1.12

## Elixir Processes

![Elixir Processes](./images/elixir-process.png?raw=true "Elixir Processes")

## Release
Execute the following command, then project release will be generated at `/alephium_miner_bot/_build/prod/rel/alephium_miner_bot`
```sh
$ mix deps.get
$ MIX_ENV=prod mix release
```

## Execute Release
Make a file named `release_run.sh` or copy it from `release_run.sh.sample`. If you download release from github release, after unzip it, you can also use this
script named `release_run.sh` to launch the program, however beaware of your current directory.

```sh
#!/bin/bash
ALEPHIUM_WORKER=false \
ALPH_NODE_IP=127.0.0.1 \
ALPH_NODE_PORT=12973 \
ALPH_NODE_API_KEY=cf5062725e62d2096228cd6f7ab0f2a0 \
ALPH_NODE_WALLET_NAME=main \
ALPH_NODE_WALLET_PASSWORD="" \
ALPH_WORKER_HASHRATE_INTERVAL=1800000 \
KASPA_WORKER=false \
KASPA_WALLET_PATH=/opt/kaspa/bin/kaspawallet \
KASPA_CTL_PATH=/opt/kaspa/bin/kaspactl \
KASPA_WORKER_HASHRATE_INTERVAL=1800000 \
WORKER_IP_INTERVAL=60000 \
TELEGRAM_BOT_TOKEN=cf5062725e62d2096228cd6f7ab0f2a0 \
TELEGRAM_CHAT_ID=cf5062725e62d2096228cd6f7ab0f2a0 \

_build/prod/rel/alephium_miner_bot/bin/alephium_miner_bot start
```

To execute the release, it's important to provide the following parameters:

Alephium Configration:

- `ALEPHIUM_WORKER`: enable/disable alephium worker, value: true/false
- `ALPH_NODE_IP`: self-explained
- `ALPH_NODE_PORT`: self-explained
- `ALPH_NODE_API_KEY`: self-explained
- `ALPH_NODE_WALLET_NAME`: self-explained
- `ALPH_NODE_WALLET_PASSWORD`: self-explained
- `ALPH_WORKER_HASHRATE_INTERVAL`: interval in microsecond that fetching network hashrate.
- `TELEGRAM_BOT_TOKEN`: self-explained
- `TELEGRAM_CHAT_ID`: self-explained

Kaspa Configuration:
- `KASPA_WORKER`: enable/disable kaspa worker, value: true/false
- `KASPA_WALLET_PATH`: path to `kaspawallet` executable file
- `KASPA_CTL_PATH`: path to `kaspactl` executable file
- `KASPA_WORKER_HASHRATE_INTERVAL`: interval in microsecond that fetching network hashrate.

IP Worker Configuration:
- `WORKER_IP_INTERVAL`: interval in microsecond that fetching IP

Finally, make the file `release-run.sh` executable and run it
```sh
# Current directory: Project Root
$ ./release_run.sh
```

You should see the following output on terminal.

```text
[Worker.WorkerIP] started.
[Alephium][Worker.WorkerReward] started.
[Alephium][Worker.WorkerHashrate] started.
[Kaspa][Worker.WorkerReward] started.
[Kaspa][Worker.WorkerHashrate] started.
2022-03-06 23:48 [Kaspa] Network Hashrate: 1.65 TH/s
2022-03-06 23:48 [Kaspa] Total Balance: 52,592.586
2022-03-06 23:48 IP: 42.115.xxx.xxx
2022-03-06 23:48 [Alephium] Network Hashrate: 42.03 TH/s
2022-03-06 23:48 [Alephium] Total Balance Hint: 27.138334777166927095 ALPH
```

And your telegram should show:

![Telegram](./images/telegram.png?raw=true "Telegram")

## Donation
If you want to buy me a coffee, this is my addresses.
- Alephium: `16ZcUrPRFafXdSjkTq5uWqkSrg6n5zwGB26pc7xrcjM7m`
- Kaspa: `kaspa:qz3997w4ew30rgp8wxp2aaj5zk7ect68nnzy80fhrpw0d7fdervkw8lpwrmry`

Thank you from Vietnam.
