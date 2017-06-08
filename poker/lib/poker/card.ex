defmodule Poker.Card do
  @type t :: {rank, suite}

  @type rank :: atom | integer
  @type suite :: atom
  @type card :: {rank, suite}

  @doc """
  Creates a new card
  """
  @spec new(rank, suite) :: card
  def new(rank, suite), do: {rank, suite}

  @doc ~S"""
  Returns the rank of a given card

  ## Examples

      iex> card = Poker.Card.new(:ace, :spades)
      iex> Poker.Card.rank(card)
      :ace
  """
  @spec rank(card) :: rank
  def rank({rank, _}), do: rank

  @doc ~S"""
  Returns the suite of a given card

  ## Examples

      iex> card = Poker.Card.new(:ace, :spades)
      iex> Poker.Card.suite(card)
      :spades
  """
  @spec suite(card) :: suite
  def suite({_, suite}), do: suite
end
