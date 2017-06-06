defmodule RunLengthEncoding do
  @regex ~r/(.)\1*(?!\1)/

  @spec encode(String.t) :: String.t
  def encode(str), do:
    Regex.scan(@regex, str)
    |> Stream.map(&List.first/1)
    |> Enum.map(&encode_section/1)
    |> Enum.join

  @spec encode_section(String.t) :: String.t
  def encode_section(str), do:
    [String.length(str), String.at(str, 0)]
    |> Enum.join()
end
