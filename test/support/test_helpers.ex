defmodule Vrumbl.TestHelpers do
  alias Vrumbl.{Accounts, Multimedia}

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        name: "foo",
        username: "user#{System.unique_integer([:positive])}",
        password: attrs[:password] || "pass"
      })
      |> Accounts.register_user()
    user
  end

  def video_fixture(%Accounts.User{} = user, attrs \\%{}) do
    attrs = Enum.into(attrs, %{
      title: "My Video",
      url: "http://www.example.com",
      description: "My video description"
    })

    {:ok, video} = Multimedia.create_video(user, attrs)

    video
  end
end
