defmodule VrumblWeb.VideoChannel do
  use VrumblWeb, :channel

  alias VrumblWeb.AnnotationView

  def join("videos:" <> video_id, params, socket) do
    send(self(), :after_join)
    last_seen_id = params["last_seen_id"] || 0
    video_id = String.to_integer(video_id)
    video = Vrumbl.Multimedia.get_video!(video_id)

    annotations =
      video
      |> Vrumbl.Multimedia.list_annotations(last_seen_id)
      |> Phoenix.View.render_many(AnnotationView, "annotation.json")

    {:ok, %{annotations: annotations}, assign(socket, :video_id, video_id)}
  end

  def handle_info(:after_join, socket) do
    push(socket, "presence_state", VrumblWeb.Presence.list(socket))

    {:ok, _} =
      VrumblWeb.Presence.track(
        socket,
        socket.assigns.user_id,
        %{device: "browser"}
      )

    {:noreply, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in(event, params, socket) do
    user = Vrumbl.Accounts.get_user!(socket.assigns.user_id)
    handle_in(event, params, socket, user)
  end

  def handle_in("new_annotation", params, socket, user) do
    case Vrumbl.Multimedia.annotate_video(user, socket.assigns.video_id, params) do
      {:ok, annotation} ->
        broadcast!(socket, "new_annotation", %{
          id: annotation.id,
          user: VrumblWeb.UserView.render("user.json", %{user: user}),
          body: annotation.body,
          at: annotation.at
        })

        {:reply, :ok, socket}

      {:error, changeset} ->
        {:reply, {:error, %{errors: changeset}}, socket}
    end
  end

  # # It is also common to receive messages from the client and
  # # broadcast to everyone in the current topic (video:lobby).
  # @impl true
  # def handle_in("shout", payload, socket) do
  #   broadcast(socket, "shout", payload)
  #   {:noreply, socket}
  # end

  # # Add authorization logic here as required.
  # defp authorized?(_payload) do
  #   true
  # end
end
