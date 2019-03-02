defmodule Id90Web.FlightController do
  use Id90Web, :controller

  alias Id90.Data
  alias Id90.Data.Flight

  def index(conn, _params) do
    flights = Data.list_flights()
    render(conn, "index.html", flights: flights)
  end

  def new(conn, _params) do
    changeset = Data.change_flight(%Flight{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"flight" => flight_params}) do
    case Data.create_flight(flight_params) do
      {:ok, flight} ->
        conn
        |> put_flash(:info, "Flight created successfully.")
        |> redirect(to: Routes.flight_path(conn, :show, flight))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    flight = Data.get_flight!(id)
    render(conn, "show.html", flight: flight)
  end

  def edit(conn, %{"id" => id}) do
    flight = Data.get_flight!(id)
    changeset = Data.change_flight(flight)
    render(conn, "edit.html", flight: flight, changeset: changeset)
  end

  def update(conn, %{"id" => id, "flight" => flight_params}) do
    flight = Data.get_flight!(id)

    case Data.update_flight(flight, flight_params) do
      {:ok, flight} ->
        conn
        |> put_flash(:info, "Flight updated successfully.")
        |> redirect(to: Routes.flight_path(conn, :show, flight))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", flight: flight, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    flight = Data.get_flight!(id)
    {:ok, _flight} = Data.delete_flight(flight)

    conn
    |> put_flash(:info, "Flight deleted successfully.")
    |> redirect(to: Routes.flight_path(conn, :index))
  end
end
