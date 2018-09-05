defmodule Planet.Core.CronTest do
  use ExUnit.Case

  alias Planet.Core.Cron

  test "should execute the job" do
    id = self()
    job = fn -> send(id, :done) end

    start_supervised!({Cron, job})

    assert_receive :done
  end
end
