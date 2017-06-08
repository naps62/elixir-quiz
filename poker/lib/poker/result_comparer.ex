defmodule Poker.ResultComparer do
  alias Poker.{HandResult, Card, Deck}

  @type t :: {:winner, atom} | {:draw}

  @type player_and_result :: {atom, HandResult.t}
  @type player_and_cards :: {atom, list(Card.t)}

  @doc ~S"""
  Compares two hands. To be used for sorting
  """
  @spec compare(player_and_result, player_and_result) :: t
  def compare({player1, {_, cards1} = result1}, {player2, {_, cards2} = result2}) do
    numerical_result1 = Poker.HandResult.numerical_value(result1)
    numerical_result2 = Poker.HandResult.numerical_value(result2)

    cond do
      numerical_result1 > numerical_result2 ->
        {:winner, player1}
      numerical_result2 > numerical_result1 ->
        {:winner, player2}
      true ->
        compare_by_tie_break({player1, cards1}, {player2, cards2})
    end
  end

  @doc ~S"""
  If both hands are tied, this compares the tie breaker cards to determine the winner
  """
  @spec compare_by_tie_break(player_and_cards, player_and_cards) :: t
  def compare_by_tie_break({player1, cards1}, {player2, cards2}) do
    {card1, card2} = Enum.zip(cards1, cards2)
    |> Enum.find(fn({c1, c2}) -> Card.rank(c1) != Card.rank(c2) end)

    if Deck.compare(card1, card2) do
      {:winner, player1}
    else
      {:winner, player2}
    end
  end
end
