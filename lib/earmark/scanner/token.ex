defmodule Earmark.Scanner.Token do

  defmodule Backticks, do: defstruct line: 1, count: 1000
  defmodule Hashes, do: defstruct line: 1, level: 6
  defmodule Nl,     do: defstruct line: 1
  defmodule Text,   do: defstruct line: 1, text: "..."
  defmodule Whitespace, do: defstruct line: 1, text: " \t"

  @type t :: %Nl{} | %Text{}
  @type ts :: list(t)

  @doc """
  """
  def scan text do 
    text 
    |> String.split( ~r{\r\n?|\n} )
    |> Enum.with_index()
    |> parallel_flat_map( &tokenize/1 )
  end

  @doc false
  def tokenize {line, lnb} do 
  with {:ok, tokens, _} <- line
    |> to_char_list()
    |> :token_lexer.string() do
      unify_tokens( tokens, lnb + 1 )
    end
  end


  @doc false
  @spec parallel_flat_map( list(A), (A -> ts) ) :: ts
  defp parallel_flat_map collection, func do
   collection
   |> Enum.map(fn item -> Task.async(fn -> func.(item) end) end)
   |> Enum.flat_map(&Task.await/1)
  end
  

  defp unify_tokens tokens, lnb do
    _unify_tokens(tokens, lnb, [])
  end

  defp _unify_tokens tokens, lnb, result

  defp _unify_tokens [{:any, text}|rest], lnb, result do
    _unify_tokens( rest, lnb, [%Text{line: lnb, text: to_string(text)}|result] )
  end

  defp _unify_tokens [{:backticks, count}|rest], lnb, result do
    _unify_tokens( rest, lnb, [%Backticks{line: lnb, count: count}|result] )
  end

  defp _unify_tokens [{:hashes, level}|rest], lnb, result do
    _unify_tokens( rest, lnb, [%Hashes{line: lnb, level: level}|result] )
  end

  defp _unify_tokens [{:ws, text}|rest], lnb, result do
    _unify_tokens( rest, lnb, [%Whitespace{line: lnb, text: to_string(text)}|result] )
  end

  defp _unify_tokens [], lnb, result do 
    [%Nl{line: lnb} | result]
    |> Enum.reverse()
  end
    
end
