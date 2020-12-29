defmodule Day23 do
  @moduledoc """
  --- Day 23: Crab Cups ---
  """

  @doc """
  --- Part One ---

  The small crab challenges you to a game! The crab is going to mix up some cups,
  and you have to predict where they'll end up.

  The cups will be arranged in a circle and labeled clockwise (your puzzle input).
  For example, if your labeling were 32415, there would be five cups in the circle;
  going clockwise around the circle from the first cup, the cups would be labeled 3, 2, 4, 1, 5, and then back to 3 again.

  Before the crab starts, it will designate the first cup in your list as the current cup.
  The crab is then going to do 100 moves.

  Each move, the crab does the following actions:

  - The crab picks up the three cups that are immediately clockwise of the current cup.
    They are removed from the circle; cup spacing is adjusted as necessary to maintain the circle.

  - The crab selects a destination cup: the cup with a label equal to the current cup's label minus one.
    If this would select one of the cups that was just picked up, the crab will keep subtracting one
    until it finds a cup that wasn't just picked up.
    If at any point in this process the value goes below the lowest value on any cup's label,
    it wraps around to the highest value on any cup's label instead.

  - The crab places the cups it just picked up so that they are immediately clockwise of the destination cup.
    They keep the same order as when they were picked up.

  - The crab selects a new current cup: the cup which is immediately clockwise of the current cup.

  For example, suppose your cup labeling were 389125467.
  If the crab were to do merely 10 moves, the following changes would occur:

  -- move 1 --
  cups: (3) 8  9  1  2  5  4  6  7
  pick up: 8, 9, 1
  destination: 2

  -- move 2 --
  cups:  3 (2) 8  9  1  5  4  6  7
  pick up: 8, 9, 1
  destination: 7

  -- move 3 --
  cups:  3  2 (5) 4  6  7  8  9  1
  pick up: 4, 6, 7
  destination: 3

  -- move 4 --
  cups:  7  2  5 (8) 9  1  3  4  6
  pick up: 9, 1, 3
  destination: 7

  -- move 5 --
  cups:  3  2  5  8 (4) 6  7  9  1
  pick up: 6, 7, 9
  destination: 3

  -- move 6 --
  cups:  9  2  5  8  4 (1) 3  6  7
  pick up: 3, 6, 7
  destination: 9

  -- move 7 --
  cups:  7  2  5  8  4  1 (9) 3  6
  pick up: 3, 6, 7
  destination: 8

  -- move 8 --
  cups:  8  3  6  7  4  1  9 (2) 5
  pick up: 5, 8, 3
  destination: 1

  -- move 9 --
  cups:  7  4  1  5  8  3  9  2 (6)
  pick up: 7, 4, 1
  destination: 5

  -- move 10 --
  cups: (5) 7  4  1  8  3  9  2  6
  pick up: 7, 4, 1
  destination: 3

  -- final --
  cups:  5 (8) 3  7  4  1  9  2  6

  In the above example, the cups' values are the labels as they appear moving clockwise around the circle;
  the current cup is marked with ( ).

  After the crab is done, what order will the cups be in?
  Starting after the cup labeled 1, collect the other cups' labels clockwise
  into a single string with no extra characters;
  each number except 1 should appear exactly once. In the above example, after 10 moves,
  the cups clockwise from 1 are labeled 9, 2, 6, 5, and so on, producing 92658374.
  If the crab were to complete all 100 moves, the order after cup 1 would be 67384529.

  Using your labeling, simulate 100 moves. What are the labels on the cups after cup 1?

  Your puzzle input is 186524973.
  """

  def cup_labels_1 do
    # "389125467")
    get_cups()
    |> move(100)
    |> format_result()
  end

  defp move(cups, 0), do: cups

  defp move(cups, move) do
    #IO.puts("#{move}: #{inspect(cups)}")
    curr_cup = hd(cups)
    {removed_cups, rem_cups} = Enum.split(tl(cups), 3)

    index = find_dest_cup(rem_cups, curr_cup - 1)
    {before_dest, after_dest} = Enum.split(rem_cups, index + 1)

    next_cups = before_dest ++ removed_cups ++ after_dest ++ [curr_cup]
    move(next_cups, move - 1)
  end

  defp find_dest_cup(rem_cups, dest_cup) do
    if dest_cup < Enum.min(rem_cups) do
      max_cup = Enum.max(rem_cups)
      Enum.find_index(rem_cups, &(&1 == max_cup))
    else
      case Enum.find_index(rem_cups, &(&1 == dest_cup)) do
        nil -> find_dest_cup(rem_cups, dest_cup - 1)
        index -> index
      end
    end
  end

  defp format_result(cups) do
    index_1 = Enum.find_index(cups, &(&1 == 1))
    {before_1, after_1} = Enum.split(cups, index_1)

    (tl(after_1) ++ before_1)
    |> Enum.map(&(&1 + ?0))
    |> List.to_string()
  end

  @doc """
  --- Part Two ---

  Due to what you can only assume is a mistranslation (you're not exactly fluent in Crab),
  you are quite surprised when the crab starts arranging many cups in a circle on your raft
   - one million (1000000) in total.

  Your labeling is still correct for the first few cups; after that,
  the remaining cups are just numbered in an increasing fashion
  starting from the number after the highest number in your list
  and proceeding one by one until one million is reached.
  (For example, if your labeling were 54321, the cups would be numbered 5, 4, 3, 2, 1,
  and then start counting up from 6 until one million is reached.)
  In this way, every number from one through one million is used exactly once.

  After discovering where you made the mistake in translating Crab Numbers,
  you realize the small crab isn't going to do merely 100 moves;
  the crab is going to do ten million (10000000) moves!

  The crab is going to hide your stars - one each - under the two cups that will end up immediately clockwise of cup 1.
  You can have them if you predict what the labels on those cups will be when the crab is finished.

  In the above example (389125467), this would be 934001 and then 159792; multiplying these together produces 149245887792.

  Determine which two cups will end up immediately clockwise of cup 1. What do you get if you multiply their labels together?
  """

  # Borrowed idea for representing cups with a Map from thth: https://github.com/thth/aoc_2020/blob/master/23.exs
  # Takes about a minute to run

  def cup_labels_2 do
    # "389125467")
    cups = get_1million_cups()
    cups = m_move(cups, cups[0], 10_000_000)
    # get the two cups to the right of cup 1
    star_cup1 = cups[1]
    star_cup2 = cups[star_cup1]
    star_cup1 * star_cup2
  end

  defp m_move(cups, _curr_cup, 0), do: cups

  defp m_move(cups, curr_cup, moves) do
    if rem(moves, 1_000_000) == 0 do
      IO.puts("#{moves}")
    end

    # remove the three cups to the right of the current cup
    remv1 = cups[curr_cup]
    remv2 = cups[remv1]
    remv3 = cups[remv2]
    next_curr_cup = cups[remv3]
    cups = Map.put(cups, curr_cup, next_curr_cup)
    dest_cup = get_dest_cup(cups, curr_cup - 1, [remv1, remv2, remv3])
    # move the removed cups to after the destination cup
    after_dest_cup = cups[dest_cup]
    cups = Map.put(cups, dest_cup, remv1)
    cups = Map.put(cups, remv3, after_dest_cup)
    m_move(cups, next_curr_cup, moves - 1)
  end

  defp get_dest_cup(cups, dest_cup, remv_cups) do
    if dest_cup > 0 do
      if Enum.member?(remv_cups, dest_cup) do
        get_dest_cup(cups, dest_cup - 1, remv_cups)
      else
        dest_cup
      end
    else
      get_dest_cup(cups, 1_000_000, remv_cups)
    end
  end

  # Common functions

  defp get_cups(input \\ "186524973") do
    input
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
  end

  defp get_1million_cups(input \\ "186524973") do
    # Model circle of cups with map,
    # key is cup label, value is cup to the right
    {_last, cups} =
      input
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))
      |> Enum.concat(Enum.to_list(10..1_000_000))
      |> Enum.reduce({0, %{}}, fn next, {last, cup_map} ->
        {next, Map.put(cup_map, last, next)}
      end)

    # Complete the circle
    Map.put(cups, 1_000_000, cups[0])
    #  cups[0] is the starting cup, but there is no cup labled 0
  end
end
