defmodule VrumblWeb.PageController do
  use VrumblWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
