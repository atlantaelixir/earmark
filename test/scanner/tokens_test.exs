defmodule Scanner.TokensTest do
  use ExUnit.Case

  alias Earmark.Scanner.Token
  import Token

  test "scanning two lines" do 
    assert scan("alpha\nbeta") == [
      %Token.Text{text: "alpha", line: 1}, %Token.Nl{line: 1},
      %Token.Text{text: "beta", line: 2}, %Token.Nl{line: 2}
    ]
  end

  test "1 to 1 lexical tokens" do
    assert [
      %Token.Hashes{level: 2}, %Token.Whitespace{text: " "}, %Token.Hashes{level: 1}, %Token.Backticks{count: 3}, %Token.Nl{}
    ] = scan("## #```")
  end
  
end
