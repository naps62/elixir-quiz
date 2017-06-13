defmodule Poker.AI do
  @moduledoc """
  AI module.

  Analyzes a poker hand and decides which cards to discard and which ones to keep
  """

  alias Poker.{Card, Hand, HandResult}

  @type t :: %{discard: list(Card.t), keep: list(Card.t)}

  @doc ~S"""
  Decides which cards to discard from a hand

  ## Examples:

      Should keep a straight flush
      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.AI.discard(hand)
      %{keep: [{:ace, :spades}, {:king, :spades}, {:queen, :spades}, {:jack, :spades}, {10, :spades}], discard: []}

      Should keep a full house
      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.AI.discard(hand)
      %{keep: [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:jack, :diamonds}, {:jack, :hearts}], discard: []}

      With two pairs, should drop the remaining card
      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(2, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.AI.discard(hand)
      %{keep: [{:ace, :spades}, {:ace, :hearts}, {:jack, :diamonds}, {:jack, :hearts}], discard: [{2, :clubs}]}

      With a 3-of-a-kind, should drop the lowest remaining card
      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:queen, :hearts), Card.new(:jack, :diamonds)]
      iex> Poker.AI.discard(hand)
      %{keep: [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:queen, :hearts}], discard: [{:jack, :diamonds}]}

      With a pair, should drop the 2 lowest remaining cards
      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(8, :hearts), Card.new(3, :diamonds), Card.new(2, :clubs)]
      iex> Poker.AI.discard(hand)
      %{keep: [{:ace, :spades}, {:ace, :hearts}, {8, :hearts}], discard: [{3, :diamonds}, {2, :clubs}]}
  """
  @spec discard(Hand.t) :: t
  def discard(hand) do
    result = HandResult.value(hand)
    cards = Hand.cards(hand)

    analyze(cards, result)
  end

  # keep whole hand if it's a straight flush, flush or full house
  @spec analyze(list(Card.t), HandResult.t) :: t
  defp analyze(cards, %HandResult{result: result}) when
    result == :straight_flush or
      result == :full_house or
      result == :flush or
      result == :straight, do:
    %{discard: [], keep: cards}

  # for a 4-of-a-kind, two pairs, or 3-of-a-kind, drop the lowest of the remaining cards
  defp analyze(cards, %HandResult{result: result} = hand_result) when
    result == :four_of_a_kind or
      result == :two_pair or
      result == :three_of_a_kind
  do
    discard_remaining(cards, hand_result, 1)
  end

  defp analyze(cards, %HandResult{result: result} = hand_result) when
    result == :one_pair
  do
    discard_remaining(cards, hand_result, 2)
  end

  @spec discard_remaining(list(Card.t), HandResult.t, integer) :: t
  defp discard_remaining(cards, %HandResult{cards: result_cards}, count) do
    discardable_cards = Enum.reject(cards, &Enum.member?(result_cards, &1))

    cards_ordered_by_result = result_cards ++ discardable_cards

    discard = Enum.take(cards_ordered_by_result, -count)
    keep = Enum.drop(cards_ordered_by_result, -count)

    %{keep: keep, discard: discard}
  end
end
