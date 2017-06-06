defmodule RunLengthEncoding.EScript do
  def main([input]), do:
    input
    |> RunLengthEncoding.encode
    |> IO.puts
end
