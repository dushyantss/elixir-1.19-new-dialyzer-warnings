defmodule ElixirDialyzerWarnings.Examples do
  @moduledoc """
  Demonstrates dialyzer opaque type warnings when using Ecto.Multi and related libraries.

  These examples work correctly at runtime but trigger dialyzer warnings due to
  stricter opaque type checking in Elixir 1.19 / Erlang 28.1.

  To test with Dialyzer:
    1. mix deps.get
    2. mix compile
    3. mix dialyzer

  You should see warnings about `MapSet.internal(_)` opaque type mismatches.
  """

  # ==========================================================================
  # Issue 1: Carbonite.Multi.insert_transaction
  # ==========================================================================
  def carbonite_multi_example do
    Ecto.Multi.new()
    |> Carbonite.Multi.insert_transaction(%{meta: %{type: "example_transaction"}})
    |> Ecto.Multi.run(:step, fn _repo, _changes -> {:ok, :result} end)
  end

  # ==========================================================================
  # Issue 2: Ecto.Multi chained operations
  # ==========================================================================
  def ecto_multi_chain_example do
    # Create a dummy changeset for demonstration
    changeset = %Ecto.Changeset{
      action: :insert,
      changes: %{},
      errors: [],
      data: %{},
      valid?: true
    }
    
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:insert_step, changeset)
    |> Ecto.Multi.run(:run_step, fn _repo, _changes -> {:ok, :value} end)
    |> Ecto.Multi.update(:update_step, changeset)
  end

  def ecto_multi_update_all_example do
    import Ecto.Query
    
    Ecto.Multi.new()
    |> Ecto.Multi.update_all(:step, from(u in "users"), set: [status: "active"])
  end

  def ecto_multi_delete_all_example do
    import Ecto.Query
    
    Ecto.Multi.new()
    |> Ecto.Multi.delete_all(:step, from(u in "users", where: u.expired == true))
  end

  # ==========================================================================
  # Issue 3: URI.to_string
  # ==========================================================================
  def uri_to_string_example do
    URI.to_string(%URI{
      scheme: "https",
      host: "example.com",
      path: "/api/v1/resource",
      port: 443
    })
  end

  def uri_to_string_with_query_example do
    URI.to_string(%URI{
      scheme: "https",
      host: "api.example.com",
      path: "/search",
      query: "q=elixir"
    })
  end

  # Demonstrate that the code actually works at runtime
  def run_all_examples do
    IO.puts("\n=== Running Examples ===\n")
    
    IO.puts("1. Carbonite Multi example:")
    result1 = carbonite_multi_example()
    IO.inspect(result1, label: "Result")
    
    IO.puts("\n2. Ecto Multi chain example:")
    result2 = ecto_multi_chain_example()
    IO.inspect(result2, label: "Result")
    
    IO.puts("\n3. Ecto Multi update_all example:")
    result3 = ecto_multi_update_all_example()
    IO.inspect(result3, label: "Result")
    
    IO.puts("\n4. Ecto Multi delete_all example:")
    result4 = ecto_multi_delete_all_example()
    IO.inspect(result4, label: "Result")
    
    IO.puts("\n5. URI to_string example:")
    result5 = uri_to_string_example()
    IO.inspect(result5, label: "Result")
    
    IO.puts("\n6. URI to_string with query example:")
    result6 = uri_to_string_with_query_example()
    IO.inspect(result6, label: "Result")
    
    IO.puts("\n✓ All examples executed successfully!")
    IO.puts("The code works at runtime, but may trigger Dialyzer warnings.")
  end
end
