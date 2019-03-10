defmodule Id90Web.FlightController do
  use Id90Web, :controller

  alias Id90.Data
  alias Id90.Data.Flight

  def index(conn, %{"user_id" => user_id}) do
    flights = Data.list_flights(user_id)
    user = Data.get_user!(user_id)
    render(conn, "index.html", flights: flights, user: user)
  end

  def new(conn, %{"user_id" => user_id}) do
    user = Data.get_user!(user_id)

    {_no_flights, flights} =
      Data.get_user_calendar(user)
      |> Enum.split_with(fn %ExIcal.Event{uid: uid} -> String.ends_with?(uid, "NO-FLIGHT") end)
      |> IO.inspect()

    flights
    |> Enum.map(fn event ->
      Data.from_event(event)
      |> Enum.map(fn attr ->
        Data.create_flight(attr)
        |> Data.update_flight()
      end)
    end)

    conn
    |> put_flash(:info, "Данные о полетах обновленны.")
    |> redirect(to: Routes.user_flight_path(conn, :index, user))
  end

  # def create(conn, %{"flight" => flight_params, "user_id" => user_id}) do
  #   user = Data.get_user!(user_id)

  #   case Data.create_flight(flight_params) do
  #     {:ok, flight} ->
  #       conn
  #       |> put_flash(:info, "Flight created successfully.")
  #       |> redirect(to: Routes.flight_path(conn, :show, flight))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "new.html", changeset: changeset, user: user)
  #   end
  # end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    user = Data.get_user!(user_id)
    flight = Data.get_flight!(id)
    render(conn, "show.html", flight: flight, user: user)
  end

  # def edit(conn, %{"id" => id}) do
  #   flight = Data.get_flight!(id)
  #   changeset = Data.change_flight(flight)
  #   render(conn, "edit.html", flight: flight, changeset: changeset)
  # end

  # def update(conn, %{"id" => id, "flight" => flight_params}) do
  #   flight = Data.get_flight!(id)

  #   case Data.update_flight(flight, flight_params) do
  #     {:ok, flight} ->
  #       conn
  #       |> put_flash(:info, "Flight updated successfully.")
  #       |> redirect(to: Routes.flight_path(conn, :show, flight))

  #     {:error, %Ecto.Changeset{} = changeset} ->
  #       render(conn, "edit.html", flight: flight, changeset: changeset)
  #   end
  # end

  def delete(conn, %{"user_id" => user_id, "id" => id}) do
    flight = Data.get_flight!(id)
    user = Data.get_user!(user_id)

    {:ok, _flight} = Data.delete_flight(flight)

    conn
    |> put_flash(:info, "Полет удален.")
    |> redirect(to: Routes.user_flight_path(conn, :index, user))
  end
end
