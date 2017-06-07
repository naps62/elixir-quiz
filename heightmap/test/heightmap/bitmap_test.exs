defmodule Heightmap.BitmapTest do
  use ExUnit.Case
  doctest Heightmap.Bitmap, import: true

  test "generates a proper bitmap header" do
    grid = Heightmap.Grid.new(4, 4)

    assert <<
      "BM",
      size :: little-size(32),
      _reserved :: little-size(32),
      offset_to_pixels :: little-size(32),
      _header_info :: little-size(32),
      width :: little-size(32),
      height :: little-size(32),
      color_planes :: little-size(16),
      bits_per_pixel :: little-size(16),
      0 :: little-size(32),
      data_size :: little-size(32),
      horizontal_res :: little-size(32),
      vertical_res :: little-size(32),
      0 :: little-size(64)
    >> = Heightmap.Bitmap.header(grid, Heightmap.Bitmap.body(grid))

    assert size == data_size + 54
    assert width == 4
    assert height == 4
    assert color_planes == 1
    assert bits_per_pixel == 24
    assert offset_to_pixels == 54
    assert data_size == Heightmap.Grid.pixel_count(grid) * 3
    assert horizontal_res == 2835
    assert vertical_res == 2835
  end

  test "body generates the proper data" do
    grid = Heightmap.Grid.new(2, 2)
           |> Heightmap.Grid.set(1, 1, 100)
           |> Heightmap.Grid.set(0, 0, 50)

    body = Heightmap.Bitmap.body(grid)

    assert body == <<
      0,  0,  0,  100, 100, 100, 0, 0,
      50, 50, 50, 0,   0,   0,   0, 0
    >>
  end

  test "body generates the proper padding" do
    grid = Heightmap.Grid.new(2, 2)

    body = Heightmap.Bitmap.body(grid)

    assert rem(byte_size(body), 4) == 0
  end
end
