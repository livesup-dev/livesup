defmodule LiveSup.Schemas.Slugs.GroupSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end
