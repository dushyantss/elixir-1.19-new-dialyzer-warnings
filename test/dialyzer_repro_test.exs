defmodule ElixirDialyzerWarningsTest do
  use ExUnit.Case
  doctest ElixirDialyzerWarnings

  test "examples module loads successfully" do
    assert Code.ensure_loaded?(ElixirDialyzerWarnings.Examples)
  end

  test "examples demonstrate dialyzer warnings but work at runtime" do
    # These functions trigger dialyzer warnings but work fine at runtime
    assert %Ecto.Multi{} = ElixirDialyzerWarnings.Examples.carbonite_multi_example()
    assert %Ecto.Multi{} = ElixirDialyzerWarnings.Examples.ecto_multi_update_all_example()
    assert is_binary(ElixirDialyzerWarnings.Examples.uri_to_string_example())
  end
end
