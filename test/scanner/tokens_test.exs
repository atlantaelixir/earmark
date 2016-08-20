defmodule Scanner.TokensTest do
  use ExUnit.Case

  alias Earmark.Scanner.Token
  import Token, only: [scan: 1]

  test "scanning two lines" do 
    assert scan("alpha\nbeta") == [
      %Token.Text{text: "alpha", line: 1}, %Token.Nl{line: 1},
      %Token.Text{text: "beta", line: 2}, %Token.Nl{line: 2}
    ]
  end
  
end
