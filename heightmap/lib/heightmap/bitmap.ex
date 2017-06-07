defmodule Heightmap.Bitmap do
  alias Heightmap.Grid

  def write_bitmap(grid, file) do
    {:ok, file} = File.open(file, [:write])

    body = body(grid)

    IO.binwrite(file, header(grid, body) <> body)
  end

  def header(grid, body) do
    <<
      "BM",
      file_size(body) :: little-size(32), # little-size of file, including header, pixels and padding
      0 :: little-size(32), # reserved
      54 :: little-size(32), # bytes until the actual pixel data
      40 :: little-size(32), # BITMAPINFOHEAADER
      Grid.width(grid) :: little-size(32), # image width
      Grid.height(grid) :: little-size(32), # image height
      1  :: little-size(16), # number of color planes
      24 :: little-size(16), # bits per pixel
      0  :: little-size(32), # disable compression
      data_size(body) :: little-size(32), # raw data little-size, including padding
      horizontal_resolution(grid) :: little-size(32),
      vertical_resolution(grid) :: little-size(32),
      0 :: little-size(32), # number of colors. 0 means all colors
      0 :: little-size(32), # important colors. 0 means all colors
    >>
  end

  defp file_size(body) do
    54 + data_size(body)
  end

  defp data_size(body) do
    byte_size(body)
  end

  defp horizontal_resolution(_grid) do
    2835
  end

  defp vertical_resolution(_grid) do
    2835
  end

  def body(grid) do
    grid
    |> Enum.map(fn(row) ->
      padding_size = round(Float.ceil(length(row) / 4) * 4) - length(row)

      row
      |> Enum.map(&pixel/1)
      |> Enum.concat(List.duplicate(<<0>>, padding_size))
      |> Enum.join
    end)
    |> Enum.reverse
    |> Enum.join
  end

  def pixel(v) do
    with rounded_v <- round(v) do
      <<rounded_v, rounded_v, rounded_v>>
    end
  end
end
