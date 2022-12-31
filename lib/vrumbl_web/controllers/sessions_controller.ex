defmodule VrumblWeb.SessionController do
  alias Phoenix.LiveView.Route
  use VrumblWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"username" => username, "password" => pass}}) do
    case Vrumbl.Accounts.authenticate_by_login(username, pass) do
      {:ok, user} ->
        conn
        |> VrumblWeb.Auth.login(user)
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _params) do
    conn
    |> VrumblWeb.Auth.logout()
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
