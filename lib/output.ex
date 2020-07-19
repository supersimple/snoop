defmodule Snoop.Output do
  @moduledoc false

  def print_html(base_dir) do
    initialize_state()
    base_path = base_dir |> Path.split() |> convert_to_atom_list()

    Snoop.State.current_state()
    |> get_in(base_path)
    |> do_print_html()
  end

  defp do_print_html(list) do
    Snoop.HTMLState.update("<ul>")

    Enum.each(list, fn {k, v} ->
      if is_list(v) do
        Snoop.HTMLState.update("<ul><li>#{k}")
        do_print_html(v)
        Snoop.HTMLState.update("</li></ul>")
      else
        Snoop.HTMLState.update("<li>#{k}</li>")
      end
    end)

    Snoop.HTMLState.update("</ul>")
    Snoop.HTMLState.current_state() |> Enum.join("")
  end

  defp convert_to_atom_list(list), do: Enum.map(list, &String.to_atom(&1))

  def initialize_state do
    Snoop.HTMLState.start_link()
    Snoop.HTMLState.reset()
  end
end
