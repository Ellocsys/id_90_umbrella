defmodule Id90.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Id90.Repo

  require Logger

  alias Id90.Data.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Id90.Data.Flight

  @doc """
  Returns the list of flights.

  ## Examples

      iex> list_flights()
      [%Flight{}, ...]

  """
  def list_flights() do
    from(f in Flight, order_by: [desc: f.departure])
    |> Repo.all()
  end

  def list_flights(user_id) do
    from(f in Flight, where: [user_id: ^user_id], order_by: [desc: f.departure])
    |> Repo.all()
  end

  @doc """
  Gets a single flight.

  Raises `Ecto.NoResultsError` if the Flight does not exist.

  ## Examples

      iex> get_flight!(123)
      %Flight{}

      iex> get_flight!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flight!(id), do: Repo.get!(Flight, id)

  def maybe_update_current_flight(%{uid: uid, departure: departure}) do
    case get_flight_by(uid: uid, departure: departure) do
      nil ->
        %Flight{}

      result ->
        result
    end
  end

  def maybe_update_current_flight(%{}), do: %Flight{}

  def get_flight_by(params), do: Repo.get_by(Flight, params)

  @doc """
  Creates a flight.

  ## Examples

      iex> create_flight(%{field: value})
      {:ok, %Flight{}}

      iex> create_flight(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flight(attrs \\ %{}) do
    attrs
    |> maybe_update_current_flight()
    |> Flight.create_changeset(attrs)
    |> Repo.insert_or_update!()
  end

  @doc """
  Updates a flight.

  ## Examples

      iex> update_flight(flight, %{field: new_value})
      {:ok, %Flight{}}

      iex> update_flight(flight, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def update_flight(%Flight{arrive: arrive} = flight) do
    diff = NaiveDateTime.diff(NaiveDateTime.utc_now(), arrive)

    case diff > 0 and diff < 60 * 60 * 24 * 3 do
      true ->
        flight
        |> Flight.update_changeset()
        |> Repo.update()

      false ->
        flight
    end
  end

  @doc """
  Deletes a Flight.

  ## Examples

      iex> delete_flight(flight)
      {:ok, %Flight{}}

      iex> delete_flight(flight)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flight(%Flight{} = flight) do
    Repo.delete(flight)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flight changes.

  ## Examples

      iex> change_flight(flight)
      %Ecto.Changeset{source: %Flight{}}

  """
  # def change_flight(%Flight{} = flight) do
  #   Flight.changeset(flight, %{})
  # end

  def add_board_data(%Flight{departure: departure, uid: uid} = flight) do
    url =
      "http://onlineboard.aeroflot.ru/api/1/json/site/ru/flights/0/#{departure.year}.#{
        departure.month
      }.#{departure.day}/18/22/#{uid}"

    params =
      case HTTPoison.get(url, [], [timeout: 10_000, recv_timeout: 10_000]) do
        {:ok, %{status_code: 200, body: body}} ->
          [%{"departureTimeUtc" => departureTime, "arrivalTimeUtc" => arrivalTime}] =
            Jason.decode!(body)

          %{real_departure: departureTime, real_arrive: arrivalTime}

        {:error, %{reason: reason}} ->
          Logger.error(reason)
          %{}
      end

    Ecto.Changeset.change(flight, params)
  end

  @spec get_user_calendar(Id90.Data.User.t()) :: [ExIcal.Event.t()]
  def get_user_calendar(%User{remote_login: remote_login, remote_pass: remote_pass, id90: id90}) do
    url = "https://lk2.aeroflot.ru/lk/#{id90}.id"

    credentials = "#{remote_login}:#{remote_pass}" |> Base.encode64()

    headers = [{"Content-Type", "application/json"}, {"Authorization", "Basic #{credentials}"}]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 200, body: body}} ->
        ExIcal.parse(body)

      {:error, %{reason: reason}} ->
        Logger.error(reason)
    end
  end

  def from_event(%ExIcal.Event{
        uid: raw_uid,
        start: departure,
        end: arrive,
        description: description
      }) do
    [_date | uids] = String.split(raw_uid, "-")

    for uid <- uids,
        do: %{
          uid: uid,
          departure: departure,
          arrive: arrive,
          description: description,
          name: raw_uid
        }
  end
end
