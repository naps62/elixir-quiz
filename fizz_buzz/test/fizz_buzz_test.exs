defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  test "the number 1" do
    assert FizzBuzz.transform(1) == 1
  end

  test "the number 2" do
    assert FizzBuzz.transform(2) == 2
  end

  test "the number 3" do
    assert FizzBuzz.transform(3) == "Fizz"
  end

  test "the number 5" do
    assert FizzBuzz.transform(5) == "Buzz"
  end

  test "the number 15" do
    assert FizzBuzz.transform(15) == "FizzBuzz"
  end

  test "a full list" do
    assert FizzBuzz.up_to(15) == "1 2 Fizz 4 Buzz Fizz 7 8 Fizz Buzz 11 Fizz 13 14 FizzBuzz"
  end
end
