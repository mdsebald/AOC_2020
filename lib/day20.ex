defmodule Day20 do
  @moduledoc """
  --- Day 20: Jurassic Jigsaw ---
  """

  @doc """
  --- Part One ---

  The high-speed train leaves the forest and quickly carries you south. You
  can even see a desert in the distance! Since you have some spare time, you
  might as well see if there was anything interesting in the image the
  Mythical Information Bureau satellite captured.

  After decoding the satellite messages, you discover that the data actually
  contains many small images created by the satellite's camera array. The
  camera array consists of many cameras; rather than produce a single square
  image, they produce many smaller square image tiles that need to be
  reassembled back into a single image.

  Each camera in the camera array returns a single monochrome image tile with
  a random unique ID number. The tiles (your puzzle input) arrived in a
  random order.

  Worse yet, the camera array appears to be malfunctioning: each image tile
  has been rotated and flipped to a random orientation. Your first task is to
  reassemble the original image by orienting the tiles so they fit together.

  To show how the tiles should be reassembled, each tile's image data
  includes a border that should line up exactly with its adjacent tiles. All
  tiles have this border, and the border lines up exactly when the tiles are
  both oriented correctly. Tiles at the edge of the image also have this
  border, but the outermost edges won't line up with any other tiles.

  For example, suppose you have the following nine tiles:

  Tile 2311:
  ..##.#..#.
  ##..#.....
  #...##..#.
  ####.#...#
  ##.##.###.
  ##...#.###
  .#.#.#..##
  ..#....#..
  ###...#.#.
  ..###..###

  Tile 1951:
  #.##...##.
  #.####...#
  .....#..##
  #...######
  .##.#....#
  .###.#####
  ###.##.##.
  .###....#.
  ..#.#..#.#
  #...##.#..

  Tile 1171:
  ####...##.
  #..##.#..#
  ##.#..#.#.
  .###.####.
  ..###.####
  .##....##.
  .#...####.
  #.##.####.
  ####..#...
  .....##...

  Tile 1427:
  ###.##.#..
  .#..#.##..
  .#.##.#..#
  #.#.#.##.#
  ....#...##
  ...##..##.
  ...#.#####
  .#.####.#.
  ..#..###.#
  ..##.#..#.

  Tile 1489:
  ##.#.#....
  ..##...#..
  .##..##...
  ..#...#...
  #####...#.
  #..#.#.#.#
  ...#.#.#..
  ##.#...##.
  ..##.##.##
  ###.##.#..

  Tile 2473:
  #....####.
  #..#.##...
  #.##..#...
  ######.#.#
  .#...#.#.#
  .#########
  .###.#..#.
  ########.#
  ##...##.#.
  ..###.#.#.

  Tile 2971:
  ..#.#....#
  #...###...
  #.#.###...
  ##.##..#..
  .#####..##
  .#..####.#
  #..#.#..#.
  ..####.###
  ..#.#.###.
  ...#.#.#.#

  Tile 2729:
  ...#.#.#.#
  ####.#....
  ..#.#.....
  ....#..#.#
  .##..##.#.
  .#.####...
  ####.#.#..
  ##.####...
  ##..#.##..
  #.##...##.

  Tile 3079:
  #.#.#####.
  .#..######
  ..#.......
  ######....
  ####.#..#.
  .#...#.##.
  #.#####.##
  ..#.###...
  ..#.......
  ..#.###...

  By rotating, flipping, and rearranging them, you can find a square
  arrangement that causes all adjacent borders to line up:

  #...##.#.. ..###..### #.#.#####.
  ..#.#..#.# ###...#.#. .#..######
  .###....#. ..#....#.. ..#.......
  ###.##.##. .#.#.#..## ######....
  .###.##### ##...#.### ####.#..#.
  .##.#....# ##.##.###. .#...#.##.
  #...###### ####.#...# #.#####.##
  .....#..## #...##..#. ..#.###...
  #.####...# ##..#..... ..#.......
  #.##...##. ..##.#..#. ..#.###...

  #.##...##. ..##.#..#. ..#.###...
  ##..#.##.. ..#..###.# ##.##....#
  ##.####... .#.####.#. ..#.###..#
  ####.#.#.. ...#.##### ###.#..###
  .#.####... ...##..##. .######.##
  .##..##.#. ....#...## #.#.#.#...
  ....#..#.# #.#.#.##.# #.###.###.
  ..#.#..... .#.##.#..# #.###.##..
  ####.#.... .#..#.##.. .######...
  ...#.#.#.# ###.##.#.. .##...####

  ...#.#.#.# ###.##.#.. .##...####
  ..#.#.###. ..##.##.## #..#.##..#
  ..####.### ##.#...##. .#.#..#.##
  #..#.#..#. ...#.#.#.. .####.###.
  .#..####.# #..#.#.#.# ####.###..
  .#####..## #####...#. .##....##.
  ##.##..#.. ..#...#... .####...#.
  #.#.###... .##..##... .####.##.#
  #...###... ..##...#.. ...#..####
  ..#.#....# ##.#.#.... ...##.....

  For reference, the IDs of the above tiles are:

  1951    2311    3079
  2729    1427    2473
  2971    1489    1171

  To check that you've assembled the image correctly, multiply the IDs of the
  four corner tiles together. If you do this with the assembled tiles from
  the example above, you get 1951 * 3079 * 2971 * 1171 = 20899048083289.

  Assemble the tiles into an image. What do you get if you multiply together
  the IDs of the four corner tiles?

  Your puzzle answer was 18482479935793.
  """

  def find_corner_tiles do
    get_tiles()
    |> gen_tile_perms()
    |> gen_tile_edges()
    |> gen_tile_relations()
    |> find_corners()
    |> Enum.reduce(1, fn tile_id, prod ->
      String.to_integer(tile_id) * prod
    end)
  end

  @doc """
  --- Part Two ---

  Now, you're ready to check the image for sea monsters.

  The borders of each tile are not part of the actual image; start by
  removing them.

  In the example above, the tiles become:

  .#.#..#. ##...#.# #..#####
  ###....# .#....#. .#......
  ##.##.## #.#.#..# #####...
  ###.#### #...#.## ###.#..#
  ##.#.... #.##.### #...#.##
  ...##### ###.#... .#####.#
  ....#..# ...##..# .#.###..
  .####... #..#.... .#......

  #..#.##. .#..###. #.##....
  #.####.. #.####.# .#.###..
  ###.#.#. ..#.#### ##.#..##
  #.####.. ..##..## ######.#
  ##..##.# ...#...# .#.#.#..
  ...#..#. .#.#.##. .###.###
  .#.#.... #.##.#.. .###.##.
  ###.#... #..#.##. ######..

  .#.#.### .##.##.# ..#.##..
  .####.## #.#...## #.#..#.#
  ..#.#..# ..#.#.#. ####.###
  #..####. ..#.#.#. ###.###.
  #####..# ####...# ##....##
  #.##..#. .#...#.. ####...#
  .#.###.. ##..##.. ####.##.
  ...###.. .##...#. ..#..###

  Remove the gaps to form the actual image:

  .#.#..#.##...#.##..#####
  ###....#.#....#..#......
  ##.##.###.#.#..######...
  ###.#####...#.#####.#..#
  ##.#....#.##.####...#.##
  ...########.#....#####.#
  ....#..#...##..#.#.###..
  .####...#..#.....#......
  #..#.##..#..###.#.##....
  #.####..#.####.#.#.###..
  ###.#.#...#.######.#..##
  #.####....##..########.#
  ##..##.#...#...#.#.#.#..
  ...#..#..#.#.##..###.###
  .#.#....#.##.#...###.##.
  ###.#...#..#.##.######..
  .#.#.###.##.##.#..#.##..
  .####.###.#...###.#..#.#
  ..#.#..#..#.#.#.####.###
  #..####...#.#.#.###.###.
  #####..#####...###....##
  #.##..#..#...#..####...#
  .#.###..##..##..####.##.
  ...###...##...#...#..###

  Now, you're ready to search for sea monsters! Because your image is
  monochrome, a sea monster will look like this:

                    #
  #    ##    ##    ###
  #  #  #  #  #  #

  When looking for this pattern in the image, the spaces can be anything;
  only the # need to match. Also, you might need to rotate or flip your image
  before it's oriented correctly to find sea monsters. In the above image,
  after flipping and rotating it to the appropriate orientation, there are
  two sea monsters (marked with O):

  .####...#####..#...###..
  #####..#..#.#.####..#.#.
  .#.#...#.###...#.##.O#..
  #.O.##.OO#.#.OO.##.OOO##
  ..#O.#O#.O##O..O.#O##.##
  ...#.#..##.##...#..#..##
  #.##.#..#.#..#..##.#.#..
  .###.##.....#...###.#...
  #.####.#.#....##.#..#.#.
  ##...#..#....#..#...####
  ..#.##...###..#.#####..#
  ....#.##.#.#####....#...
  ..##.##.###.....#.##..#.
  #...#...###..####....##.
  .#.##...#.##.#.#.###...#
  #.###.#..####...##..#...
  #.###...#.##...#.##O###.
  .O##.#OO.###OO##..OOO##.
  ..O#.O..O..O.#O##O##.###
  #.#..##.########..#..##.
  #.#####..#.#...##..#....
  #....##..#.#########..##
  #...#.....#..##...###.##
  #..###....##.#...##.##.#

  Determine how rough the waters are in the sea monsters' habitat by counting
  the number of # that are not part of a sea monster. In the above example,
  the habitat's water roughness is 273.

  How many # are not part of a sea monster?

  Your puzzle answer was 2118.
  """

  def find_water_roughness do
    # "inputs/day20_test1_input.txt")
    tile_perms =
      get_tiles()
      |> gen_tile_perms()

    image =
      gen_tile_edges(tile_perms)
      |> gen_tile_relations()
      |> gen_image(tile_perms)

    flipped_image = flip(image)

    image_perms =
      [image] ++
        rotate_3x(image) ++
        [flipped_image] ++
        rotate_3x(flipped_image)

    monsters =
      Enum.reduce_while(image_perms, 0, fn image, _count ->
        count = count_monsters(image)

        if count > 0 do
          {:halt, count}
        else
          {:cont, 0}
        end
      end)

    count_waves(image, monsters)
  end

  defp gen_image(tile_relations, tile_perms) do
    tiles = get_tile_orients(tile_relations, tile_perms)

    tile_id_array = gen_tile_id_array(tile_relations)
    join_tiles(tile_id_array, tiles)
  end

  # For all of the tile orientation permutations
  # get the tile orientations corresponding to the
  # tiles in the tile relationship set we are using
  defp get_tile_orients(tile_relations, tile_perms) do
    Enum.reduce(tile_relations, %{}, fn {{t1, o1}, _rel, {t2, o2}}, tiles ->
      Map.put(tiles, t1, tile_perms[t1] |> Enum.at(o1))
      |> Map.put(t2, tile_perms[t2] |> Enum.at(o2))
    end)
  end

  # Generate a 2D array of tile ID, based on the
  # tile relationships already generated
  defp gen_tile_id_array(tile_relations) do
    ul_tile = find_corners(tile_relations) |> Enum.at(0)
    tile_rows = get_tile_rows(ul_tile, [], tile_relations)
    Enum.reverse(tile_rows)
  end

  # Starting with the left most tile ID in each row
  # get the tile IDs for all of the rows
  defp get_tile_rows(left_tile, tile_array, tile_relations) do
    tile_array = [get_tile_row([left_tile], tile_relations) | tile_array]

    left_tile =
      Enum.reduce_while(tile_relations, nil, fn {{t1, _o1}, rel, {t2, _o2}}, _next_tile ->
        if left_tile == t1 and rel == :ud do
          {:halt, t2}
        else
          {:cont, nil}
        end
      end)

    if left_tile == nil do
      tile_array
    else
      get_tile_rows(left_tile, tile_array, tile_relations)
    end
  end

  # Starting with the leftmost tile, get each tile to the right
  # of the last tile found
  defp get_tile_row(tile_row, tile_relations) do
    last_tile = Enum.at(tile_row, 0)

    next_tile =
      Enum.reduce_while(tile_relations, nil, fn {{t1, _o1}, rel, {t2, _o2}}, _next_tile ->
        if last_tile == t1 and rel == :lr do
          {:halt, t2}
        else
          {:cont, nil}
        end
      end)

    if next_tile == nil do
      Enum.reverse(tile_row)
    else
      get_tile_row([next_tile | tile_row], tile_relations)
    end
  end

  defp join_tiles(tile_id_array, tiles) do
    Enum.reduce(tile_id_array, [], fn tile_id_row, tile_array ->
      tile_array ++
        Enum.reduce(tile_id_row, [], fn tile_id, tile_rows ->
          tile = del_edges(tiles[tile_id])

          if tile_rows == [] do
            tile
          else
            Enum.reduce(0..7, tile_rows, fn index, tile_rows ->
              List.replace_at(tile_rows, index, Enum.at(tile_rows, index) <> Enum.at(tile, index))
            end)
          end
        end)
    end)
  end

  @monster_size 15

  defp count_waves(image, monsters) do
    waves =
      Enum.reduce(image, 0, fn line, waves ->
        add = String.to_charlist(line) |> Enum.count(&(&1 == ?#))
        add + waves
      end)

    waves - monsters * @monster_size
  end

  @monster_regexes [
    ~r/(?=(..................#.))/,
    ~r/(?=(#....##....##....###))/,
    ~r/(?=(.#..#..#..#..#..#...))/
  ]

  def count_monsters(image) do
    Enum.chunk_every(image, 3, 1, :discard)
    |> Enum.map(fn rows ->
      [r1, r2, r3] =
        rows
        |> Enum.zip(@monster_regexes)
        |> Enum.map(fn {row, regex} -> Regex.scan(regex, row, return: :index) end)

      Enum.count(r1 -- r1 -- r2 -- r2 -- r3)
    end)
    |> Enum.sum()
  end

  # Common functions

  defp get_tiles(input \\ "inputs/day20_input.txt") do
    File.read!(input)
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n"))
    |> Enum.map(fn [id_str | tile_strs] ->
      {tile_id(id_str), tile_strs}
    end)
    |> Map.new()
  end

  defp tile_id(id_str) do
    Map.get(Regex.named_captures(~r/^Tile (?'id'[0-9]{4}):$/, id_str), "id")
  end

  # For each tile permutation, generate a set of edges
  # Up, Down, Left, & Right. In that order
  defp gen_tile_edges(tiles) do
    Map.keys(tiles)
    |> Enum.reduce(%{}, fn id, tiles_with_edges ->
      tile_edges =
        tiles[id]
        |> Enum.reduce([], fn tile_perm, edges ->
          edges ++ [get_edges(tile_perm)]
        end)

      Map.put(tiles_with_edges, id, {tile_edges, tiles[id]})
    end)
  end

  # Get the Up, Down, Left, and Right edges of the tile
  # In that order
  defp get_edges(tile) do
    tile
    |> Enum.reduce({"", "", "", "", 0}, fn tile_x, {up, down, left, right, index} ->
      case index do
        0 ->
          {
            tile_x,
            "",
            left <> String.at(tile_x, 0),
            right <> String.at(tile_x, 9),
            index + 1
          }

        9 ->
          {
            up,
            tile_x,
            left <> String.at(tile_x, 0),
            right <> String.at(tile_x, 9),
            index + 1
          }

        _rem_nums ->
          {
            up,
            down,
            left <> String.at(tile_x, 0),
            right <> String.at(tile_x, 9),
            index + 1
          }
      end
    end)
    # Delete the index var from the tuple before returning
    |> Tuple.delete_at(4)
  end

  # Delete the top, bottom, left, and right edges of the tile
  defp del_edges(tile) do
    {tile_out, _index} =
      Enum.reduce(tile, {[], 0}, fn tile_row, {tile_out, index} ->
        case index do
          0 ->
            {tile_out, index + 1}

          9 ->
            {tile_out, index + 1}

          _rem_rows ->
            {[String.slice(tile_row, 1..8) | tile_out], index + 1}
        end
      end)

    Enum.reverse(tile_out)
  end

  # Generate all 8 possible permutations of a tile,
  # via flipping and rotating the tile data array
  defp gen_tile_perms(tiles) do
    Map.keys(tiles)
    |> Enum.reduce(%{}, fn id, new_tiles ->
      org_tile = tiles[id]
      flipped_tile = flip(org_tile)

      Map.put(
        new_tiles,
        id,
        [org_tile] ++
          rotate_3x(org_tile) ++
          [flipped_tile] ++
          rotate_3x(flipped_tile)
      )
    end)
  end

  # Rotate the given tile CW 3 times
  # Save the tile state after each rotation
  defp rotate_3x(tile) do
    r1 = rotate(tile)
    r2 = rotate(r1)
    r3 = rotate(r2)
    [r1, r2, r3]
  end

  # Flip tile left to right
  defp flip(tile) do
    Enum.reduce(tile, [], fn tile_x, flipped_tile ->
      [String.reverse(tile_x) | flipped_tile]
    end)
    |> Enum.reverse()
  end

  # Rotate tile CW
  defp rotate(tile) do
    size = length(tile) - 1
    # Start with a list of empty strings
    rotated_init = List.duplicate("", length(tile))

    Enum.reduce(tile, rotated_init, fn tile_x, rotated_tile ->
      Enum.reduce(0..size, rotated_tile, fn index, next_rotated_tile ->
        # Prefix each char of the horizontal string
        # to each string of the rotated tile
        # Thereby converting a row to a column
        tile_x_rotated = String.at(tile_x, index) <> Enum.at(rotated_tile, index)
        List.replace_at(next_rotated_tile, index, tile_x_rotated)
      end)
    end)
  end

  #
  # A Tile relationship looks like this:
  #   {{tile_id1, orient1}, relation, {tile_id2, orient2}}
  #
  # Where:
  #   tile_id is a unique string, example "1234"
  #   orient is an integer 0 - 7, indicating 1 of 8 possible permutations: 2 (flip left for right) X 4 (rotations)
  #   relation is an atom indicating the postion relationship between tile1 and tile2
  #     :lr means tile1 is left of tile2
  #     :ud means tile1 is above tile2
  #
  defp gen_tile_relations(tiles) do
    tile_ids = Map.keys(tiles)

    Enum.reduce(tile_ids, [], fn tile_id1, related_tiles1 ->
      # IO.puts("1: #{inspect(related_tiles1)}")
      {edges1, _tiles} = tiles[tile_id1]
      edges_orient1 = Enum.with_index(edges1)

      Enum.reduce(edges_orient1, related_tiles1, fn {edge1, orient1}, related_tiles2 ->
        # IO.puts("2: #{inspect(related_tiles2)}")
        Enum.reduce(tile_ids, related_tiles2, fn tile_id2, related_tiles3 ->
          # IO.puts("3: #{inspect(related_tiles3)}")
          {edges2, _tiles} = tiles[tile_id2]
          edges_orient2 = Enum.with_index(edges2)

          Enum.reduce(edges_orient2, related_tiles3, fn {edge2, orient2}, related_tiles4 ->
            # IO.puts("4: #{inspect(related_tiles4)}")
            compare_edges(related_tiles4, tile_id1, edge1, orient1, tile_id2, edge2, orient2)
          end)
        end)
      end)
    end)
    |> Enum.uniq()
    |> group_related_tiles([])
  end

  defp compare_edges(related_tiles, tile_id1, edge1, orient1, tile_id2, edge2, orient2) do
    if tile_id1 != tile_id2 do
      {up1, down1, left1, right1} = edge1
      {up2, down2, left2, right2} = edge2

      related_tiles =
        if right1 == left2 do
          [{{tile_id1, orient1}, :lr, {tile_id2, orient2}} | related_tiles]
        else
          related_tiles
        end

      related_tiles =
        if left1 == right2 do
          [{{tile_id2, orient2}, :lr, {tile_id1, orient1}} | related_tiles]
        else
          related_tiles
        end

      related_tiles =
        if up1 == down2 do
          [{{tile_id2, orient2}, :ud, {tile_id1, orient1}} | related_tiles]
        else
          related_tiles
        end

      if down1 == up2 do
        [{{tile_id1, orient1}, :ud, {tile_id2, orient2}} | related_tiles]
      else
        related_tiles
      end
    else
      related_tiles
    end
  end

  # From the list of all tile permutations and their relationships,
  # find one coherent group of related tiles
  # Orientation doesn't matter, the corners are the same, for all related groups
  defp group_related_tiles(related_tiles_list, related_tiles_group) do
    begin = length(related_tiles_group)

    {related_tiles_used, related_tiles_group} =
      Enum.reduce(related_tiles_list, {[], related_tiles_group}, fn related_tiles_to_group,
                                                                    {related_tiles_used,
                                                                     next_grouped_related_tiles} ->
        case next_grouped_related_tiles do
          [] ->
            # Related tiles group is empty
            # Just use the first pair of related tiles to start this grouped tiles list
            {[related_tiles_to_group], [related_tiles_to_group]}

          _other ->
            if contains?(related_tiles_group, related_tiles_to_group) do
              {[related_tiles_to_group | related_tiles_used],
               [related_tiles_to_group | next_grouped_related_tiles]}
            else
              # don't add these related tiles to this group
              {related_tiles_used, next_grouped_related_tiles}
            end
        end
      end)

    # Delete the tiles we just grouped from the related tiles list
    related_tiles_list = Enum.reject(related_tiles_list, &Enum.member?(related_tiles_used, &1))

    if begin == length(related_tiles_group) || related_tiles_list == [] do
      # Did not find anymore related tiles to group or
      # No more related tiles to check
      # We're done
      related_tiles_group
    else
      # keep grouping
      group_related_tiles(related_tiles_list, related_tiles_group)
    end
  end

  defp contains?(grouped_tiles, {chk_tile_orient1, _related, chk_tile_orient2}) do
    Enum.reduce_while(grouped_tiles, false, fn {tile_orient1, _related, tile_orient2}, _found ->
      if tile_orient1 == chk_tile_orient1 || tile_orient1 == chk_tile_orient2 ||
           tile_orient2 == chk_tile_orient1 || tile_orient2 == chk_tile_orient2 do
        {:halt, true}
      else
        {:cont, false}
      end
    end)
  end

  # Find the corner tiles
  defp find_corners(grouped_tiles) do
    start_tile_ids =
      Enum.reduce(grouped_tiles, [], fn {{tile_id1, _orient1}, _relation, {tile_id2, _orient2}},
                                        tile_ids ->
        [tile_id1 | [tile_id2 | tile_ids]]
      end)
      |> Enum.uniq()

    # Find upper left corner, no tile above or to the left
    upper_left =
      Enum.reduce(grouped_tiles, start_tile_ids, fn {{_tile_id1, _orient1}, relation,
                                                     {tile_id2, _orient2}},
                                                    rem_tile_ids ->
        case relation do
          :ud -> List.delete(rem_tile_ids, tile_id2)
          :lr -> List.delete(rem_tile_ids, tile_id2)
        end
      end)

    # Find lower left corner, no tile below or to the left
    lower_left =
      Enum.reduce(grouped_tiles, start_tile_ids, fn {{tile_id1, _orient1}, relation,
                                                     {tile_id2, _orient2}},
                                                    rem_tile_ids ->
        case relation do
          :ud -> List.delete(rem_tile_ids, tile_id1)
          :lr -> List.delete(rem_tile_ids, tile_id2)
        end
      end)

    # Find upper right corner, no tile above or to the right
    upper_right =
      Enum.reduce(grouped_tiles, start_tile_ids, fn {{tile_id1, _orient1}, relation,
                                                     {tile_id2, _orient2}},
                                                    rem_tile_ids ->
        case relation do
          :ud -> List.delete(rem_tile_ids, tile_id2)
          :lr -> List.delete(rem_tile_ids, tile_id1)
        end
      end)

    # Find lower right corner, no tile below or to the right
    lower_right =
      Enum.reduce(grouped_tiles, start_tile_ids, fn {{tile_id1, _orient1}, relation,
                                                     {_tile_id2, _orient2}},
                                                    rem_tile_ids ->
        case relation do
          :ud -> List.delete(rem_tile_ids, tile_id1)
          :lr -> List.delete(rem_tile_ids, tile_id1)
        end
      end)

    # these are already in list form, just concatenate
    upper_left ++ upper_right ++ lower_left ++ lower_right
  end
end
