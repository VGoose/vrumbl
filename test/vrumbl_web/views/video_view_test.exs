defmodule VrumblWeb.VideoViewTest do
  use VrumblWeb.ConnCase, async: true
  import Phoenix.View

  test "renders index", %{conn: conn} do
    videos = [
      %Vrumbl.Multimedia.Video{id: 1, title: "foobar"},
      %Vrumbl.Multimedia.Video{id: 2, title: "foobar pt 2"}
    ]

    content = render_to_string(VrumblWeb.VideoView, "index.html", conn: conn, videos: videos)

    assert String.contains?(content, "Listing Videos")

    for video <- videos do
      assert String.contains?(content, video.title)
    end
  end

  test "renders new", %{conn: conn} do
    changeset = Vrumbl.Multimedia.change_video(%Vrumbl.Multimedia.Video{})
    categories = [%Vrumbl.Multimedia.Category{id: 123, name: "cats"}]

    content =
      render_to_string(VrumblWeb.VideoView, "new.html",
        conn: conn,
        changeset: changeset,
        categories: categories
      )

    assert String.contains?(content, "New Video")
  end
end
