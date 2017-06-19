defmodule Poker.Hand do
  defstruct cards: []

  @moduledoc ~S"""
  Models a poker hand.

  Cards within a hand are always guaranteed to be sorted
  """

  alias Poker.{Card, Deck, HandResult}

  @type t :: %__MODULE__{cards: list(Card.t)}

  @doc ~S"""
  Creates a new poker hand
  """
  def new(), do: %__MODULE__{cards: []}

  @doc ~S"""
  Deals a new card to a hand

  ## Examples

      iex> card = Poker.Card.new(:ace, :spades)
      iex> hand = Poker.Hand.new()
      iex> Poker.Hand.deal(hand, card)
      [{:ace, :spades}]
  """
  @spec deal(t, Card.t) :: t
  def deal(%__MODULE__{cards: cards} = hand, card), do:
    %__MODULE__{hand | cards: Deck.sort_cards([card | cards])}

  @doc ~S"""
  Calculates a named value for the hand
  """
  @spec value(t) :: atom
  def value(hand) do
    HandResult.value(hand)
  end

  @doc ~S"""
  Returns the list of cards for a hand
  """
  @spec cards(t) :: list(Card.t)
  def cards(hand), do: hand
end
