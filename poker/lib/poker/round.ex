defmodule Poker.Round do
  alias Poker.{Hand, Deck}

  @type t :: {%{required(atom) => Hand.t}, Deck.t}

  @type player :: atom

  @doc ~S"""
  Deals a new hand of cards to a list of players
  """
  @spec new(list(player)) :: t
  def new(players) do
    deck = Poker.Deck.new
    player_hands = players
                   |> Enum.map(&({&1, Hand.new()}))
                   |> Enum.into(%{})

    deal_hands({player_hands, deck})
  end

  @doc ~S"""
  Deals 5 cards to each player, in a round-robin way
  """
  @spec deal_hands(t) :: t
  def deal_hands(round) do
    Enum.reduce(1..5, round, fn(_, round) -> deal_one_to_hands(round) end)
  end

  @doc ~S"""
  Deals one card from the deck to each player
  """
  @spec deal_one_to_hands(t) :: t
  def deal_one_to_hands({player_hands, _deck} = round) do
    Enum.reduce(player_hands, round, &deal_one_to_single_hand/2)
  end

  @doc ~S"""
  Deals a single card from the deck to the given player
  """
  @spec deal_one_to_single_hand({player, Hand.t}, t) :: t
  def deal_one_to_single_hand({player, hand}, {players, deck}) do
    {:ok, card, new_deck} = Deck.take(deck)

    new_players = %{players | player => Hand.deal(hand, card)}

    {new_players, new_deck}
  end

  @doc ~S"""
  Calculates the winner of a round
  """
  @spec winner(t) :: player
  def winner({players, _}) do
    players
    |> Stream.map(fn({player, hand}) ->
      {player, hand, Poker.Hand.value(hand)}
    end)
    |> Enum.max_by(fn({_player, _hand, value}) ->
      Poker.HandResult.numerical_value(value)
    end)
  end
end
