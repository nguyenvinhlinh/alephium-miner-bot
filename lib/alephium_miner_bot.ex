defmodule AlephiumMinerBot do
  use Application

  alias AlephiumMinerBot.Alephium.AlephiumSupervisor
  alias AlephiumMinerBot.ETC.Worker.WorkerIP
  def start(_type, _args) do
    children = [
      %{
        id: AlephiumSupervisor,
        start: {AlephiumSupervisor, :start_link, []},
        type: :supervisor
      },
      %{
        id: WorkerIP,
        start: {WorkerIP, :start_link, []},
        type: :worker
      }
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
