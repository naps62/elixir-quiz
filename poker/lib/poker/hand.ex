defmodule Poker.Hand do
  @moduledoc ~S"""
  Models a poker hand.

  Cards within a hand are always guaranteed to be sorted
  """

  alias Poker.{Card, Deck, HandResult}

  @type t :: list(Card.t)

  @values ~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pair high_card)a

  @doc ~S"""
  Creates a new poker hand
  """
  def new(), do: []

  @doc ~S"""
  Deals a new card to a hand

  ## Examples

      iex> card = Poker.Card.new(:ace, :spades)
      iex> hand = Poker.Hand.new()
      iex> Poker.Hand.deal(hand, card)
      [{:ace, :spades}]
  """
  @spec deal(t, Card.t) :: t
  def deal(hand, card), do: Deck.sort_cards([card | hand])

  @doc ~S"""
  Calculates a numerical value for the hand, based on it's result name

  The higher the number, the more valuable the hand is
  """
  @spec numerical_value(t) :: integer
  def numerical_value(hand) do
    named_value = value(hand)

    Enum.find_index(@values, &(&1 == named_value))
  end

  @doc ~S"""
  Calculates a named value for the hand
  """
  @spec value(t) :: atom
  def value(hand) do
    HandResult.calculate(hand)
  end

  @doc ~S"""
  Returns the list of cards for a hand
  """
  @spec cards(t) :: list(Card.t)
  def cards(hand), do: hand
end
