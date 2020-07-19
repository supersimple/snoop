defmodule Snoop.HTMLState do
  @moduledoc false

  use Agent

  @spec start_link(list()) :: Agent.on_start()
  def start_link(init_state \\ []) do
    Agent.start_link(fn -> init_state end, name: __MODULE__)
  end

  def update(str) do
    Agent.update(__MODULE__, fn state ->
      state ++ [str]
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
