defmodule Day15 do
  @moduledoc """
  --- Day 15: Rambunctious Recitation ---
  """

  @doc """
  --- Part One ---

  You catch the airport shuttle and try to book a new flight to your vacation
  island. Due to the storm, all direct flights have been cancelled, but a
  route is available to get around the storm. You take it.

  While you wait for your flight, you decide to check in with the Elves back
  at the North Pole. They're playing a memory game and are ever so excited to
  explain the rules!

  In this game, the players take turns saying numbers. They begin by taking
  turns reading from a list of starting numbers (your puzzle input). Then,
  each turn consists of considering the most recently spoken number:

    - If that was the first time the number has been spoken, the current \
      player says 0.
    - Otherwise, the number had been spoken before; the current player
      announces how many turns apart the number is from when it was
      previously spoken.

  So, after the starting numbers, each turn results in that player speaking
  aloud either 0 (if the last number is new) or an age (if the last number is
  a repeat).

  For example, suppose the starting numbers are 0,3,6:

    - Turn 1: The 1st number spoken is a starting number, 0.
    - Turn 2: The 2nd number spoken is a starting number, 3.
    - Turn 3: The 3rd number spoken is a starting number, 6.
    - Turn 4: Now, consider the last number spoken, 6. Since that was the
      first time the number had been spoken, the 4th number spoken is 0.
    - Turn 5: Next, again consider the last number spoken, 0. Since it had
      been spoken before, the next number to speak is the difference between
      the turn number when it was last spoken (the previous turn, 4) and the
      turn number of the time it was most recently spoken before then (turn
      1). Thus, the 5th number spoken is 4 - 1, 3.
    - Turn 6: The last number spoken, 3 had also been spoken before, most
      recently on turns 5 and 2. So, the 6th number spoken is 5 - 2, 3.
    - Turn 7: Since 3 was just spoken twice in a row, and the last two turns
      are 1 turn apart, the 7th number spoken is 1.
    - Turn 8: Since 1 is new, the 8th number spoken is 0.
    - Turn 9: 0 was last spoken on turns 8 and 4, so the 9th number spoken
      is the difference between them, 4.
    - Turn 10: 4 is new, so the 10th number spoken is 0.

  (The game ends when the Elves get sick of playing or dinner is ready,
  whichever comes first.)

  Their question for you is: what will be the 2020th number spoken? In the
  example above, the 2020th number spoken will be 436.

  Here are a few more examples:

     - Given the starting numbers 1,3,2, the 2020th number spoken is 1.
     - Given the starting numbers 2,1,3, the 2020th number spoken is 10.
     - Given the starting numbers 1,2,3, the 2020th number spoken is 27.
     - Given the starting numbers 2,3,1, the 2020th number spoken is 78.
     - Given the starting numbers 3,2,1, the 2020th number spoken is 438.
     - Given the starting numbers 3,1,2, the 2020th number spoken is 1836.

  Given your starting numbers, what will be the 2020th number spoken?

  Your puzzle answer was 852.
  """

  def get_2020th_num_spoken(input \\ [0, 3, 1, 6, 7, 5]) do
    input
    # Make the 1st element of the spoken numbers, the last number spoken
    |> Enum.reverse()
    # Start the next turn after "speaking" the input numbers
    |> speak(length(input))
  end

  defp speak(spoken, turn) do
    [last_num | rem_spoke] = spoken

    if turn == 2020 do
      last_num
    else
      # IO.puts("#{inspect(Enum.find_index(rem_spoke, &(&1 == last_num)))}")
      case Enum.find_index(rem_spoke, &(&1 == last_num)) do
        # first time last number was spoken
        # next number is zero
        nil ->
          speak([0 | spoken], turn + 1)

        index ->
          # convert the index into the last turn this number was spoken
          last_turn_spoken = turn - 1 - index
          next_num = turn - last_turn_spoken
          speak([next_num | spoken], turn + 1)
      end
    end
  end

  @doc """
  --- Part Two ---

  Impressed, the Elves issue you a challenge: determine the 30000000th number
  spoken. For example, given the same starting numbers as above:

    - Given 0,3,6, the 30000000th number spoken is 175594.
    - Given 1,3,2, the 30000000th number spoken is 2578.
    - Given 2,1,3, the 30000000th number spoken is 3544142.
    - Given 1,2,3, the 30000000th number spoken is 261214.
    - Given 2,3,1, the 30000000th number spoken is 6895259.
    - Given 3,2,1, the 30000000th number spoken is 18.
    - Given 3,1,2, the 30000000th number spoken is 362.

  Given your starting numbers, what will be the 30000000th number spoken?

  Your puzzle answer was 6007666.
  """

  def get_30_000_000th_num_spoken(input \\ [0, 3, 1, 6, 7, 5]) do
    stream(input, 30_000_000)
  end

  # Copied solution from LostKobrakai https://github.com/LostKobrakai/aoc2020/blob/master/lib/aoc2020/day15.ex

  defp stream(starting_numbers, index) do
    Stream.unfold(
      %{
        turn: 0,
        start: starting_numbers,
        last_spoken: nil,
        last_spoken_at: %{}
      },
      fn
        %{start: [speak | rest]} = state ->
          state = Map.put(state, :start, rest)
          state = Map.put(state, :last_spoken, speak)
          state = update_last_spoken(state, speak)
          {speak, inc_turn(state)}

        state ->
          speak =
            case Map.fetch(state.last_spoken_at, state.last_spoken) do
              {:ok, [a, b | _]} -> a - b
              _ -> 0
            end

          state = Map.put(state, :last_spoken, speak)
          state = update_last_spoken(state, speak)
          {speak, inc_turn(state)}
      end
    )
    # |> Enum.map(&IO.inspect/1)
    |> Enum.at(index - 1)
  end

  defp inc_turn(state) do
    Map.update!(state, :turn, &(&1 + 1))
  end

  defp update_last_spoken(state, speak) do
    Map.update!(state, :last_spoken_at, fn map ->
      Map.update(map, speak, [state.turn], fn [last | _] ->
        [state.turn, last]
      end)
    end)
  end
end
