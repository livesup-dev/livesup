defmodule LiveSup.Schemas.Slugs.WidgetSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end
