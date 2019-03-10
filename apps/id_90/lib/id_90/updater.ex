defmodule Id90.Updater do
  alias Id90.Data
  use GenServer

  def start_link(params) do
    GenServer.start_link(__MODULE__, params)
  end

  def init([timeout]) do
    Process.send(self(), :sync, [])
    {:ok, %{timeout: timeout}}
  end

  def handle_info(:sync, %{timeout: timeout} = state) do
    Data.list_flights()
    |> Enum.map(fn flight -> Data.update_flight(flight) end)

    # Data.list_users()
    # |> Enum.map(fn flight -> Data.update_flight(flight) end)
    Process.send_after(self(), :sync, timeout * 1000)
    {:noreply, state}
  end
end
