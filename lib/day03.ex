defmodule Day03 do
  @moduledoc """
  --- Day 3: Toboggan Trajectory ---
  """

  @doc """
  --- Part One ---

  Toboggan Trajectory

  You start on the open square (.) in the top-left corner and need to reach the bottom (below the bottom-most row on your map).

  The toboggan can only follow a few specific slopes (you opted for a cheaper model that prefers rational numbers);
  start by counting all the trees you would encounter for the slope right 3, down 1:

  From your starting position at the top-left, check the position that is right 3 and down 1.
  Then, check the position that is right 3 and down 1 from there, and so on until you go past the bottom of the map.

  The locations you'd check in the above example are marked here with O where there was an open square and X where there was a tree:

  ..##.........##.........##.........##.........##.........##.......  --->
  #..O#...#..#...#...#..#...#...#..#...#...#..#...#...#..#...#...#..
  .#....X..#..#....#..#..#....#..#..#....#..#..#....#..#..#....#..#.
  ..#.#...#O#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#..#.#...#.#
  .#...##..#..X...##..#..#...##..#..#...##..#..#...##..#..#...##..#.
  ..#.##.......#.X#.......#.##.......#.##.......#.##.......#.##.....  --->
  .#.#.#....#.#.#.#.O..#.#.#.#....#.#.#.#....#.#.#.#....#.#.#.#....#
  .#........#.#........X.#........#.#........#.#........#.#........#
  #.##...#...#.##...#...#.X#...#...#.##...#...#.##...#...#.##...#...
  #...##....##...##....##...#X....##...##....##...##....##...##....#
  .#..#...#.#.#..#...#.#.#..#...X.#.#..#...#.#.#..#...#.#.#..#...#.#  --->
  In this example, traversing the map using this slope would cause you to encounter 7 trees.

  Starting at the top-left corner of your map and following a slope of right 3 and down 1, how many trees would you encounter?
  """
  def trees_encountered_r3d1 do
    get_tree_lines()
    |> count_trees(3, 1)
  end

  @doc """
  --- Part Two ---

  Time to check the rest of the slopes - you need to minimize the probability of a sudden arboreal stop, after all.

  Determine the number of trees you would encounter if, for each of the following slopes, you start at the top-left corner and traverse the map all the way to the bottom:

  Right 1, down 1.
  Right 3, down 1. (This is the slope you already checked.)
  Right 5, down 1.
  Right 7, down 1.
  Right 1, down 2.
  In the above example, these slopes would find 2, 7, 3, 4, and 2 tree(s) respectively; multiplied together, these produce the answer 336.

  What do you get if you multiply together the number of trees encountered on each of the listed slopes?
  """
  def trees_encountered_multiple_slopes do
    tree_lines = get_tree_lines()
    trees1 = count_trees(tree_lines, 1, 1)
    trees2 = count_trees(tree_lines, 3, 1)
    trees3 = count_trees(tree_lines, 5, 1)
    trees4 = count_trees(tree_lines, 7, 1)
    trees5 = count_trees(tree_lines, 1, 2)
    # result is the product of all tree counts
    trees1 * trees2 * trees3 * trees4 * trees5
  end

  defp count_trees(tree_lines, slope_right, slope_down) do
    count_trees(tree_lines, slope_right, slope_down, 0, 0, 0)
  end

  defp count_trees([], _slope_right, _slope_down, _right_pos, _down_pos, tree_count),
    do: tree_count

  defp count_trees(tree_lines, slope_right, slope_down, right_pos, down_pos, tree_count) do
    next_right_pos = right_pos + slope_right
    next_down_pos = down_pos + slope_down

    case Enum.at(tree_lines, next_down_pos) do
      # At the bottom of the slope, no more trees to count,
      nil ->
        tree_count

      # Check out the next tree line
      tree_line ->
        if tree_encountered?(tree_line, next_right_pos) do
          count_trees(
            tree_lines,
            slope_right,
            slope_down,
            next_right_pos,
            next_down_pos,
            tree_count + 1
          )
        else
          count_trees(
            tree_lines,
            slope_right,
            slope_down,
            next_right_pos,
            next_down_pos,
            tree_count
          )
        end
    end
  end

  defp tree_encountered?(tree_line, right_pos) do
    case String.at(tree_line, right_pos) do
      # tree line not long enough, extend it and try again
      nil -> tree_encountered?(tree_line <> tree_line, right_pos)
      # encountered a tree
      "#" -> true
      # no tree
      _ -> false
    end
  end

  defp get_tree_lines do
    File.read!("day03_input.txt") |> String.split()
  end
end
