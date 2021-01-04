defmodule Day07 do
  @moduledoc """
  --- Day 7: Handy Haversacks ---
  """

  @doc """
  --- Part One ---

  You land at the regional airport in time for your next flight. In fact, it
  looks like you'll even have time to grab some food: all flights are
  currently delayed due to issues in luggage processing.

  Due to recent aviation regulations, many rules (your puzzle input) are
  being enforced about bags and their contents; bags must be color-coded and
  must contain specific quantities of other color-coded bags. Apparently,
  nobody responsible for these regulations considered how long they would
  take to enforce!

  For example, consider the following rules:

  light red bags contain 1 bright white bag, 2 muted yellow bags.
  dark orange bags contain 3 bright white bags, 4 muted yellow bags.
  bright white bags contain 1 shiny gold bag.
  muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
  shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
  dark olive bags contain 3 faded blue bags, 4 dotted black bags.
  vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
  faded blue bags contain no other bags.
  dotted black bags contain no other bags.

  These rules specify the required contents for 9 bag types. In this example,
  every faded blue bag is empty, every vibrant plum bag contains 11 bags (5
  faded blue and 6 dotted black), and so on.

  You have a shiny gold bag. If you wanted to carry it in at least one other
  bag, how many different bag colors would be valid for the outermost bag?
  (In other words: how many colors can, eventually, contain at least one
  shiny gold bag?)

  In the above rules, the following options would be available to you:

    - A bright white bag, which can hold your shiny gold bag directly.
    - A muted yellow bag, which can hold your shiny gold bag directly,
      plus some other bags.
    - A dark orange bag, which can hold bright white and muted yellow bags,
      either of which could then hold your shiny gold bag.
    - A light red bag, which can hold bright white and muted yellow bags,
      either of which could then hold your shiny gold bag.

  So, in this example, the number of bag colors that can eventually contain
  at least one shiny gold bag is 4.

  How many bag colors can eventually contain at least one shiny gold bag?
  (The list of rules is quite long; make sure you get all of it.)

  Your puzzle answer was 161.
  """

  def qty_bag_colors_contain_shiny_gold do
    bag_color_contents = get_bag_color_contents()
    count_bag_colors_containing_shiny_gold(bag_color_contents)
  end

  defp count_bag_colors_containing_shiny_gold(bag_color_contents) do
    # IO.puts("Start counting...")
    count_bag_colors_containing_shiny_gold(bag_color_contents, ["shiny gold"], [], [], 0)
  end

  defp count_bag_colors_containing_shiny_gold(
         _bag_color_contents,
         [],
         [],
         _already_counted,
         shiny_gold_count
       ) do
    # IO.puts("Finished: #{shiny_gold_count}")
    shiny_gold_count
  end

  defp count_bag_colors_containing_shiny_gold(
         bag_color_contents,
         [],
         next_bag_colors_containing_shiny_gold,
         already_counted,
         shiny_gold_count
       ) do
    # IO.puts("Completed a pass: #{shiny_gold_count}\n#{inspect(Enum.sort(next_bag_colors_containing_shiny_gold))}\n#{inspect(Enum.sort(already_counted))}")
    count_bag_colors_containing_shiny_gold(
      bag_color_contents,
      next_bag_colors_containing_shiny_gold,
      [],
      already_counted,
      shiny_gold_count
    )
  end

  defp count_bag_colors_containing_shiny_gold(
         bag_color_contents,
         [bag_color_containing_shiny_gold | rem_bag_colors_containing_shiny_gold],
         next_bag_colors_containing_shiny_gold,
         already_counted,
         shiny_gold_count
       ) do
    # IO.puts("#{bag_color_containing_shiny_gold}, #{inspect(next_bag_colors_containing_shiny_gold)}, #{shiny_gold_count}")
    {new_shiny_gold_count, new_next_bag_colors_containing_shiny_gold, new_already_counted} =
      Map.keys(bag_color_contents)
      |> Enum.reduce(
        {shiny_gold_count, next_bag_colors_containing_shiny_gold, already_counted},
        fn outer_bag_color, {shiny_gold_count, bags_containing_shiny_gold, already_counted} ->
          if bag_contains_color?(
               bag_color_containing_shiny_gold,
               bag_color_contents[outer_bag_color]
             ) &&
               !Enum.member?(bags_containing_shiny_gold, outer_bag_color) &&
               !Enum.member?(already_counted, outer_bag_color) do
            # IO.puts("Outer bag: #{outer_bag_color} Contains: #{bag_color_containing_shiny_gold}")
            {shiny_gold_count + 1, [outer_bag_color | bags_containing_shiny_gold],
             [outer_bag_color | already_counted]}
          else
            {shiny_gold_count, bags_containing_shiny_gold, already_counted}
          end
        end
      )

    count_bag_colors_containing_shiny_gold(
      bag_color_contents,
      rem_bag_colors_containing_shiny_gold,
      new_next_bag_colors_containing_shiny_gold,
      new_already_counted,
      new_shiny_gold_count
    )
  end

  defp bag_contains_color?(color, bag_contents) do
    List.keymember?(bag_contents, color, 1)
  end

  @doc """
  --- Part Two ---

  It's getting pretty expensive to fly these days - not because of ticket
  prices, but because of the ridiculous number of bags you need to buy!

  Consider again your shiny gold bag and the rules from the above example:

    - faded blue bags contain 0 other bags.
    - dotted black bags contain 0 other bags.
    - vibrant plum bags contain 11 other bags: 5 faded blue bags and 6
      dotted black bags.
    - dark olive bags contain 7 other bags: 3 faded blue bags and 4
      dotted black bags.

    So, a single shiny gold bag must contain 1 dark olive bag (and the 7 bags
    within it) plus 2 vibrant plum bags (and the 11 bags within each of those):
    1 + 1*7 + 2 + 2*11 = 32 bags!

  Of course, the actual rules have a small chance of going several levels
  deeper than this example; be sure to count all of the bags, even if the
  nesting becomes topologically impractical!

  Here's another example:

  shiny gold bags contain 2 dark red bags.
  dark red bags contain 2 dark orange bags.
  dark orange bags contain 2 dark yellow bags.
  dark yellow bags contain 2 dark green bags.
  dark green bags contain 2 dark blue bags.
  dark blue bags contain 2 dark violet bags.
  dark violet bags contain no other bags.

  In this example, a single shiny gold bag must contain 126 other bags.

  How many individual bags are required inside your single shiny gold bag?

  Your puzzle answer was 30899.
  """

  def qty_bags_contained_in_shiny_gold_bag do
    bag_color_contents = get_bag_color_contents()
    total_bag_count(bag_color_contents, "shiny gold")
  end

  defp total_bag_count(bag_color_contents, outer_bag_color) do
    # IO.puts("Counting bags in: #{outer_bag_color}")
    # get list of the contents. i.e. {qty, color} tuples
    bag_color_contents[outer_bag_color]
    |> Enum.reduce(
      0,
      fn bag_contents, total ->
        case bag_contents do
          {0, "other"} ->
            total

          {qty, color} ->
            total + qty + qty * total_bag_count(bag_color_contents, color)
        end
      end
    )
  end

  # Common functions

  defp get_bag_color_contents do
    File.read!("inputs/day07_input.txt")
    # One bag color per line
    |> String.split("\n")
    # Split the rule string into outer bag color and contents
    |> Enum.map(fn contents_str ->
      String.split(contents_str, [" bags contain ", " bag, ", " bag.", " bags, ", " bags."],
        trim: true
      )
    end)
    # A bag must have at least outer bag color and content description
    |> Enum.filter(fn contents_str -> length(contents_str) >= 2 end)
    # Map the outer bag color to the contents
    |> Enum.reduce(Map.new(), fn contents, bag_contents_map ->
      Map.merge(bag_contents_map, create_bag_contents_map(contents))
    end)
  end

  defp create_bag_contents_map([outer_bag | contents]) do
    parsed_contents =
      contents
      |> Enum.map(fn content ->
        case content do
          "no other" ->
            {0, "other"}

          content ->
            {qty, color} = Integer.parse(content)
            {qty, String.trim(color)}
        end
      end)

    # IO.puts("#{outer_bag}, #{inspect(parsed_contents)}")
    Map.new([{outer_bag, parsed_contents}])
  end
end
