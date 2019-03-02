defmodule Id90.DataTest do
  use Id90.DataCase

  alias Id90.Data

  describe "users" do
    alias Id90.Data.User

    @valid_attrs %{id90: "some id90", login: "some login", pass: "some pass", remote_login: "some remote_login", remote_pass: "some remote_pass"}
    @update_attrs %{id90: "some updated id90", login: "some updated login", pass: "some updated pass", remote_login: "some updated remote_login", remote_pass: "some updated remote_pass"}
    @invalid_attrs %{id90: nil, login: nil, pass: nil, remote_login: nil, remote_pass: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Data.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Data.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Data.create_user(@valid_attrs)
      assert user.id90 == "some id90"
      assert user.login == "some login"
      assert user.pass == "some pass"
      assert user.remote_login == "some remote_login"
      assert user.remote_pass == "some remote_pass"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Data.update_user(user, @update_attrs)
      assert user.id90 == "some updated id90"
      assert user.login == "some updated login"
      assert user.pass == "some updated pass"
      assert user.remote_login == "some updated remote_login"
      assert user.remote_pass == "some updated remote_pass"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_user(user, @invalid_attrs)
      assert user == Data.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Data.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Data.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Data.change_user(user)
    end
  end

  describe "flights" do
    alias Id90.Data.Flight

    @valid_attrs %{arrive: ~N[2010-04-17 14:00:00], departure: ~N[2010-04-17 14:00:00], description: "some description", duration: 42, name: "some name", real_arrive: ~N[2010-04-17 14:00:00], real_departure: ~N[2010-04-17 14:00:00], real_duration: 42, uid: "some uid"}
    @update_attrs %{arrive: ~N[2011-05-18 15:01:01], departure: ~N[2011-05-18 15:01:01], description: "some updated description", duration: 43, name: "some updated name", real_arrive: ~N[2011-05-18 15:01:01], real_departure: ~N[2011-05-18 15:01:01], real_duration: 43, uid: "some updated uid"}
    @invalid_attrs %{arrive: nil, departure: nil, description: nil, duration: nil, name: nil, real_arrive: nil, real_departure: nil, real_duration: nil, uid: nil}

    def flight_fixture(attrs \\ %{}) do
      {:ok, flight} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Data.create_flight()

      flight
    end

    test "list_flights/0 returns all flights" do
      flight = flight_fixture()
      assert Data.list_flights() == [flight]
    end

    test "get_flight!/1 returns the flight with given id" do
      flight = flight_fixture()
      assert Data.get_flight!(flight.id) == flight
    end

    test "create_flight/1 with valid data creates a flight" do
      assert {:ok, %Flight{} = flight} = Data.create_flight(@valid_attrs)
      assert flight.arrive == ~N[2010-04-17 14:00:00]
      assert flight.departure == ~N[2010-04-17 14:00:00]
      assert flight.description == "some description"
      assert flight.duration == 42
      assert flight.name == "some name"
      assert flight.real_arrive == ~N[2010-04-17 14:00:00]
      assert flight.real_departure == ~N[2010-04-17 14:00:00]
      assert flight.real_duration == 42
      assert flight.uid == "some uid"
    end

    test "create_flight/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Data.create_flight(@invalid_attrs)
    end

    test "update_flight/2 with valid data updates the flight" do
      flight = flight_fixture()
      assert {:ok, %Flight{} = flight} = Data.update_flight(flight, @update_attrs)
      assert flight.arrive == ~N[2011-05-18 15:01:01]
      assert flight.departure == ~N[2011-05-18 15:01:01]
      assert flight.description == "some updated description"
      assert flight.duration == 43
      assert flight.name == "some updated name"
      assert flight.real_arrive == ~N[2011-05-18 15:01:01]
      assert flight.real_departure == ~N[2011-05-18 15:01:01]
      assert flight.real_duration == 43
      assert flight.uid == "some updated uid"
    end

    test "update_flight/2 with invalid data returns error changeset" do
      flight = flight_fixture()
      assert {:error, %Ecto.Changeset{}} = Data.update_flight(flight, @invalid_attrs)
      assert flight == Data.get_flight!(flight.id)
    end

    test "delete_flight/1 deletes the flight" do
      flight = flight_fixture()
      assert {:ok, %Flight{}} = Data.delete_flight(flight)
      assert_raise Ecto.NoResultsError, fn -> Data.get_flight!(flight.id) end
    end

    test "change_flight/1 returns a flight changeset" do
      flight = flight_fixture()
      assert %Ecto.Changeset{} = Data.change_flight(flight)
    end
  end
end
