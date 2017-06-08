defmodule Poker.Deck do
  @type t :: list(card)
  @type rank :: atom | integer
  @type suite :: atom
  @type card :: {rank, suite}

  @suites [:hearts, :spades, :diamonds, :clubs]
  @ranks [:ace, :king, :queen, :jack] ++ Enum.to_list(10..2)

  @deck {
    for suite <- @suites, rank <- @ranks do
      {rank, suite}
    end
  }

  @doc """
  Returns a new shuffled deck of cards
  """
  @spec new() :: t
  def new do
    @deck
    |> Enum.shuffle
  end

  @doc """
  Compares two cards, returning -1, 0 or 1 based on which is the highest

  ## Examples

      iex> Poker.Deck.compare({:ace, :spades}, {:king, :spades})
      -1

      iex> Poker.Deck.compare({:queen, :hearts}, {:queen, :diamonds})
      0

      iex> Poker.Deck.compare({3, :clubs}, {5, :hearts})
      1
  """
  @spec compare(card, card) :: integer
  def compare({a, _}, {b, _}) do
    ia = Enum.find_index(@ranks, &(&1 == a))
    ib = Enum.find_index(@ranks, &(&1 == b))

    cond do
      ia < ib -> -1
      ia > ib -> 1
      true -> 0
    end
  end
end
