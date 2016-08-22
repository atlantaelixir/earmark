defmodule TokenLexer.XrlTest do
  use ExUnit.Case

  test "singles" do 
    assert tokens1("__` x") == [ :single, :single, :backticks, :ws, :any ]
  end

  test "all singles" do
    all_singles = "_<>*[](){}+-.\":"
    assert tokens(all_singles) ==
      Enum.zip( Stream.cycle([:single]), String.to_char_list(all_singles) )
  end

  test "mixed" do
    assert tokens(" hello,_`x") == [
      { :ws, " "},
      { :any, "hello,"},
      { :single, ?_},
      { :backticks, 1},
      { :any, "x"}
    ]
  end

  test "multiples" do 
    assert tokens("###### #######") == [
      { :hashes, 6 },
      { :ws, " "},
      { :any, "#######" }
    ]
  end

  defp tokens input do 
  {:ok, tokens, _} =
  input
  |> to_char_list()
  |> :token_lexer.string()
  elixirize_tokens(tokens,[])
  |> Enum.reverse()
  end


  def tokens1 input do 
    input
    |> tokens()
    |> Enum.map( fn { tok, _content} -> tok end)
  end

  defp elixirize_tokens(tokens, rest)
  defp elixirize_tokens([], result), do: result
  defp elixirize_tokens([{token, content}|rest], result) when is_list(content) do 
    elixirize_tokens(rest, [{token, to_string(content)}|result])
  end
  defp elixirize_tokens([{token, content}|rest], result) do 
    elixirize_tokens(rest, [{token, content}|result])
  end
end
