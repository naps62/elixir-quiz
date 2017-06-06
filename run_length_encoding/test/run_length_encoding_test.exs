defmodule RunLengthEncodingTest do
  use ExUnit.Case
  doctest RunLengthEncoding

  test "a single character" do
    assert RunLengthEncoding.encode("a") == "1a"
  end

  test "several different characters" do
    assert RunLengthEncoding.encode("abc") == "1a1b1c"
  end

  test "same characters" do
    assert RunLengthEncoding.encode("aaa") == "3a"
  end

  test "the example input string" do
    assert RunLengthEncoding.encode("JJJTTWPPMMMMYYYYYYYYYVVVVVV") == "3J2T1W2P4M9Y6V"
  end
end
