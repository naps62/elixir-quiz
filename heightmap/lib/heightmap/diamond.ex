defmodule Heightmap.Diamond do
  @type point :: {integer, integer}
  @type square :: {point, point}

  alias Heightmap.Grid

  @spec generate(integer) :: Grid.t
  def generate(magnitude) do
    size = round(:math.pow(2, magnitude) + 1)

    size
    |> initial_grid
    |> diamond([{{0, 0}, {size - 1, size - 1}}], 32)
    |> scale(255)
  end

  @spec diamond(Grid.t, list(square), number) :: Grid.t
  def diamond(grid, [{{x0, y0}, {x1, y1}} | _tail], _range)
    when x0 + 1 >= x1 and y0 + 1 >= y1, do: grid

  def diamond(grid, squares, range) do
    grid
    |> diamond_step(squares, range)
    |> square_step(squares, range)
    |> diamond(split_squares(squares), range / 2.0)
  end

  def diamond_step(grid, squares, range) do
    Enum.reduce(squares, grid, fn({{x0, y0} = p_top_left, {x1, y1} = p_bottom_right}, grid) ->
      p_center = center_point(p_top_left, p_bottom_right)
      p_top_right = {x0, y1}
      p_bottom_left = {x1, y0}

      average(grid, p_center, [p_top_left, p_top_right, p_bottom_left, p_bottom_right], range)
    end)
  end

  def square_step(grid, squares, range) do
    Enum.reduce(squares, grid, fn({{x0, y0} = p_top_left, {x1, y1} = p_bottom_right}, grid) ->
      p_center = center_point(p_top_left, p_bottom_right)
      p_left = {x0, elem(p_center, 1)}
      p_right = {x1, elem(p_center, 1)}
      p_top = {elem(p_center, 0), y0}
      p_bottom = {elem(p_center, 0), y1}

      p_top_right = {x0, y1}
      p_bottom_left = {x1, y0}

      grid
      |> average(p_top, [p_top_left, p_top_right, p_center], range)
      |> average(p_left, [p_top_left, p_bottom_left, p_center], range)
      |> average(p_right, [p_top_right, p_bottom_right, p_center], range)
      |> average(p_bottom, [p_bottom_left, p_bottom_right, p_center], range)
    end)
  end

  def split_squares(squares) do
    Enum.reduce(squares, [], fn({{x0, y0} = p0, {x1, y1} = p1}, squares) ->
      p_center = center_point(p0, p1)
      p_top = {elem(p_center, 0), y0}
      p_right = {x1, elem(p_center, 1)}
      p_left = {x0, elem(p_center, 1)}
      p_bottom = {elem(p_center, 0), y1}

      [{p0, p_center}, {p_top, p_right}, {p_left, p_bottom}, {p_center, p1} | squares]
    end)
  end

  @spec average(Grid.t, point, list(point), float) :: Grid.t
  def average(grid, destination, points, range) do
    values = Enum.map(points, &(Grid.get(grid, &1)))

    final_value = Enum.reduce(values, 0, &+/2) / length(values) + :rand.uniform() * range

    Grid.set(grid, destination, final_value)
  end

  @spec center_point(point, point) :: point
  def center_point({x0, y0}, {x1, y1}) do
    {div(x1 + x0, 2), div(y1 + y0, 2)}
  end

  @spec initial_grid(integer) :: Grid.t
  def initial_grid(size) do
    Grid.new(size, size, initial: 0)
    |> Grid.set(0, 0, :rand.uniform())
    |> Grid.set(0, size - 1, :rand.uniform())
    |> Grid.set(size - 1, 0, :rand.uniform())
    |> Grid.set(size - 1, size - 1, :rand.uniform())
  end

  def scale(grid, max) do
    current_max = Grid.max(grid)

    scale_factor = max / current_max

    for x <- 0..(Grid.width(grid) - 1) do
      for y <- 0..(Grid.height(grid) - 1) do
        Grid.get(grid, x, y) * scale_factor
      end
    end
  end
end
