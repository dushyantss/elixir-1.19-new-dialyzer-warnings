defmodule ElixirDialyzerWarnings do
  @moduledoc """
  Reproduction cases for new dialyzer warnings introduced in Elixir 1.19 / Erlang 28.1.

  This project demonstrates stricter opaque type checking, particularly with:
  - Ecto.Multi operations
  - Carbonite.Multi.insert_transaction
  - Oban.Pro.Workflow operations
  - URI.to_string

  ## Running Dialyzer

      mix deps.get
      mix compile
      mix dialyzer

  You should see warnings about opaque types in `MapSet.internal(_)` that were
  not present in earlier Elixir/Erlang versions.
  """
end
