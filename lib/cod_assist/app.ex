defmodule CodAssist.App do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      worker(CodAssist.Poller, [])
    ]

    {:ok, _} = Supervisor.start_link(children, strategy: :one_for_one)
  end
end
