defmodule LiveSup.Core.MemoryStore do
  use GenServer

  @table :memory_cache
  # 5 minutes
  @default_ttl 5 * 60

  def start_link(_args) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Create a new ETS Cache if it doesn't already exists
  """
  def init(_) do
    # gives us key=>value semantics
    :ets.new(@table, [
      :set,

      # allows any process to read/write to our table
      :public,

      # allow the ETS table to access by it's name, `@table`
      :named_table,

      # favor read-locks over write-locks
      read_concurrency: true,

      # internally split the ETS table into buckets to reduce
      # write-lock contention
      write_concurrency: true
    ])

    {:ok, nil}
  rescue
    ArgumentError -> {:error, :already_started}
  end

  def get(key, ttl \\ @default_ttl) do
    case :ets.lookup(@table, key) do
      [{_key, value, ts}] ->
        if timestamp() - ts <= ttl do
          {:ok, value}
        else
          {:error, :expired}
        end

      _ ->
        {:error, :not_found}
    end
  end

  def put(key, value) do
    true = :ets.insert(@table, {key, value, timestamp()})

    {:ok, value}
  end

  def get_or_store(key, fun, opts \\ []) do
    case get(key, opts[:ttl]) do
      {:ok, value} -> {:ok, value}
      {:error, _} -> put(key, fun.())
    end
  end

  def delete(key) do
    case :ets.lookup(@table, key) do
      [{_key, _value, _ts}] ->
        true = :ets.delete(@table, key)
        {:ok, :deleted}

      _ ->
        {:error, :not_found}
    end
  end

  # Return current timestamp
  defp timestamp, do: DateTime.to_unix(DateTime.utc_now())
end
