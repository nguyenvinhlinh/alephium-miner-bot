# Alephium Miner Bot

**Alephium Miner Bot is a telegram bot that sends the following messages**
- Global network hashrate
- Current IP
- Balance & mining reward

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
Make a file named `release_run.sh` or copy it from `release_run.sh.sample`.

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
- ALPH_NODE_IP: self-explained
- ALPH_NODE_PORT: self-explained
- ALPH_NODE_API_KEY: self-explained
- ALPH_NODE_WALLET_NAME: self-explained
- ALPH_NODE_WALLET_PASSWORD: self-explained
- WORKER_HASHRATE_INTERVAL: interval in microsecond that fetching network hashrate.
- WORKER_IP_INTERVAL: interval in microsecond that fetching IP
- TELEGRAM_BOT_TOKEN: self-explained
- TELEGRAM_CHAT_ID: self-explained


Finally, make the file `release-run.sh` executable and run it
```sh
# Current directory: Project Root
$ ./release_run.sh
```
