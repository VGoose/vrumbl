defmodule VrumblWeb.UserView do
  use VrumblWeb, :view

  alias Vrumbl.Accounts
  # def index() do

  # end
  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end

  def render("user.json", %{user: user}) do
    %{id: user.id, username: user.username}
  end
end
