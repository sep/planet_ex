defmodule PlanetEx.Core.Cron do
  @moduledoc """
  This module will call the passed in function on a recurring basis.
  """
  use GenServer

  @timeout Application.get_env(:planetex, :server_timeout)

  def start_link(job) do
    GenServer.start_link(__MODULE__, job)
  end

  def init(job) do
    job.()

    schedule_refresh()

    {:ok, job}
  end

  def handle_info(:run, job) do
    job.()

    schedule_refresh()

    {:noreply, job}
  end

  defp schedule_refresh do
    Process.send_after(self(), :run, @timeout)
  end
end
