defmodule VrumblWeb.AnnotationView do
  use VrumblWeb, :view

  def render("annotation.json", %{annotation: annotation}) do
    %{
      id: annotation.id,
      body: annotation.body,
      at: annotation.at,
      user: render_one(annotation.user, VrumblWeb.UserView, "user.json")
    }
  end
end
