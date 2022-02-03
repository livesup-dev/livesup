defmodule LiveSup.Schemas.Slugs.ProjectSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end
