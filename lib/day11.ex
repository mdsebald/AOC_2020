defmodule Day11 do
  @moduledoc """
  --- Day 11: Seating System ---
  """

  @doc """
  --- Part One ---

  Your plane lands with plenty of time to spare. The final leg of your
  journey is a ferry that goes directly to the tropical island where you can
  finally start your vacation. As you reach the waiting area to board the
  ferry, you realize you're so early, nobody else has even arrived yet!

  By modeling the process people use to choose (or abandon) their seat in the
  waiting area, you're pretty sure you can predict the best place to sit. You
  make a quick map of the seat layout (your puzzle input).

  The seat layout fits neatly on a grid. Each position is either floor (.),
  an empty seat (L), or an occupied seat (#). For example, the initial seat
  layout might look like this:

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  Now, you just need to model the people who will be arriving shortly.
  Fortunately, people are entirely predictable and always follow a simple set
  of rules. All decisions are based on the number of occupied seats adjacent
  to a given seat (one of the eight positions immediately up, down, left,
  right, or diagonal from the seat). The following rules are applied to every
  seat simultaneously:

    - If a seat is empty (L) and there are no occupied seats adjacent to it,
      the seat becomes occupied.
    - If a seat is occupied (#) and four or more seats adjacent to it are
      also occupied, the seat becomes empty.
    - Otherwise, the seat's state does not change.

  Floor (.) never changes; seats don't move, and nobody sits on the floor.

  After one round of these rules, every seat in the example layout becomes
  occupied:

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  After a second round, the seats with four or more occupied adjacent seats
  become empty again:

  #.LL.L#.##
  #LLLLLL.L#
  L.L.L..L..
  #LLL.LL.L#
  #.LL.LL.LL
  #.LLLL#.##
  ..L.L.....
  #LLLLLLLL#
  #.LLLLLL.L
  #.#LLLL.##

  This process continues for three more rounds:

  #.##.L#.##
  #L###LL.L#
  L.#.#..#..
  #L##.##.L#
  #.##.LL.LL
  #.###L#.##
  ..#.#.....
  #L######L#
  #.LL###L.L
  #.#L###.##
  #.#L.L#.##
  #LLL#LL.L#
  L.L.L..#..
  #LLL.##.L#
  #.LL.LL.LL
  #.LL#L#.##
  ..L.L.....
  #L#LLLL#L#
  #.LLLLLL.L
  #.#L#L#.##
  #.#L.L#.##
  #LLL#LL.L#
  L.#.L..#..
  #L##.##.L#
  #.#L.LL.LL
  #.#L#L#.##
  ..L.L.....
  #L#L##L#L#
  #.LLLLLL.L
  #.#L#L#.##

  At this point, something interesting happens: the chaos stabilizes and
  further applications of these rules cause no seats to change state! Once
  people stop moving around, you count 37 occupied seats.

  Simulate your seating area by applying the seating rules repeatedly until
  no seats change state. How many seats end up occupied?

  Your puzzle answer was 2427.
  """

  def final_seats_occupied1 do
    # "inputs/day11_test1_input.txt")
    get_initial_seats()
    |> iterate_seating1()
  end

  defp iterate_seating1(seats, last_occupied \\ 0) do
    new_seats = seating_round1(seats)
    new_occupied = occupied_count(new_seats)
    # IO.puts("#{new_occupied}")
    if last_occupied != new_occupied do
      iterate_seating1(new_seats, new_occupied)
    else
      new_occupied
    end
  end

  defp seating_round1(seats) do
    # IO.puts("#{inspect(seats)}\n")
    {new_seats, _row_cnt} =
      Enum.map_reduce(seats, 0, fn row, row_num ->
        {row_round1(seats, row, row_num), row_num + 1}
      end)

    # IO.puts("#{inspect(new_seats)}")
    new_seats
  end

  defp row_round1(seats, row, row_num) do
    {new_row, _seat_cnt} =
      Enum.map_reduce(row, 0, fn seat, seat_num ->
        {next_seat1(seats, seat, row_num, seat_num), seat_num + 1}
      end)

    # IO.puts("next row: #{inspect(new_row)}")
    new_row
  end

  defp next_seat1(seats, seat, row_num, seat_num) do
    case seat do
      ?L ->
        if adjacent_cnt1(seats, row_num, seat_num) == 0 do
          ?#
        else
          ?L
        end

      ?# ->
        if adjacent_cnt1(seats, row_num, seat_num) >= 4 do
          ?L
        else
          ?#
        end

      seat ->
        seat
    end
  end

  defp adjacent_cnt1(seats, row_num, seat_num) do
    occupied(seats, row_num - 1, seat_num - 1) +
      occupied(seats, row_num - 1, seat_num) +
      occupied(seats, row_num - 1, seat_num + 1) +
      occupied(seats, row_num, seat_num - 1) +
      occupied(seats, row_num, seat_num + 1) +
      occupied(seats, row_num + 1, seat_num - 1) +
      occupied(seats, row_num + 1, seat_num) +
      occupied(seats, row_num + 1, seat_num + 1)
  end

  @doc """
  --- Part Two ---

  As soon as people start to arrive, you realize your mistake. People don't
  just care about adjacent seats - they care about the first seat they can
  see in each of those eight directions!

  Now, instead of considering just the eight immediately adjacent seats,
  consider the first seat in each of those eight directions. For example, the
  empty seat below would see eight occupied seats:

  .......#.
  ...#.....
  .#.......
  .........
  ..#L....#
  ....#....
  .........
  #........
  ...#.....

  The leftmost empty seat below would only see one empty seat, but cannot see
  any of the occupied ones:

  .............
  .L.L.#.#.#.#.
  .............

  The empty seat below would see no occupied seats:

  .##.##.
  #.#.#.#
  ##...##
  ...L...
  ##...##
  #.#.#.#
  .##.##.

  Also, people seem to be more tolerant than you expected: it now takes five
  or more visible occupied seats for an occupied seat to become empty (rather
  than four or more from the previous rules). The other rules still apply:
  empty seats that see no occupied seats become occupied, seats matching no
  rule don't change, and floor never changes.

  Given the same starting layout as above, these new rules cause the seating
  area to shift around as follows:

  L.LL.LL.LL
  LLLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLLL
  L.LLLLLL.L
  L.LLLLL.LL

  #.##.##.##
  #######.##
  #.#.#..#..
  ####.##.##
  #.##.##.##
  #.#####.##
  ..#.#.....
  ##########
  #.######.#
  #.#####.##

  #.LL.LL.L#
  #LLLLLL.LL
  L.L.L..L..
  LLLL.LL.LL
  L.LL.LL.LL
  L.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLLL.L
  #.LLLLL.L#

  #.L#.##.L#
  #L#####.LL
  L.#.#..#..
  ##L#.##.##
  #.##.#L.##
  #.#####.#L
  ..#.#.....
  LLL####LL#
  #.L#####.L
  #.L####.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##LL.LL.L#
  L.LL.LL.L#
  #.LLLLL.LL
  ..L.L.....
  LLLLLLLLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.#L.L#
  #.L####.LL
  ..#.#.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  #.L#.L#.L#
  #LLLLLL.LL
  L.L.L..#..
  ##L#.#L.L#
  L.L#.LL.L#
  #.LLLL#.LL
  ..#.L.....
  LLL###LLL#
  #.LLLLL#.L
  #.L#LL#.L#

  Again, at this point, people stop shifting around and the seating area
  reaches equilibrium. Once this occurs, you count 26 occupied seats.

  Given the new visibility method and the rule change for occupied seats
  becoming empty, once equilibrium is reached, how many seats end up
  occupied?

  Your puzzle answer was 2199.
  """

  def final_seats_occupied2 do
    get_initial_seats()
    |> iterate_seating2()
  end

  defp iterate_seating2(seats, last_occupied \\ 0) do
    new_seats = seating_round2(seats)
    new_occupied = occupied_count(new_seats)
    # IO.puts("#{new_occupied}")
    if last_occupied != new_occupied do
      iterate_seating2(new_seats, new_occupied)
    else
      new_occupied
    end
  end

  defp seating_round2(seats) do
    # IO.puts("#{inspect(seats)}\n")
    {new_seats, _row_cnt} =
      Enum.map_reduce(seats, 0, fn row, row_num ->
        {row_round2(seats, row, row_num), row_num + 1}
      end)

    # IO.puts("#{inspect(new_seats)}")
    new_seats
  end

  defp row_round2(seats, row, row_num) do
    {new_row, _seat_cnt} =
      Enum.map_reduce(row, 0, fn seat, seat_num ->
        {next_seat2(seats, seat, row_num, seat_num), seat_num + 1}
      end)

    new_row
  end

  defp next_seat2(seats, seat, row_num, seat_num) do
    case seat do
      ?L ->
        if adjacent_cnt2(seats, row_num, seat_num) == 0 do
          ?#
        else
          ?L
        end

      ?# ->
        if adjacent_cnt2(seats, row_num, seat_num) >= 5 do
          ?L
        else
          ?#
        end

      seat ->
        seat
    end
  end

  defp adjacent_cnt2(seats, row_num, seat_num) do
    adj_occupied(seats, row_num, -1, seat_num, -1) +
      adj_occupied(seats, row_num, -1, seat_num, 0) +
      adj_occupied(seats, row_num, -1, seat_num, +1) +
      adj_occupied(seats, row_num, 0, seat_num, -1) +
      adj_occupied(seats, row_num, 0, seat_num, +1) +
      adj_occupied(seats, row_num, +1, seat_num, -1) +
      adj_occupied(seats, row_num, +1, seat_num, 0) +
      adj_occupied(seats, row_num, +1, seat_num, +1)
  end

  defp adj_occupied(seats, row_num, row_dir, seat_num, seat_dir) do
    next_row_num = row_num + row_dir
    next_seat_num = seat_num + seat_dir

    case get_seat(seats, next_row_num, next_seat_num) do
      # off the seating chart
      nil -> 0
      # occupied seat in this direction
      ?# -> 1
      # empty seat blocks furthur views in this direction
      ?L -> 0
      # keep looking in this direction
      _ -> adj_occupied(seats, next_row_num, row_dir, next_seat_num, seat_dir)
    end
  end

  # Common functions

  defp get_initial_seats(input \\ "inputs/day11_input.txt") do
    File.read!(input)
    |> String.split()
    |> Enum.map(&String.to_charlist/1)
  end

  defp occupied_count(seats) do
    Enum.reduce(seats, 0, fn row, r_occupied ->
      Enum.reduce(row, 0, fn seat, s_occupied ->
        case seat do
          ?# -> s_occupied + 1
          _ -> s_occupied
        end
      end) + r_occupied
    end)
  end

  defp occupied(seats, row_num, seat_num) do
    case get_seat(seats, row_num, seat_num) do
      ?# -> 1
      _ -> 0
    end
  end

  defp get_seat(seats, row_num, seat_num) do
    if row_num < 0 || seat_num < 0 do
      nil
    else
      row = Enum.at(seats, row_num, [])
      seat = Enum.at(row, seat_num, nil)
      # IO.puts("#{row_num}, #{seat_num}: #{inspect(seat)}")
      seat
    end
  end
end
