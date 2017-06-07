defmodule Heightmap.Grid do
  @typedoc """
  A rectangular grid of integers
  """
  @type cell :: integer
  @type t :: list(list(cell))

  @doc ~S"""
  Creates a grid with the given dimensions, with all pixels initialized to 0

  ## Examples

      iex> new(1, 1)
      [[0]]

      iex> new(2, 2)
      [[0, 0], [0, 0]]
  """
  @spec new(integer, integer) :: t
  def new(w, h, opts \\ []) do
    for _x <- 1..w do
      for _y <- 1..h do
        initialize_value(opts[:initial])
      end
    end
  end

  @doc ~S"""
  Initializes a value for a grid cell, based on a given strategy

  ## Examples

      iex> initialize_value(nil)
      0

      iex> initialize_value(2)
      2

      initialize_value(:random)
      _n
  """
  @spec initialize_value(integer | :random | nil) :: integer
  def initialize_value(nil), do: 0
  def initialize_value(:random), do: :rand.uniform(255)
  def initialize_value(n), do: n

  @doc ~S"""
  Number of rows in the grid

  ## Examples

      iex> new(2, 1) |> width
      2

      iex> new(3, 1) |> width
      3
  """
  @spec width(t) :: integer
  def width(grid), do: length(grid)

  @doc ~S"""
  Number of columns in the grid

  ## Examples

      iex> new(2, 1) |> height
      1

      iex> new(2, 2) |> height
      2
  """
  @spec width(t) :: integer
  def height([column | _rest]), do: length(column)

  @doc ~S"""
  Total number of pixels

  ## Examples

      iex> new(2, 1) |> pixel_count
      2

      iex> new(2, 2) |> pixel_count
      4
  """
  @spec pixel_count(t) :: integer
  def pixel_count(grid), do: width(grid) * height(grid)

  @doc ~S"""
  Gets the value of a given pixel

      iex> new(2, 2) |> get(1, 1)
      0
  """
  @spec get(t, integer, integer) :: cell
  def get(grid, x, y) do
    grid
    |> Enum.at(x)
    |> Enum.at(y)
  end
  def get(grid, {x, y}), do: get(grid, x, y)

  @doc ~S"""
  Sets the pixel in a given coordinate to the given value

  ## Examples

      iex> new(2, 2) |> set(1, 1, 2)
      [[0, 0], [0, 2]]

      iex> new(2, 3) |> set(0, 2, 2)
      [[0, 0, 2], [0, 0, 0]]
  """
  @spec set(t, integer, integer, cell) :: t
  def set(grid, x, y, value) do
    column = Enum.at(grid, x)
    new_column = List.replace_at(column, y, value)
    List.replace_at(grid, x, new_column)
  end
  def set(grid, {x, y}, value), do: set(grid, x, y, value)

  @doc ~S"""
  Find the largest value in the grid

  ## Examples

      iex> new(2, 3) |> set(0, 2, 2) |> max
      2
  """
  @spec max(t) :: cell
  def max(grid) do
    grid
    |> Enum.map(&Enum.max/1)
    |> Enum.max
  end
end
