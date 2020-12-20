defmodule Day18 do
  @moduledoc """
  --- Day 18: Operation Order ---
  """

  @doc """
  --- Part One ---

  As you look out the window and notice a heavily-forested continent slowly appear over the horizon,
  you are interrupted by the child sitting next to you. They're curious if you could help them with their math homework.

  Unfortunately, it seems like this "math" follows different rules than you remember.

  The homework (your puzzle input) consists of a series of expressions that consist of addition (+), multiplication (*), and parentheses ((...)).
  Just like normal math, parentheses indicate that the expression inside must be evaluated before it can be used by the surrounding expression.
  Addition still finds the sum of the numbers on both sides of the operator, and multiplication still finds the product.

  However, the rules of operator precedence have changed. Rather than evaluating multiplication before addition,
  the operators have the same precedence, and are evaluated left-to-right regardless of the order in which they appear.

  For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are as follows:

  ((((1 + 2) * 3) + 4) * 5) + 6
  1 + 2 * 3 + 4 * 5 + 6
    3   * 3 + 4 * 5 + 6
        9   + 4 * 5 + 6
          13   * 5 + 6
              65   + 6
                  71
  Parentheses can override this order; for example,
  here is what happens if parentheses are added to form 1 + (2 * 3) + (4 * (5 + 6)):

  1 + (2 * 3) + (4 * (5 + 6))
  1 + (2 * 3) + (4 * (5 + 6))
  1 +    6    + (4 * (5 + 6))
      7      + (4 * (5 + 6))
      7      + (4 *   11   )
      7      +     44
              51
  Here are a few more examples:

  2 * 3 + (4 * 5) becomes 26.
  5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 437.
  5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 12240.
  ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 13632.
  Before you can help with the homework, you need to understand it yourself.
  Evaluate the expression on each line of the homework; what is the sum of the resulting values?

    (9 + 2) * ((7 + 9 + 5 + 7) * 3 + (5 * 3 * 6 * 5 + 6) + (9 * 4 + 9 * 6 + 9)) * 8 + 5
    11 * (28 * 3 + 456 + 279) * 8 + 5
    11 * 819 * 8 + 5
    72077
  """

  # Copied solution from "faried" https://elixirforum.com/t/advent-of-code-2020-day-18/36300/6

  def evaluate_expressions_1 do
    get_expressions()
    |> Enum.reduce(0, fn line, acc -> acc + parse(line, &eval1/2) end)
  end

  def eval1(terms, op, out \\ 0)

  def eval1([], _, out), do: out

  def eval1([number | rest], :add, out), do: eval1(rest, nil, number + out)
  def eval1([number | rest], :mult, out), do: eval1(rest, nil, number * out)

  def eval1([term | rest], nil, out) do
    case term do
      :add -> eval1(rest, :add, out)
      :mult -> eval1(rest, :mult, out)
      _ -> eval1(rest, nil, term)
    end
  end

  @doc """
  --- Part Two ---
  You manage to answer the child's questions and they finish part 1 of their homework,
  but get stuck when they reach the next section: advanced math.

  Now, addition and multiplication have different precedence levels, but they're not the ones you're familiar with.
  Instead, addition is evaluated before multiplication.

  For example, the steps to evaluate the expression 1 + 2 * 3 + 4 * 5 + 6 are now as follows:

  1 + 2 * 3 + 4 * 5 + 6
    3   * 3 + 4 * 5 + 6
    3   *   7   * 5 + 6
    3   *   7   *  11
      21       *  11
          231
  Here are the other examples from above:

  1 + (2 * 3) + (4 * (5 + 6)) still becomes 51.
  2 * 3 + (4 * 5) becomes 46.
  5 + (8 * 3 + 9 + 3 * 4 * 3) becomes 1445.
  5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) becomes 669060.
  ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 becomes 23340.
  What do you get if you add up the results of evaluating the homework problems using these new rules?
  """
  def evaluate_expressions_2 do
    get_expressions()
    |> Enum.reduce(0, fn line, acc -> acc + parse(line, &eval2/2) end)
  end

  defp eval2(terms, op, out \\ [])

  defp eval2([], _, out), do: mult(out)

  defp eval2([term | rest], :add, [first | left]) do
    eval2(rest, nil, [mult(first) + mult(term) | left])
  end

  defp eval2([term | rest], nil, left) do
    case term do
      :add -> eval2(rest, :add, left)
      _ -> eval2(rest, nil, [term | left])
    end
  end

  # Common functions

  defp get_expressions(input \\ "inputs/day18_input.txt") do
    File.read!(input)
    |> String.replace("(", "( ")
    |> String.replace(")", " )")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  defp parse(input, evalfn, result \\ [])

  defp parse([], evalfn, result), do: evalfn.(Enum.reverse(result), nil)

  defp parse(["+" | rest], evalfn, result), do: parse(rest, evalfn, [:add | result])
  defp parse(["*" | rest], evalfn, result), do: parse(rest, evalfn, [:mult | result])

  defp parse(["(" | rest], evalfn, result) do
    {unprocessed, inner} = parse(rest, evalfn)
    parse(unprocessed, evalfn, [inner | result])
  end

  defp parse([")" | rest], evalfn, result) do
    {rest, evalfn.(Enum.reverse(result), nil)}
  end

  defp parse([term | rest], evalfn, result),
    do: parse(rest, evalfn, [String.to_integer(term) | result])

  defp mult(thing) when is_number(thing), do: thing

  defp mult(thing) when is_list(thing) do
    Enum.reject(thing, &(&1 == :mult))
    |> Enum.reduce(1, &Kernel.*/2)
  end
end
