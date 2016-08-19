defmodule Earmark.Lexer do

  @moduledoc """
  We are implementing the following lexer

     _\w+(\w|_)*\w\b := :text
     _\w+(\w|_)*_\b  := :underscored
     _+\b            := :us
  """
  
end
