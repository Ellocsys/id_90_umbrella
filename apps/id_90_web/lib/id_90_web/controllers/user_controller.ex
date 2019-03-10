defmodule Id90Web.UserController do
  use Id90Web, :controller

  alias Id90.Data
  alias Id90.Data.User

  def index(conn, _params) do
    users = Data.list_users()
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = Data.change_user(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Data.create_user(user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Пользователь создан.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Data.get_user!(id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Data.get_user!(id)
    changeset = Data.change_user(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Data.get_user!(id)

    case Data.update_user(user, user_params) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Пользователь изменен.")
        |> redirect(to: Routes.user_path(conn, :show, user))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Data.get_user!(id)
    {:ok, _user} = Data.delete_user(user)

    conn
    |> put_flash(:info, "Пользователь удален  .")
    |> redirect(to: Routes.user_path(conn, :index))
  end
end
