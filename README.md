# Snoop

Snoop is all about trees.
Specfically, given a path on your file system,
Snoop will return the directory tree including all files.

## Configuration
Snoop defaults to a maximum depth of 5 levels. If you wish to change that, add this to your config:
```elixir
config :snoop, max_depth: 13
```
## Installation

The package can be installed
by adding `snoop` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:snoop, "~> 0.1.0"}
  ]
end
```
