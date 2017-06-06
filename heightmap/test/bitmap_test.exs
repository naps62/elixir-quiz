defmodule BitmapTest do
  use ExUnit.Case
  doctest Bitmap

  alias Heightmap.Bitmap

  test "header" do
    assert Bitmap.header()
  end
end
