defmodule TokenLexer.XrlTest do
  use ExUnit.Case

  test "empty" do 
  assert tokenize("") == []
  end

  test "new lines" do
    assert tokenize("\n") == [ {:nl, 1, ""} ]
  end

  test "text tokens" do
    assert tokenize("\nHello") == [
      {:nl, 1, ""},
      {:any, 2, "Hello"}
    ]
  end

  test "more text tokens" do
    assert tokenize("\nHello World") == [
      {:nl, 1, ""},
      {:any, 2, "Hello"},
      {:ws, 2, " "},
      {:any, 2, "World"}
    ]
  end

  test "underscored" do
    assert tokenize("\n_hello_") == [
      {:nl, 1, ""},
      {:us, 2, "_"},
      {:any, 2, "hello"},
      {:us, 2, "_"}
    ]
  end

  test "special and not so special" do
    assert tokenize("\n*x  # --\n hello-world") == [
      {:nl, 1, ""},
      {:star, 2, "*"},
      {:any, 2, "x"},
      {:ws, 2, "  "},
      {:hash, 2, "#"},
      {:ws, 2, " "},
      {:dash, 2, "--"},
      {:nl, 2, ""},
      {:ws, 3, " "},
      {:any, 3, "hello"},
      {:dash, 3, "-"},
      {:any, 3, "world"}
    ]
  end

  test "few tokens" do 
    assert tokens("hello") == [:ws,  :ws, :any] 
  end
  test "only tokens" do
    assert tokens("<>(){}[ ]|\" <!-- -\n# text") == [
      :open_ptd, :close_ptd,
      :open_paren, :close_paren,
      :open_acc, :close_acc,
      :open_bkt, :ws, :close_bkt,
      :vert_bar, :quote, :ws,
      :open_cmt, :ws, :dashes,
      :nl, :hashes, :ws, :any,
    ]
  end

  test "more tokens" do
    assert tokenize("(a[  {?!8 )]\n|") == [
          {:open_paren, 1, "("},
          {:any, 1, "a"},
          {:open_bkt, 1, "["},
           {:ws, 1, "  "},
           {:open_acc, 1, "{"},
           {:any, 1, "?!8"},
            {:ws, 1, " "},
            {:close_paren, 1,")"},
            {:close_bkt, 1, "]"},
           {:nl, 1, ""},
           {:vert_bar, 2, "|"}
         ]
  end

  test "utf-8" do 
    assert tokenize("ç") == [{:any, 1, "ç"}]
  end

  test "file" do
    File.read!( "README.md" )
    |> tokenize()
    |> IO.inspect()

  end

  defp tokenize input do 
  {:ok, tokens, _} =
  input
  |> to_char_list()
  |> :token_lexer.string()
  elixirize_tokens(tokens,[])
  |> Enum.reverse()
  end

  def tokens input do 
    input
    |> tokenize()
    |> Enum.map( fn {tok, _, _} -> tok end)
  end

  defp elixirize_tokens(tokens, rest)
  defp elixirize_tokens([], result), do: result
  defp elixirize_tokens([{token, line, text}|rest], result), do: elixirize_tokens(rest, [{token, line, to_string(text)}|result])
end
