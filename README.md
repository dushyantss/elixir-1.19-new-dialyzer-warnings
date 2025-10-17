# Elixir 1.19 New Dialyzer Warnings

Reproduction cases for new dialyzer warnings introduced in Elixir 1.19 / Erlang 28.1.

## Background

After upgrading to Elixir 1.19 and Erlang 28.1, dialyzer has become **stricter about opaque types**, particularly with `MapSet`'s internal representation. This project demonstrates the new warnings that appear when using common libraries like Ecto, Carbonite, and Oban.

## The Issue

The core problem is that `Ecto.Multi.new()` creates a struct with a `MapSet` for tracking operation names:

```elixir
%Ecto.Multi{
  names: MapSet.new(),  # Internal: %MapSet{map: #{}}
  operations: []
}
```

In Elixir 1.19 / Erlang 28.1, dialyzer now strictly enforces that `MapSet.map` is an **opaque type** (`MapSet.internal(_)`), and rejects code that pattern-matches on the literal empty map `#{}`.

## Affected Patterns

### 1. Carbonite.Multi.insert_transaction
```elixir
Ecto.Multi.new()
|> Carbonite.Multi.insert_transaction(%{meta: %{type: "example"}})
```

### 2. Ecto.Multi operations
```elixir
Ecto.Multi.new()
|> Ecto.Multi.insert(:step, changeset)
|> Ecto.Multi.run(:step, fn _repo, _changes -> {:ok, :result} end)
```

### 3. URI.to_string with struct literals
```elixir
URI.to_string(%URI{scheme: "https", host: "example.com"})
```

## Reproducing the Warnings

```bash
# Install dependencies
mix deps.get

# Compile the project
mix compile

# Run dialyzer (this will fail with 8 warnings)
mix dialyzer
```

**Expected output:** 8 dialyzer errors related to opaque type mismatches with `MapSet.internal(_)`.

**Don't want to run dialyzer?** See [DIALYZER_ERRORS.md](DIALYZER_ERRORS.md) for the exact error output.

## Runtime Verification

The code works perfectly at runtime! You can verify this:

```elixir
iex -S mix
iex> ElixirDialyzerWarnings.Examples.run_all_examples()
```

All examples will execute successfully, demonstrating that this is a dialyzer-only issue, not a runtime bug.

## Environment

- **Elixir:** 1.19.0
- **Erlang/OTP:** 28.1
- **Ecto:** 3.13+
- **Carbonite:** 0.4+
- **Dialyxir:** 1.4+

## Contributing

If you've encountered similar issues or have solutions, please open an issue or PR!

## License

This project is released into the public domain for educational purposes.
