defmodule Snoop.State do
  @moduledoc false

  use Agent

  @spec start_link(list()) :: Agent.on_start()
  def start_link(init_state \\ []) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def update(k, v) do
    Agent.update(__MODULE__, fn state ->
      if get_in(state, k) do
        update_in(state, k, &(&1 ++ v))
      else
        put_in(state, k, v)
      end
    end)
  end

  @spec reset() :: :ok
  def reset do
    Agent.update(__MODULE__, fn _state -> [] end)
  end

  @spec current_state() :: list()
  def current_state do
    Agent.get(__MODULE__, fn state -> state end)
  end
end
