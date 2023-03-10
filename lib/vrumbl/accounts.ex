defmodule Vrumbl.Accounts do
  @moduledoc """
  The Accounts context.
  """

  alias Vrumbl.Repo
  alias Vrumbl.Accounts.User

  def list_users do
    Repo.all(User)
  end

  import Ecto.Query
  def list_users_with_ids(ids) do
    Repo.all(from(u in User, where: u.id in ^ids))
  end

  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def change_registration(%User{} = user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(params \\ %{}) do
    %User{}
    |> User.registration_changeset(params)
    |> Repo.insert()
  end

  def authenticate_by_login(username, pass) do
    user = get_user_by(username: username)

    cond do
      user && Pbkdf2.verify_pass(pass, user.password_hash) ->
        {:ok, user}

      user ->
        {:error, :unauthorized}

      true ->
        Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end
end
