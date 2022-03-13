defmodule LiveSup.Schemas.Slugs.MetricSlug do
  use EctoAutoslugField.Slug, from: :name, to: :slug
end
