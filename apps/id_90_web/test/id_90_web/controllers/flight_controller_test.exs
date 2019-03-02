defmodule Id90Web.FlightControllerTest do
  use Id90Web.ConnCase

  alias Id90.Data

  @create_attrs %{arrive: ~N[2010-04-17 14:00:00], departure: ~N[2010-04-17 14:00:00], description: "some description", duration: 42, name: "some name", real_arrive: ~N[2010-04-17 14:00:00], real_departure: ~N[2010-04-17 14:00:00], real_duration: 42, uid: "some uid"}
  @update_attrs %{arrive: ~N[2011-05-18 15:01:01], departure: ~N[2011-05-18 15:01:01], description: "some updated description", duration: 43, name: "some updated name", real_arrive: ~N[2011-05-18 15:01:01], real_departure: ~N[2011-05-18 15:01:01], real_duration: 43, uid: "some updated uid"}
  @invalid_attrs %{arrive: nil, departure: nil, description: nil, duration: nil, name: nil, real_arrive: nil, real_departure: nil, real_duration: nil, uid: nil}

  def fixture(:flight) do
    {:ok, flight} = Data.create_flight(@create_attrs)
    flight
  end

  describe "index" do
    test "lists all flights", %{conn: conn} do
      conn = get(conn, Routes.flight_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Flights"
    end
  end

  describe "new flight" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.flight_path(conn, :new))
      assert html_response(conn, 200) =~ "New Flight"
    end
  end

  describe "create flight" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.flight_path(conn, :create), flight: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.flight_path(conn, :show, id)

      conn = get(conn, Routes.flight_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Flight"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.flight_path(conn, :create), flight: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Flight"
    end
  end

  describe "edit flight" do
    setup [:create_flight]

    test "renders form for editing chosen flight", %{conn: conn, flight: flight} do
      conn = get(conn, Routes.flight_path(conn, :edit, flight))
      assert html_response(conn, 200) =~ "Edit Flight"
    end
  end

  describe "update flight" do
    setup [:create_flight]

    test "redirects when data is valid", %{conn: conn, flight: flight} do
      conn = put(conn, Routes.flight_path(conn, :update, flight), flight: @update_attrs)
      assert redirected_to(conn) == Routes.flight_path(conn, :show, flight)

      conn = get(conn, Routes.flight_path(conn, :show, flight))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, flight: flight} do
      conn = put(conn, Routes.flight_path(conn, :update, flight), flight: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Flight"
    end
  end

  describe "delete flight" do
    setup [:create_flight]

    test "deletes chosen flight", %{conn: conn, flight: flight} do
      conn = delete(conn, Routes.flight_path(conn, :delete, flight))
      assert redirected_to(conn) == Routes.flight_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.flight_path(conn, :show, flight))
      end
    end
  end

  defp create_flight(_) do
    flight = fixture(:flight)
    {:ok, flight: flight}
  end
end
