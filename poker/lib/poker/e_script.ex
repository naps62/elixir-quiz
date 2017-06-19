defmodule Poker.EScript do
  def main(_args) do
    round = Poker.Round.new([:player, :computer])

    IO.puts "Your hand:"
    show_player_hand(round)
  end

  defp show_player_hand({%{player: player_hand}, _}) do
    player_hand
    |> to_string
    |> IO.inspect
  end
end

defimpl String.Chars, for: Poker.Hand do
  def to_string(%Poker.Hand{cards: cards}) do
    cards
    |> Enum.reduce("", fn({rank, suite}, accum) ->
      accum <> "   " <> "#{rank} of #{suite}" <> "\n"
    end)
    |> IO.puts
  end
end
