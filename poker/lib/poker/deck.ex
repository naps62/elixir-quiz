defmodule Poker.Deck do
  alias Poker.Card

  @type t :: list(Card.t)

  @suites [:hearts, :spades, :diamonds, :clubs]
  @ranks [:ace, :king, :queen, :jack] ++ Enum.to_list(10..2)

  @deck (for suite <- @suites, rank <- @ranks do
    {rank, suite}
  end)

  @doc """
  Returns a new shuffled deck of cards
  """
  @spec new() :: t
  def new do
    @deck
    |> Enum.shuffle
  end

  @doc ~S"""
  Takes the top card of the deck
  """
  @spec take(t) :: {:ok, Card.t, t} | {:error, String.t}
  def take([]), do: {:error, "deck is empty"}
  def take([h | t]), do: {:ok, h, t}

  @doc """
  Compares two cards by their rank. to be used for sorting

  ## Examples

      iex> Poker.Deck.compare({:ace, :spades}, {:king, :spades})
      true

      iex> Poker.Deck.compare({:queen, :hearts}, {:queen, :diamonds})
      true

      iex> Poker.Deck.compare({3, :clubs}, {5, :hearts})
      false
  """
  @spec compare(Card.t, Card.t) :: boolean
  def compare({r1, _}, {r2, _}) do
    ia = Enum.find_index(@ranks, &(r1 == &1))
    ib = Enum.find_index(@ranks, &(r2 == &1))

    ia <= ib
  end

  @doc """
  Sorts a list of cards
  """
  @spec sort_cards(list(Card.t)) :: list(Card.t)
  def sort_cards(cards) do
    cards |> Enum.sort(&compare/2)
  end

  @doc ~S"""
  Checks if a card is next to another in a descending sequence

  Accounts for the fact that Aces can be considered both the top and bottom of a sequence

  ## Examples

      iex> alias Poker.Card
      iex> Poker.Deck.cards_in_sequence?([Card.new(:ace, :spades), Card.new(:king, :spades)])
      true

      iex> alias Poker.Card
      iex> Poker.Deck.cards_in_sequence?([Card.new(10, :diamonds), Card.new(9, :clubs)])
      true

      iex> alias Poker.Card
      iex> Poker.Deck.cards_in_sequence?([Card.new(2, :spades), Card.new(:ace, :hearts)])
      true

      iex> alias Poker.Card
      iex> Poker.Deck.cards_in_sequence?([Card.new(10, :spades), Card.new(2, :spades)])
      false

      iex> alias Poker.Card
      iex> Poker.Deck.cards_in_sequence?([Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)])
      true
  """
  @spec cards_in_sequence?(list(Card.t)) :: boolean
  def cards_in_sequence?([]), do: true
  def cards_in_sequence?([_card]), do: true
  def cards_in_sequence?([{:ace, _}, {:king, _} = c2 | t]), do:
    cards_in_sequence?([c2 | t])
  def cards_in_sequence?([{2, _}, {:ace, _} = c2 | t]), do:
    cards_in_sequence?([c2 | t])
  def cards_in_sequence?([{r1, _}, {r2, _} = c2 | t]) do
    i1 = Enum.find_index(@ranks, &(r1 == &1))
    i2 = Enum.find_index(@ranks, &(r2 == &1))

    (i2 == i1 + 1) and cards_in_sequence?([c2 | t])
  end
  def cards_in_sequence?(_), do: false

  def rank_index({rank, _}) do
    Enum.find_index(@ranks, &(rank == &1))
  end
end
