defmodule Day02 do
  @moduledoc """
  --- Day 2: Password Philosophy ---
  """

  @doc """
  --- Part One ---

  The Official Toboggan Corporate Password Policy

  Each policy actually describes two positions in the password, where 1 means the first character, 2 means the second character, and so on.
  (Be careful; Toboggan Corporate Policies have no concept of "index zero"!)
  Exactly one of these positions must contain the given letter. Other occurrences of the letter are irrelevant for the purposes of policy enforcement.

  Given the same example list from above:

  1-3 a: abcde is valid: position 1 contains a and position 3 does not.
  1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
  2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.
  """
  def count_valid_toboggan_passwords do
    File.read!("day02_input.txt")
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.reduce(0, fn policy_password, valid_cnt ->
      if valid_toboggan_password?(policy_password) do
        valid_cnt + 1
      else
        valid_cnt
      end
    end)
  end

  defp valid_toboggan_password?([]), do: false

  defp valid_toboggan_password?([repeat_range, pw_char_str, password])
       when is_binary(repeat_range) and is_binary(pw_char_str) and is_binary(password) do
    case parse_repeat_range(repeat_range) do
      {first_position, second_position} ->
        pw_char = parse_pw_char(pw_char_str)
        # normalize to zero based index
        first_match = pw_char == String.at(password, first_position - 1)
        second_match = pw_char == String.at(password, second_position - 1)

        if (first_match && !second_match) || (!first_match && second_match) do
          true
        else
          false
        end

      _error ->
        print_error("Error parsing repeat range")
    end
  end

  defp valid_toboggan_password?(policy_password) do
    print_error("Invalid policy and password group: #{policy_password}")
    false
  end

  @doc """
  --- Part Two ---

  Old Sled Rental Password Policy

  To try to debug the problem, they have created a list (your puzzle input) of passwords (according to the corrupted database) and the corporate policy when that password was set.

  For example, suppose you have the following list:

  1-3 a: abcde
  1-3 b: cdefg
  2-9 c: ccccccccc
  Each line gives the password policy and then the password.
  The password policy indicates the lowest and highest number of times a given letter must appear for the password to be valid.
  For example, 1-3 a means that the password must contain a at least 1 time and at most 3 times.

  In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains no instances of b, but needs at least 1. The first and third passwords are valid: they contain one a or nine c, both within the limits of their respective policies.
  """
  def count_valid_sled_passwords do
    File.read!("day02_input.txt")
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.reduce(0, fn policy_password, valid_cnt ->
      if valid_sled_password?(policy_password) do
        valid_cnt + 1
      else
        valid_cnt
      end
    end)
  end

  defp valid_sled_password?([]), do: false

  defp valid_sled_password?([repeat_range, pw_char_str, password])
       when is_binary(repeat_range) and is_binary(pw_char_str) and is_binary(password) do
    case parse_repeat_range(repeat_range) do
      {min_repeat, max_repeat} ->
        pw_char = parse_pw_char(pw_char_str)
        pw_char_count = count_pw_chars(password, pw_char)

        if min_repeat <= pw_char_count && pw_char_count <= max_repeat do
          true
        else
          false
        end

      _error ->
        print_error("Error parsing repeat range")
    end
  end

  defp valid_sled_password?(policy_password) do
    print_error("Invalid policy and password group: #{policy_password}")
    false
  end

  defp parse_repeat_range(repeat_range) do
    case String.split(repeat_range, "-") do
      [min_repeat_str, max_repeat_str] ->
        case parse_repeat_val(min_repeat_str) do
          {:ok, min_repeat} ->
            case parse_repeat_val(max_repeat_str) do
              {:ok, max_repeat} ->
                case 0 < min_repeat && min_repeat < max_repeat do
                  true ->
                    {min_repeat, max_repeat}

                  false ->
                    print_error("Invalid repeat value(s): Min: #{min_repeat} Max: #{max_repeat}")
                end

              _error ->
                print_error("Invalid max repeat range: #{repeat_range}")
            end

          _error ->
            print_error("Invalid min repeat range: #{repeat_range}")
        end

      _error ->
        print_error("Invalid repeat range format: #{repeat_range}")
    end
  end

  @spec parse_repeat_val(String.t()) :: {:ok, integer()} | :error
  defp parse_repeat_val(repeat_str) do
    repeat_val = String.to_integer(repeat_str)

    if repeat_val > 0 do
      {:ok, repeat_val}
    else
      :error
    end
  end

  defp parse_pw_char(pw_char_str) do
    String.at(String.trim(pw_char_str), 0)
  end

  defp count_pw_chars(str, pw_char) do
    str |> String.graphemes() |> Enum.count(fn c -> c == pw_char end)
  end

  @spec print_error(String.t()) :: :error
  defp print_error(error_str) do
    IO.puts(error_str)
    IO.puts("\n")
    :error
  end
end
