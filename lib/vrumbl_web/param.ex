defimpl Phoenix.Param, for: Vrumbl.Multimedia.Video do
  # Elixir protocol
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end
