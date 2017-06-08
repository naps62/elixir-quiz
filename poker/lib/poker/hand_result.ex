defmodule Poker.HandResult do
  alias Poker.{Card, Hand, Deck}

  @type t :: {atom, list(Card.t)} | nil

  @results Enum.reverse(~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pair one_pair high_card)a)

  @moduledoc ~S"""
  Handles the calculation of the value of a poker hand
  """

  # @values ~w(straight_flush four_of_a_kind full_house flush straight three_of_a_kind two_pair high_card)a

  @doc ~S"""
  Calculates the result of a hand
  """
  @spec calculate(Hand.t) :: t
  def calculate(hand) do
    straight_flush(hand) or
      four_of_a_kind(hand) or
      full_house(hand) or
      flush(hand) or
      straight(hand) or
      three_of_a_kind(hand) or
      two_pair(hand) or
      one_pair(hand) or
      high_card(hand)
  end

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
      {:straight_flush, [{:ace, :spades}, {:king, :spades}, {:queen, :spades}, {:jack, :spades}, {10, :spades}]}
  """
  @spec straight_flush(Card.t) :: t
  def straight_flush(hand) do
    if suit_count(hand) == 1 and Deck.cards_in_sequence?(Hand.cards(hand)) do
      {:straight_flush, Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Four of a Kind

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:ace, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.four_of_a_kind(hand)
      {:four_of_a_kind, [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:ace, :diamonds}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.four_of_a_kind(hand)
      nil
  """
  @spec four_of_a_kind(Card.t) :: t
  def four_of_a_kind(hand) do
    if rank_counts(hand) == [4, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      four_cards = cards_by_rank(hand) |> Enum.at(0) |> elem(1)

      {:four_of_a_kind, four_cards}
    end
  end

  @doc ~S"""
  Checks if a hand is a Full House

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.full_house(hand)
      {:full_house, [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}, {:jack, :diamonds}, {:jack, :hearts}]}
  """
  @spec full_house(Card.t) :: t
  def full_house(hand) do
    if rank_counts(hand) == [3, 2] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      {:full_house, Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Flush

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(5, :spades), Card.new(2, :spades)]
      iex> Poker.HandResult.flush(hand)
      {:flush, [{:ace, :spades}, {:king, :spades}, {:queen, :spades}, {5, :spades}, {2, :spades}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.flush(hand)
      nil
  """
  @spec flush(Card.t) :: t
  def flush(hand) do
    if suit_count(hand) == 1 and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      {:flush, Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Straight

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :diamonds), Card.new(:queen, :clubs), Card.new(:jack, :hearts), Card.new(10, :spades)]
      iex> Poker.HandResult.straight(hand)
      {:straight, [{:ace, :spades}, {:king, :diamonds}, {:queen, :clubs}, {:jack, :hearts}, {10, :spades}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.straight(hand)
      nil
  """
  @spec straight(Card.t) :: t
  def straight(hand) do
    if suit_count(hand) > 1 and Deck.cards_in_sequence?(Hand.cards(hand)) do
      {:straight, Hand.cards(hand)}
    end
  end

  @doc ~S"""
  Checks if a hand is a Three of a Kind

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(:ace, :clubs), Card.new(:jack, :diamonds), Card.new(:queen, :hearts)]
      iex> Poker.HandResult.three_of_a_kind(hand)
      {:three_of_a_kind, [{:ace, :spades}, {:ace, :hearts}, {:ace, :clubs}]}
  """
  @spec three_of_a_kind(Card.t) :: t
  def three_of_a_kind(hand) do
    if rank_counts(hand) == [3, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) and suit_count(hand) > 1 do
      three_cards = cards_by_rank(hand) |> Enum.at(0) |> elem(1)

      {:three_of_a_kind, three_cards}
    end
  end

  @doc ~S"""
  Checks if a hand is a Two Pair

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(2, :clubs), Card.new(:jack, :diamonds), Card.new(:jack, :hearts)]
      iex> Poker.HandResult.two_pair(hand)
      {:two_pair, [{:jack, :diamonds}, {:jack, :hearts}, {:ace, :spades}, {:ace, :hearts}]}
  """
  @spec two_pair(Card.t) :: t
  def two_pair(hand) do
    if rank_counts(hand) == [2, 2, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      first_pair = cards_by_rank(hand) |> Enum.at(0) |> elem(1)
      second_pair = cards_by_rank(hand) |> Enum.at(1) |> elem(1)

      {:two_pair, first_pair ++ second_pair}
    end
  end

  @doc ~S"""
  Checks if a hand is a One Pair

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:ace, :hearts), Card.new(2, :clubs), Card.new(3, :diamonds), Card.new(8, :hearts)]
      iex> Poker.HandResult.one_pair(hand)
      {:pair, [{:ace, :spades}, {:ace, :hearts}, {8, :hearts}, {3, :diamonds}, {2, :clubs}]}
  """
  @spec one_pair(Card.t) :: boolean
  def one_pair(hand) do
    if rank_counts(hand) == [2, 1, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) do
      pair_and_rest = cards_by_rank(hand) |> Enum.map(&elem(&1, 1)) |> Enum.concat

      {:pair, pair_and_rest}
    end
  end

  @doc ~S"""
  Checks if a hand is a High Card

  ## Examples

      iex> alias Poker.Card
      iex> hand = [Card.new(:queen, :diamonds), Card.new(:jack, :hearts), Card.new(8, :spades), Card.new(7, :hearts), Card.new(3, :clubs)]
      iex> Poker.HandResult.high_card(hand)
      {:high_card, [{:queen, :diamonds}, {:jack, :hearts}, {8, :spades}, {7, :hearts}, {3, :clubs}]}

      iex> alias Poker.Card
      iex> hand = [Card.new(:ace, :spades), Card.new(:king, :spades), Card.new(:queen, :spades), Card.new(:jack, :spades), Card.new(10, :spades)]
      iex> Poker.HandResult.high_card(hand)
      nil
  """
  @spec high_card(Card.t) :: boolean
  def high_card(hand) do
    if rank_counts(hand) == [1, 1, 1, 1, 1] and not Deck.cards_in_sequence?(Hand.cards(hand)) and suit_count(hand) > 1 do
      {:high_card, Hand.cards(hand)}
    end
  end

  @spec suit_count(Card.t) :: integer
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

  @spec rank_counts(Card.t) :: list(integer)
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
