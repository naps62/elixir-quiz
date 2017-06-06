defmodule FizzBuzz do
  @spec transform(integer) :: integer | String.t
  def transform(n) when rem(n, 3 * 5) == 0, do: "FizzBuzz"
  def transform(n) when rem(n, 3) == 0, do: "Fizz"
  def transform(n) when rem(n, 5) == 0, do: "Buzz"
  def transform(n), do: n

  @spec up_to(integer) :: String.t
  def up_to(n), do:
    1..n
    |> Enum.map(&transform/1)
    |> Enum.join(" ")

  def all, do: up_to(100)
end
