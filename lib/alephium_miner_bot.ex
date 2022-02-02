defmodule AlephiumMinerBot do
  use Application

  alias AlephiumMinerBot.Alephium.AlephiumSupervisor
  alias AlephiumMinerBot.Kaspa.Worker.WorkerReward, as: KaspaWorkerReward
  alias AlephiumMinerBot.ETC.Worker.WorkerIP

  def start(_type, _args) do
    init_children = [
      %{
        id: WorkerIP,
        start: {WorkerIP, :start_link, []},
        type: :worker
      }
    ]

    children = init_children
    |> children_alephium_worker()
    |> children_kaspa_worker()

    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def start() do
    start(nil, nil)
  end


  def children_alephium_worker(children) do
    if Application.get_env(:alephium_miner_bot, :alephium_worker) do
      children ++ [%{id: AlephiumSupervisor,
                     start: {AlephiumSupervisor, :start_link, []},
                     type: :supervisor}]
    else
      children
    end
  end

  def children_kaspa_worker(children) do
    if Application.get_env(:alephium_miner_bot, :kaspa_worker) do
      children ++ [%{id: KaspaWorkerReward,
                     start: {KaspaWorkerReward, :start_link, []},
                     type: :supervisor}]
    else
      children
    end
  end
end
