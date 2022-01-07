defmodule AlephiumMinerBot do
  use Application

  alias AlephiumMinerBot.Worker.WorkerReward

  def start(_type, _args) do
    children = [
      %{
        id: WorkerReward,
        start: {WorkerReward, :start_link, []},
        type: :worker
      }

    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
