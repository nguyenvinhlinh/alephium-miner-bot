# Alephium Miner Bot

**Alephium Miner Bot is a telegram bot that sends the following messages**
- Global network hashrate
- Current IP
- Balance & mining reward

![Telegram](./images/telegram.png?raw=true "Telegram")

This bot is inspired by [Diomark](https://www.facebook.com/diomark/). His shell script about checking alph balance & mining time reward is really cool.

## Dependencies
- Alephium Node: 1.2.0


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

ALPH_NODE_IP=127.0.0.1 \
ALPH_NODE_PORT=12973 \
ALPH_NODE_API_KEY=cf5062725e62d2096228cd6f7ab0f2a0 \
ALPH_NODE_WALLET_NAME=main \
ALPH_NODE_WALLET_PASSWORD="" \
WORKER_HASHRATE_INTERVAL=1800000 \
WORKER_IP_INTERVAL=60000 \
TELEGRAM_BOT_TOKEN=cf5062725e62d2096228cd6f7ab0f2a0 \
TELEGRAM_CHAT_ID=cf5062725e62d2096228cd6f7ab0f2a0 \
_build/prod/rel/alephium_miner_bot/bin/alephium_miner_bot start
```

To execute the release, it's important to provide the following parameters:
- `ALPH_NODE_IP`: self-explained
- `ALPH_NODE_PORT`: self-explained
- `ALPH_NODE_API_KEY`: self-explained
- `ALPH_NODE_WALLET_NAME`: self-explained
- `ALPH_NODE_WALLET_PASSWORD`: self-explained
- `WORKER_HASHRATE_INTERVAL`: interval in microsecond that fetching network hashrate.
- `WORKER_IP_INTERVAL`: interval in microsecond that fetching IP
- `TELEGRAM_BOT_TOKEN`: self-explained
- `TELEGRAM_CHAT_ID`: self-explained


Finally, make the file `release-run.sh` executable and run it
```sh
# Current directory: Project Root
$ ./release_run.sh
```

You should see the following output on terminal.

```text
[Worker.WorkerReward] started.
[Worker.WorkerHashrate] started.
[Worker.WorkerIP] started.
2022-01-08 10:07 Global Hashrate: 14.55 TH/s
2022-01-08 10:07 Total Balance Hint: 32.759050957918223547 ALPH
2022-01-08 10:07 IP: x.x.x.x
```

And your telegram should show:

![Telegram](./images/telegram.png?raw=true "Telegram")

## Donation
If you want to buy me a coffee, this is my ALPH address: `16ZcUrPRFafXdSjkTq5uWqkSrg6n5zwGB26pc7xrcjM7m`.
