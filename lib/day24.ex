defmodule Day24 do
  @moduledoc """
  --- Day 24: Lobby Layout ---
  """

  @doc """
  --- Part One ---

  Your raft makes it to the tropical island; it turns out that the small crab
  was an excellent navigator. You make your way to the resort.

  As you enter the lobby, you discover a small problem: the floor is being
  renovated. You can't even reach the check-in desk until they've finished
  installing the new tile floor.

  The tiles are all hexagonal; they need to be arranged in a hex grid with a
  very specific color pattern. Not in the mood to wait, you offer to help
  figure out the pattern.

  The tiles are all white on one side and black on the other. They start with
  the white side facing up. The lobby is large enough to fit whatever pattern
  might need to appear there.

  A member of the renovation crew gives you a list of the tiles that need to
  be flipped over (your puzzle input). Each line in the list identifies a
  single tile that needs to be flipped by giving a series of steps starting
  from a reference tile in the very center of the room. (Every line starts
  from the same reference tile.)

  Because the tiles are hexagonal, every tile has six neighbors: east,
  southeast, southwest, west, northwest, and northeast. These directions are
  given in your list, respectively, as e, se, sw, w, nw, and ne. A tile is
  identified by a series of these directions with no delimiters; for example,
  esenee identifies the tile you land on if you start at the reference tile
  and then move one tile east, one tile southeast, one tile northeast, and
  one tile east.

  Each time a tile is identified, it flips from white to black or from black
  to white. Tiles might be flipped more than once. For example, a line like
  esew flips a tile immediately adjacent to the reference tile, and a line
  like nwwswee flips the reference tile itself.

  Here is a larger example:

  sesenwnenenewseeswwswswwnenewsewsw
  neeenesenwnwwswnenewnwwsewnenwseswesw
  seswneswswsenwwnwse
  nwnwneseeswswnenewneswwnewseswneseene
  swweswneswnenwsewnwneneseenw
  eesenwseswswnenwswnwnwsewwnwsene
  sewnenenenesenwsewnenwwwse
  wenwwweseeeweswwwnwwe
  wsweesenenewnwwnwsenewsenwwsesesenwne
  neeswseenwwswnwswswnw
  nenwswwsewswnenenewsenwsenwnesesenew
  enewnwewneswsewnwswenweswnenwsenwsw
  sweneswneswneneenwnewenewwneswswnese
  swwesenesewenwneswnwwneseswwne
  enesenwswwswneneswsenwnewswseenwsese
  wnwnesenesenenwwnenwsewesewsesesew
  nenewswnwewswnenesenwnesewesw
  eneswnwswnwsenenwnwnwwseeswneewsenese
  neswnwewnwnwseenwseesewsenwsweewe
  wseweeenwnesenwwwswnew

  In the above example, 10 tiles are flipped once (to black), and 5 more are
  flipped twice (to black, then back to white). After all of these
  instructions have been followed, a total of 10 tiles are black.

  Go through the renovation crew's list and determine which tiles they need
  to flip. After all of the instructions have been followed, how many tiles
  are left with the black side up?

  Your puzzle answer was 512.
  """

  def count_black_side_up_tiles do
    tiles = %{{0, 0} => :white}
    get_tile_instr()
    |> Enum.reduce(tiles, fn path, new_tiles ->
      follow_path(path, new_tiles, {0, 0})
    end)
    |> count_black_tiles()
  end

  @doc """
  --- Part Two ---

  The tile floor in the lobby is meant to be a living art exhibit. Every day,
  the tiles are all flipped according to the following rules:

    - Any black tile with zero or more than 2 black tiles immediately
      adjacent to it is flipped to white.
    - Any white tile with exactly 2 black tiles immediately adjacent to it
      is flipped to black.

  Here, tiles immediately adjacent means the six tiles directly touching the
  tile in question.

  The rules are applied simultaneously to every tile; put another way, it is
  first determined which tiles need to be flipped, then they are all flipped
  at the same time.

  In the above example, the number of black tiles that are facing up after
  the given number of days has passed is as follows:

  Day 1: 15
  Day 2: 12
  Day 3: 25
  Day 4: 14
  Day 5: 23
  Day 6: 28
  Day 7: 41
  Day 8: 37
  Day 9: 49
  Day 10: 37

  Day 20: 132
  Day 30: 259
  Day 40: 406
  Day 50: 566
  Day 60: 788
  Day 70: 1106
  Day 80: 1373
  Day 90: 1844
  Day 100: 2208

  After executing this process a total of 100 times, there would be 2208
  lack tiles facing up.

  How many tiles will be black after 100 days?

  Your puzzle answer was 4120.
  """

  def flip_tiles_100_days do
    tiles = %{{0, 0} => :white}
    get_tile_instr()
    |> Enum.reduce(tiles, fn path, new_tiles ->
      follow_path(path, new_tiles, {0, 0})
    end)
    |> flip_tiles(100)
    |> count_black_tiles()
  end

  defp flip_tiles(tiles, 0), do: tiles

  defp flip_tiles(tiles, count) do
    # preprocess the set of tiles by adding any missing adjacent white tiles
    tiles = add_adj_white_tiles(tiles)

    new_tiles =
      Map.keys(tiles)
      |> Enum.reduce(tiles, fn coord, proc_tiles ->
        adj_black_count = adj_black_count(tiles, coord)

        case tiles[coord] do
          :black ->
            if adj_black_count == 0 || adj_black_count > 2 do
              Map.put(proc_tiles, coord, :white)
            else
              proc_tiles
            end

          :white ->
            if adj_black_count == 2 do
              Map.put(proc_tiles, coord, :black)
            else
              proc_tiles
            end
        end
      end)

    flip_tiles(new_tiles, count - 1)
  end

  defp add_adj_white_tiles(tiles) do
    Map.keys(tiles)
    |> Enum.reduce(tiles, fn coord, proc_tiles ->
      add_adj_tiles(proc_tiles, coord)
    end)
  end

  # Add adjacent white tiles to new tile layout if necessary
  defp add_adj_tiles(tiles, {x, y}) do
    tiles
    |> add_adj_tile({x + 2, y})
    |> add_adj_tile({x + 1, y - 1})
    |> add_adj_tile({x - 1, y - 1})
    |> add_adj_tile({x - 2, y})
    |> add_adj_tile({x - 1, y + 1})
    |> add_adj_tile({x + 1, y + 1})
  end

  defp add_adj_tile(tiles, coord) do
    # Create tile if necessary
    case tiles[coord] do
      nil -> Map.put_new(tiles, coord, :white)
      _ -> tiles
    end
  end

  defp adj_black_count(tiles, {x, y}) do
    if tiles[{x + 2, y}] == :black do
      1
    else
      0
    end +
      if tiles[{x + 1, y - 1}] == :black do
        1
      else
        0
      end +
      if tiles[{x - 1, y - 1}] == :black do
        1
      else
        0
      end +
      if tiles[{x - 2, y}] == :black do
        1
      else
        0
      end +
      if tiles[{x - 1, y + 1}] == :black do
        1
      else
        0
      end +
      if tiles[{x + 1, y + 1}] == :black do
        1
      else
        0
      end
  end

  # Common functions

  defp get_tile_instr(input \\ "inputs/day24_input.txt") do
    File.read!(input)
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  defp follow_path([], tiles, coord) do
    # on the last tile of the path, flip it over
    case tiles[coord] do
      :white -> Map.put(tiles, coord, :black)
      :black -> Map.put(tiles, coord, :white)
    end
  end

  defp follow_path(path, tiles, coord) do
    {rem_path, new_coord} = parse_path(path, coord)

    new_tiles =
      case tiles[new_coord] do
        nil -> Map.put_new(tiles, new_coord, :white)
        _ -> tiles
      end

    follow_path(rem_path, new_tiles, new_coord)
  end

  defp parse_path(path, {x, y}) do
    case path do
      [?e | rem_path] -> {rem_path, {x + 2, y}}
      [?s | [?e | rem_path]] -> {rem_path, {x + 1, y - 1}}
      [?s | [?w | rem_path]] -> {rem_path, {x - 1, y - 1}}
      [?w | rem_path] -> {rem_path, {x - 2, y}}
      [?n | [?w | rem_path]] -> {rem_path, {x - 1, y + 1}}
      [?n | [?e | rem_path]] -> {rem_path, {x + 1, y + 1}}
    end
  end

  defp count_black_tiles(tiles) do
    Map.keys(tiles)
    |> Enum.reduce(0, fn tile_coord, count ->
      case tiles[tile_coord] do
        :black -> count + 1
        _ -> count
      end
    end)
  end
end
