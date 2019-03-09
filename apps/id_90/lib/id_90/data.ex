defmodule Id90.Data do
  @moduledoc """
  The Data context.
  """

  import Ecto.Query, warn: false
  alias Id90.Repo

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
  def list_flights do
    Repo.all(Flight)
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

  @doc """
  Creates a flight.

  ## Examples

      iex> create_flight(%{field: value})
      {:ok, %Flight{}}

      iex> create_flight(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flight(attrs \\ %{}) do
    %Flight{}
    |> Flight.changeset(attrs)
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
  def update_flight(%Flight{} = flight, attrs) do
    flight
    |> Flight.changeset(attrs)
    |> Repo.update()
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
  def change_flight(%Flight{} = flight) do
    Flight.changeset(flight, %{})
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
        IO.inspect(reason)
    end
  end
end
