defmodule Poker.RoundTest do
  use ExUnit.Case
  doctest Poker.Round

  test "deals a hand to each player" do
    {players, deck} = Poker.Round.new [:player1, :player2]

    # the deck must be 10 cards short after dealing the hands
    assert length(deck) == 52 - (5 * 2)

    %{player1: hand1, player2: hand2} = players

    # each player has 5 cards
    assert length(hand1) == 5
    assert length(hand2) == 5

    # there are no duplicate cards between the remaining deck and each hand
    full_deck = (hand1 ++ hand2 ++ deck)
    assert length(Enum.uniq(full_deck)) == 52
  end
end
