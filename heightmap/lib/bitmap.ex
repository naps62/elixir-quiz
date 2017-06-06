defmodule Heightmap.Bitmap do
  def write_bitmap(file, grid: grid) do
    {:ok, file} = File.open(file, :write)

    IO.binwrite(file, header())
  end

  defp header do
    <<
      0x42, # ASCII for B
      0x4D, # ASCII for M
      0 :: size(4 * 8), # size of file, including header, pixels and padding
      0 :: size(4 * 8), # reserved
      54 :: size(4 * 8), # bytes until the actual pixel data
      40 :: size(4 * 8), # BITMAPINFOHEAADER
      50 :: size(4 * 8), # image width
      50 :: size(4 * 8), # image height
      1  :: size(2 * 8), # number of color planes
      24 :: size(2 * 8), # bits per pixel
      0  :: size(4 * 8), # disable compression
      
      
    >>
  end
end
