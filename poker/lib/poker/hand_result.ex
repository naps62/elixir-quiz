defmodule Poker.HandResult do
  alias Poker.{Card, Hand, Deck}

  defstruct result: nil, cards:  nil

  @type t :: %__MODULE__{result: atom, cards: list(Card.t)} | nil

  @results Enum.reverse(~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pair one_pair high_card)a)

  @moduledoc ~S"""
  Handles the calculation of the value of a poker hand
  """

  @values ~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pair one_pair high_card)a

  @doc ~S"""
  Calculates the result of a hand
  """
  @spec value(Hand.t) :: t
  def value(hand) do
    @values
    |> Enum.find_value(fn(value) ->
      apply(__MODULE__, value, [hand])
    end)
  end

  @doc ~S"""
  Calculates a numerical value for the hand, based on it's result name
  """
  @spec numerical_value(t) :: integer
  def numerical_value(%__MODULE__{result: result}), do:
    Enum.find_index(@values, &(&1 == result))
  def numerical_value(hand), do:
    hand |> value |> numerical_value

  @doc ~S"""
  Gives the numerical value of a given result. For example, a high_card has the relative value 0, and a one_pair has a value of 1, being the next best thing to a high_card

  ## Examples

      iex> Poker.HandResult.numerical_value({:high_card, []})
      0

      iex> Poker.HandResult.numerical_value({:straight_flush, []})
      8
  """
  @spec numerical_value(t) :: integer
  def numerical_value({result, _cards}), do:
    @results
    |> Enum.find_index(fn(possible_result) -> possible_result == result end)

  @doc ~S"""
  Checks if a hand is a straight flush

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.straight_flush(hand)
      %Poker.HandResult{result: :straight_flush, cards: [{:ace, :spades}, {:king, :spades}, {:queen, :spades}, {:jack, :spades}, {10, :spades}]}
  """
  @spec straight_flush(Hand.t) :: t
  def straight_flush(hand) do
    if suit_count(hand) == 1 and Deck.cards_in_sequence?(Hand.cards(hand)) do
      %__MODULE__{result: :straight_flush, cards: Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Four of a Kind

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:ace, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.four_of_a_kind(hand)
      %Poker.HandResult{result: :four_of_a_kind, cards: [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:ace, :diamonds}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.four_of_a_kind(hand)
      nil
  """
  @spec four_of_a_kind(Hand.t) :: t
  def four_of_a_kind(hand) do
    if rank_counts(hand) == [4, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      four_cards = cards_by_rank(hand) |> Enum.at(0) |> elem(1)

      %__MODULE__{result: :four_of_a_kind, cards: four_cards}
    end
  end

  @doc ~S"""
  Checks if a hand is a Full House

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.full_house(hand)
      %Poker.HandResult{result: :full_house, cards: [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:jack, :diamonds}, {:jack, :hearts}]}
  """
  @spec full_house(Hand.t) :: t
  def full_house(hand) do
    if rank_counts(hand) == [3, 2] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      %__MODULE__{result: :full_house, cards: Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Flush

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(5, :spades), Card.new(2, :spades)]
      iex> Poker.HandResult.flush(hand)
      %Poker.HandResult{result: :flush, cards: [{:ace, :spades}, {:king, :spades}, {:queen, :spades}, {5, :spades}, {2, :spades}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.flush(hand)
      nil
  """
  @spec flush(Hand.t) :: t
  def flush(hand) do
    if suit_count(hand) == 1 and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      %__MODULE__{result: :flush, cards: Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Straight

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :diamonds), Card.new(:queen, :clubs), Card.new(:jack, :hearts), Card.new(10, :spades)]
      iex> Poker.HandResult.straight(hand)
      %Poker.HandResult{result: :straight, cards: [{:ace, :spades}, {:king, :diamonds}, {:queen, :clubs}, {:jack, :hearts}, {10, :spades}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.straight(hand)
      nil
  """
  @spec straight(Hand.t) :: t
  def straight(hand) do
    if suit_count(hand) > 1 and Deck.cards_in_sequence?(Hand.cards(hand)) do
      %__MODULE__{result: :straight, cards: Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Three of a Kind

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:jack, :diamonds), Card.new(:queen, :hearts)]
      iex> Poker.HandResult.three_of_a_kind(hand)
      %Poker.HandResult{result: :three_of_a_kind, cards: [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}]}
  """
  @spec three_of_a_kind(Hand.t) :: t
  def three_of_a_kind(hand) do
    if rank_counts(hand) == [3, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) and suit_count(hand) > 1 do
      three_cards = cards_by_rank(hand) |> Enum.at(0) |> elem(1)

      %__MODULE__{result: :three_of_a_kind, cards: three_cards}
    end
  end

  @doc ~S"""
  Checks if a hand is a Two Pair

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(2, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.two_pair(hand)
      %Poker.HandResult{result: :two_pair, cards: [{:jack, :diamonds}, {:jack, :hearts}, {:ace, :spades}, {:ace, :hearts}]}
  """
  @spec two_pair(Hand.t) :: t
  def two_pair(hand) do
    if rank_counts(hand) == [2, 2, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      first_pair = cards_by_rank(hand) |> Enum.at(0) |> elem(1)
      second_pair = cards_by_rank(hand) |> Enum.at(1) |> elem(1)

      %__MODULE__{result: :two_pair, cards: first_pair ++ second_pair}
    end
  end

  @doc ~S"""
  Checks if a hand is a One Pair

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(2, :clubs), Card.new(3, :diamonds), Card.new(8, :hearts)]
      iex> Poker.HandResult.one_pair(hand)
      %Poker.HandResult{result: :pair, cards: [{:ace, :spades}, {:ace, :hearts}, {8, :hearts}, {3, :diamonds}, {2, :clubs}]}
  """
  @spec one_pair(Hand.t) :: boolean
  def one_pair(hand) do
    if rank_counts(hand) == [2, 1, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      pair_and_rest = cards_by_rank(hand) |> Enum.map(&elem(&1, 1)) |> Enum.concat

      %__MODULE__{result: :pair, cards: pair_and_rest}
    end
  end

  @doc ~S"""
  Checks if a hand is a High Card

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:queen, :diamonds), Card.new(:jack, :hearts), Card.new(8, :spades), Card.new(7, :hearts), Card.new(3, :clubs)]
      iex> Poker.HandResult.high_card(hand)
      %Poker.HandResult{result: :high_card, cards: [{:queen, :diamonds}, {:jack, :hearts}, {8, :spades}, {7, :hearts}, {3, :clubs}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.high_card(hand)
      nil
  """
  @spec high_card(Hand.t) :: boolean
  def high_card(hand) do
    if rank_counts(hand) == [1, 1, 1, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) and suit_count(hand) > 1 do
      %__MODULE__{result: :high_card, cards: Hand.cards(hand)}

    end
  end

  @spec suit_count(Hand.t) :: integer
  defp suit_count(hand) do
    hand
    |> Hand.cards
    |> Enum.map(&Card.suite/1)
    |> Enum.uniq
    |> length
  end

  @spec cards_by_rank(Hand.t) :: list({atom, list(Card.t)})
  defp cards_by_rank(hand) do
    hand
    |> Hand.cards
    |> Enum.group_by(&Card.rank/1)
    |> Enum.sort_by(fn({_rank, cards}) -> length(cards) end)
    |> Enum.reverse
  end

  @spec rank_counts(Hand.t) :: list(integer)
  defp rank_counts(hand) do
    hand
    |> cards_by_rank
    |> Enum.map(fn({_rank, cards}) ->
      length(cards)
    end)
  end

  @spec ranks_in_sequence?(Hand.t) :: boolean
  def ranks_in_sequence?(hand) do
    hand
    |> Hand.cards
    |> Enum.sort_by(&Deck.compare/2)
  end
end
