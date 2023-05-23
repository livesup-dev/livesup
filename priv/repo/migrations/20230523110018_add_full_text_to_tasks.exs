defmodule LiveSup.Repo.Migrations.AddFullTextToTasks do
  use Ecto.Migration

  def change do
    # https://www.peterullrich.com/complete-guide-to-full-text-search-with-postgres-and-ecto

    execute("""
      ALTER TABLE tasks
        ADD COLUMN searchable tsvector
        GENERATED ALWAYS AS (
          setweight(to_tsvector('english', coalesce(title, '')), 'A') ||
          setweight(to_tsvector('english', coalesce(description, '')), 'B')
        ) STORED;
    """)

    execute("""
      CREATE INDEX tasks_searchable_idx ON tasks USING gin(searchable);
    """)
  end
end
