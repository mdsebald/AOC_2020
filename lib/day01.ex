defmodule Day01 do

  @moduledoc """
  Documentation for `Day01`.
  """

  @doc """
  Part 1

  Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input);
  apparently, something isn't quite adding up.

  Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

  For example, suppose your expense report contained the following:

  1721
  979
  366
  299
  675
  1456
  In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579,
  so the correct answer is 514579.

  Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?
  """
  def fix_expense_report_1 do
    get_expense_list()
    |> find_2020_exp_pair
  end

  defp find_2020_exp_pair([_last_exp]) do
    IO.puts("No 2020 expense pair detected\n")
  end

  defp find_2020_exp_pair([first_exp | rem_exps]) do
    # Add the first expense to each remaining expense in the list.
    # Return true if it equals 2020
    # Doesn't hurt if more than one expense pair equals 2020.
    # It just uses the first expense that matches
    exps_2020_list = Enum.filter(rem_exps, fn second_exp -> (first_exp + second_exp) == 2020 end)
    if (length(exps_2020_list) >= 1) do
      IO.puts("First: #{first_exp} Second: #{List.first(exps_2020_list)}")
      # return the product of the two expenses that add up to 2020
      (first_exp * List.first(exps_2020_list))
    else # keep looking
      find_2020_exp_pair(rem_exps)
    end
  end

  @doc """
  Part 2

  Find three numbers in your expense report that meet the same criteria.

  Using the above example again, the three entries that sum to 2020 are 979, 366, and 675.
  Multiplying them together produces the answer, 241861950.

  In your expense report, what is the product of the three entries that sum to 2020?
  """
  def fix_expense_report_2 do
    get_expense_list()
    |> find_2020_exp_triplet
  end

  defp find_2020_exp_triplet(exps_list) when length(exps_list) <= 2 do
    IO.puts("No 2020 expense triplet detected")
  end

  defp find_2020_exp_triplet([first_exp | rem_exps]) do
    result = sum_first_with_next_pairs(first_exp, rem_exps)
    if (result > 0) do
      result
    else # keep looking
      find_2020_exp_triplet(rem_exps)
    end
  end

  defp sum_first_with_next_pairs(_first_exp, [_last_exp]) do
    0
  end

  defp sum_first_with_next_pairs(first_exp, [second_exp | rem_exps]) do
    exps_2020_list = Enum.filter(rem_exps, fn third_exp -> (first_exp + second_exp + third_exp) == 2020 end)
    if (length(exps_2020_list) >= 1) do
      IO.puts("First: #{first_exp} Second: #{second_exp} Third: #{List.first(exps_2020_list)}")
      # return the product of the three expenses that add up to 2020
      (first_exp * second_exp * List.first(exps_2020_list))
    else # keep looking.
      sum_first_with_next_pairs(first_exp, rem_exps)
    end
  end

  defp get_expense_list do
    File.read!("day01_input.txt")
    |> String.split
    |> Enum.map(&String.to_integer/1)
    # Don't think AOC committee would give us bad data, but doesn't hurt to check
    |> Enum.filter(fn exp -> ((0 <= exp) && (exp <= 2020)) end)
  end
end
