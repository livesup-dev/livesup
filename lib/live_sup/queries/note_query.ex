defmodule LiveSup.Queries.NoteQuery do
  import Ecto.Query

  alias LiveSup.Schemas.Note
  alias LiveSup.Repo

  def get!(id) do
    base()
    |> Repo.get!(id)
  end

  def get_by_slug!(slug) do
    base()
    |> where([notes: notes], notes.slug == ^slug)
    |> Repo.one!()
  end

  def get_by_slug(slug) do
    base()
    |> where([notes: notes], notes.slug == ^slug)
    |> Repo.one()
  end

  def get(id) do
    base()
    |> Repo.get(id)
  end

  def create(attrs) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update(model, attrs) do
    model
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def delete(model) do
    model
    |> Repo.delete()
  end

  def delete_all() do
    base()
    |> Repo.delete_all()
  end

  def base, do: from(Note, as: :notes)
end
