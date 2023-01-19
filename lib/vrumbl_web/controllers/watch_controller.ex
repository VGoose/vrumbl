defmodule VrumblWeb.WatchController do
  use VrumblWeb, :controller
  alias Vrumbl.Multimedia

  def show(conn, %{"id" => id}) do
    video = Multimedia.get_video!(id)
    render(conn, "show.html", video: video)
  end
end
