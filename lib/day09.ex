defmodule Day09 do
  @moduledoc """
  --- Day 9: Encoding Error ---
  """

  @doc """
  --- Part One ---

  With your neighbor happily enjoying their video game, you turn your
  attention to an open data port on the little screen in the seat in front of
  you.

  Though the port is non-standard, you manage to connect it to your computer
  through the clever use of several paperclips. Upon connection, the port
  outputs a series of numbers (your puzzle input).

  The data appears to be encrypted with the eXchange-Masking Addition System
  (XMAS) which, conveniently for you, is an old cypher with an important
  weakness.

  XMAS starts by transmitting a preamble of 25 numbers. After that, each
  number you receive should be the sum of any two of the 25 immediately p
  revious numbers. The two numbers will have different values, and there
  might be more than one such pair.

  For example, suppose your preamble consists of the numbers 1 through 25 in
  a random order. To be valid, the next number must be the sum of two of
  those numbers:

    - 26 would be a valid next number, as it could be 1 plus 25 (or many
      other pairs, like 2 and 24).
    - 49 would be a valid next number, as it is the sum of 24 and 25.
    - 100 would not be valid; no two of the previous 25 numbers sum to 100.
    - 50 would also not be valid; although 25 appears in the previous 25
      numbers, the two numbers in the pair must be different.

  Suppose the 26th number is 45, and the first number (no longer an option,
  as it is more than 25 numbers ago) was 20. Now, for the next number to be
  valid, there needs to be some pair of numbers among 1-19, 21-25, or 45 that
  add up to it:

    - 26 would still be a valid next number, as 1 and 25 are still within
      the previous 25 numbers.
    - 65 would not be valid, as no two of the available numbers sum to it.
    - 64 and 66 would both be valid, as they are the result of 19+45 and
      21+45 respectively.

  Here is a larger example which only considers the previous 5 numbers (and has a preamble of length 5):

  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576

  In this example, after the 5-number preamble, almost every number is the
  sum of two of the previous 5 numbers; the only number that does not follow
  this rule is 127.

  The first step of attacking the weakness in the XMAS data is to find the
  first number in the list (after the preamble) which is not the sum of two
  of the 25 numbers before it. What is the first number that does not have
  this property?

  Your puzzle answer was 105950735.
  """

  def find_first_non_xmas_number do
    # split list of numbers into preamble and data
    {preamble, data} = get_xmas_data() |> Enum.split(25)
    check_data(preamble, data)
  end

  @doc """
  --- Part Two ---

  The final step in breaking the XMAS encryption relies on the invalid number
  you just found: you must find a contiguous set of at least two numbers in
  your list which sum to the invalid number from step 1.

  Again consider the above example:

  35
  20
  15
  25
  47
  40
  62
  55
  65
  95
  102
  117
  150
  182
  127
  219
  299
  277
  309
  576

  In this list, adding up all of the numbers from 15 through 40 produces the
  invalid number from step 1, 127. (Of course, the contiguous set of numbers
  in your actual list might be much longer.)

  To find the encryption weakness, add together the smallest and largest
  number in this contiguous range; in this example, these are 15 and 47,
  producing 62.

  What is the encryption weakness in your XMAS-encrypted list of numbers?

  Your puzzle answer was 13826915.
  """

  def find_encryption_weakness do
    data = get_xmas_data()
    # Just repeat what we did in part 1, to find the invalid number
    {preamble, data} = Enum.split(data, 25)
    target_number = check_data(preamble, data)
    {min, max} = find_target_range(data, target_number) |> Enum.min_max()
    # answer is the sum of the min and max values in the range
    min + max
  end

  defp find_target_range([], _target_number) do
    # ran out of data before finding contiguous range
    []
  end

  defp find_target_range([first | rem_data], target_number) do
    {sum, range} =
      Enum.reduce_while(rem_data, {first, [first]}, fn number, {sum, range} ->
        new_sum = number + sum
        new_range = [number | range]

        if new_sum >= target_number do
          {:halt, {new_sum, new_range}}
        else
          {:cont, {new_sum, new_range}}
        end
      end)

    if sum == target_number do
      # got our range
      range
    else
      # overran the target number, try again with the remaining data
      find_target_range(rem_data, target_number)
    end
  end

  # Common functions

  defp get_xmas_data do
    File.read!("inputs/day09_input.txt")
    # one number per line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp check_data(_preamble, []) do
    # didn't find any invalid numbers
    nil
  end

  defp check_data(preamble, [number | rem_data]) do
    # IO.puts("check_data: #{inspect(preamble)}, #{number}")
    if !valid_xmas_number?(preamble, number) do
      number
    else
      [_toss | next_preamble] = preamble
      check_data(next_preamble ++ [number], rem_data)
    end
  end

  # got to the end of the preamble with no matches
  defp valid_xmas_number?([], _number) do
    false
  end

  defp valid_xmas_number?([first | rem_preamble], check_number) do
    check_list = for n <- rem_preamble, do: n + first
    # IO.puts("#{first}, #{inspect(check_list)}, #{check_number}")
    if Enum.member?(check_list, check_number) do
      # valid number
      true
    else
      # keep looking
      valid_xmas_number?(rem_preamble, check_number)
    end
  end
end
