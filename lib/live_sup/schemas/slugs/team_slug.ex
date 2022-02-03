defmodule LiveSup.Schemas.Slugs.TeamSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end
