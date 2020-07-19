defmodule Snoop do
  @moduledoc """
  Snoop helps with trees. Specifically, makes directory trees from a path in your file system.

  ## Examples
      Snoop.build_tree("./lib")
      #=> [.: ["app.ex": nil, "helpers": ["helper.ex": nil]]]

      Snoop.print_html_tree("./lib")
      #=> <ul><li>app.ex</li><li>helpers<ul><li>helper.ex</li></ul></ul>
  """

  @max_depth Application.get_env(:snoop, :max_depth, 5)

  @doc """
  Given a base path, build the file tree below it.
  """
  def build_tree(base_path, opts \\ []) do
    initialize_state()
    excluded = Keyword.get(opts, :excluded, [])

    case File.ls(base_path) do
      {:ok, list} ->
        create_base_dir(base_path)
        recursive_traverse(list, base_path, excluded, 0)

      _ ->
        raise(ArgumentError, "Base path does not exist.")
    end
  end

  @doc """
  Given a base path, prints out the existing tree as HTML list(s).
  This operation reads from the previously built tree (using `build_tree/2`) for performance reasons.
  Building a tree takes time, and you may want to print it more than once.
  """
  def print_html_tree(base_path) do
    Snoop.Output.print_html(base_path)
  end

  defp recursive_traverse(_list, _path, _excluded, @max_depth), do: :noop

  defp recursive_traverse(list, path, excluded, depth) do
    Enum.each(list, fn file ->
      unless file in excluded do
        full_path = Path.join(path, file)
        split_path = path |> Path.split() |> convert_to_atom_list()

        if File.dir?(full_path) do
          Snoop.State.update(split_path, [{String.to_atom(file), []}])
          full_path |> File.ls!() |> recursive_traverse(full_path, excluded, depth + 1)
        else
          Snoop.State.update(split_path, [{String.to_atom(file), nil}])
        end
      end
    end)

    Snoop.State.current_state()
  end

  defp convert_to_atom_list(list), do: Enum.map(list, &String.to_atom(&1))

  defp create_base_dir(path) do
    list = path |> Path.split() |> convert_to_atom_list()

    Enum.reduce(list, [], fn dir, acc ->
      acc = acc ++ [dir]
      Snoop.State.update(acc, [])
      acc
    end)
  end

  def initialize_state do
    Snoop.State.start_link()
    Snoop.State.reset()
  end
end
