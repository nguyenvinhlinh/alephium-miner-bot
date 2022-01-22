defmodule AlephiumMinerBot.Alephium.AlephiumSupervisor do
  use Supervisor

  alias AlephiumMinerBot.Alephium.Worker.{WorkerReward, WorkerHashrate}

  def start_link() do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end


  @impl true
  def init(_) do
    children = [
      %{
        id: WorkerReward,
        start: {WorkerReward, :start_link, []},
        type: :worker
      },
      %{
        id: WorkerHashrate,
        start: {WorkerHashrate, :start_link, []},
        type: :worker
      }
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
