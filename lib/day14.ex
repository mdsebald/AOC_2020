defmodule Day14 do
  use Bitwise

  @moduledoc """
  --- Day 14: Docking Data ---
  """

  @doc """
  --- Part One ---

  As your ferry approaches the sea port, the captain asks for your help again.
  The computer system that runs this port isn't compatible with the docking program on the ferry,
  so the docking parameters aren't being correctly initialized in the docking program's memory.

  After a brief inspection, you discover that the sea port's computer system uses a strange bitmask system in its initialization program.
  Although you don't have the correct decoder chip handy, you can emulate it in software!

  The initialization program (your puzzle input) can either update the bitmask or write a value to memory.
  Values and memory addresses are both 36-bit unsigned integers.
  For example, ignoring bitmasks for a moment, a line like mem[8] = 11 would write the value 11 to memory address 8.

  The bitmask is always given as a string of 36 bits,
  written with the most significant bit (representing 2^35) on the left and the least significant bit (2^0, that is, the 1s bit) on the right.
  The current bitmask is applied to values immediately before they are written to memory: a 0 or 1 overwrites the corresponding bit in the value,
  while an X leaves the bit in the value unchanged.

  For example, consider the following program:

  mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  mem[8] = 11
  mem[7] = 101
  mem[8] = 0
  This program starts by specifying a bitmask (mask = ....). The mask it specifies will overwrite two bits in every written value:
  the 2s bit is overwritten with 0, and the 64s bit is overwritten with 1.

  The program then attempts to write the value 11 to memory address 8.
  By expanding everything out to individual bits, the mask is applied as follows:

  value:  000000000000000000000000000000001011  (decimal 11)
  mask:   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  result: 000000000000000000000000000001001001  (decimal 73)
  So, because of the mask, the value 73 is written to memory address 8 instead. Then, the program tries to write 101 to address 7:

  value:  000000000000000000000000000001100101  (decimal 101)
  mask:   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  result: 000000000000000000000000000001100101  (decimal 101)
  This time, the mask has no effect, as the bits it overwrote were already the values the mask tried to set.
  Finally, the program tries to write 0 to address 8:

  value:  000000000000000000000000000000000000  (decimal 0)
  mask:   XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
  result: 000000000000000000000000000001000000  (decimal 64)
  64 is written to address 8 instead, overwriting the value that was there previously.

  To initialize your ferry's docking program, you need the sum of all values left in memory after the initialization program completes.
  (The entire 36-bit address space begins initialized to the value 0 at every address.)
  In the above example, only two values in memory are not zero - 101 (at address 7) and 64 (at address 8) - producing a sum of 165.

  Execute the initialization program. What is the sum of all values left in memory after it completes?
  """

  def mem_sum_after_init_1 do
    # "inputs/day14_test1_input.txt")
    {processed_instr, _last_mask} =
      get_init_program()
      |> Enum.map_reduce([], fn instr, mask -> process_instr_1(instr, mask) end)

    addr_vals =
      processed_instr
      |> Enum.reduce(%{}, fn instr, addr_values ->
        Map.put(addr_values, instr[:addr], instr[:value])
      end)

    addr_vals
    |> Map.keys()
    |> Enum.reject(fn addr -> addr == nil end)
    |> Enum.reduce(0, fn addr, sum -> sum + addr_vals[addr] end)
  end

  defp process_instr_1(instr, mask) do
    case Map.has_key?(instr, :mask) do
      true ->
        {instr, instr[:mask]}

      # if not a mask instruction, must be addr/value instruction
      false ->
        {_value, instr} = Map.get_and_update(instr, :value, &apply_mask(&1, mask))
        {instr, mask}
    end
  end

  defp apply_mask(value, mask) do
    # Remember we reversed bit order of mask (LSB is first, from the left)
    {_mult, masked_value} =
      mask
      |> Enum.reduce({1, value}, fn mask_x, {mult, curr_value} ->
        case mask_x do
          ?X ->
            {2 * mult, curr_value}

          ?0 ->
            if (curr_value &&& mult) == mult do
              {2 * mult, curr_value ^^^ mult}
            else
              {2 * mult, curr_value}
            end

          ?1 ->
            if (curr_value &&& mult) == mult do
              {2 * mult, curr_value}
            else
              {2 * mult, curr_value ||| mult}
            end
        end
      end)

    # IO.puts("#{mask}, #{value}, #{masked_value}")
    {value, masked_value}
  end

  @doc """
  --- Part Two ---

  For some reason, the sea port's computer system still can't communicate with your ferry's docking program.
  It must be using version 2 of the decoder chip!

  A version 2 decoder chip doesn't modify the values being written at all.
  Instead, it acts as a memory address decoder.
  Immediately before a value is written to memory,
  each bit in the bitmask modifies the corresponding bit of the destination memory address in the following way:

  If the bitmask bit is 0, the corresponding memory address bit is unchanged.
  If the bitmask bit is 1, the corresponding memory address bit is overwritten with 1.
  If the bitmask bit is X, the corresponding memory address bit is floating.
  A floating bit is not connected to anything and instead fluctuates unpredictably.
  In practice, this means the floating bits will take on all possible values,
  potentially causing many memory addresses to be written all at once!

  For example, consider the following program:

  mask = 000000000000000000000000000000X1001X
  mem[42] = 100
  mask = 00000000000000000000000000000000X0XX
  mem[26] = 1
  When this program goes to write to memory address 42, it first applies the bitmask:

  address: 000000000000000000000000000000101010  (decimal 42)
  mask:    000000000000000000000000000000X1001X
  result:  000000000000000000000000000000X1101X
  After applying the mask, four bits are overwritten, three of which are different, and two of which are floating.
  Floating bits take on every possible combination of values; with two floating bits, four actual memory addresses are written:

  000000000000000000000000000000011010  (decimal 26)
  000000000000000000000000000000011011  (decimal 27)
  000000000000000000000000000000111010  (decimal 58)
  000000000000000000000000000000111011  (decimal 59)
  Next, the program is about to write to memory address 26 with a different bitmask:

  address: 000000000000000000000000000000011010  (decimal 26)
  mask:    00000000000000000000000000000000X0XX
  result:  00000000000000000000000000000001X0XX
  This results in an address with three floating bits, causing writes to eight memory addresses:

  000000000000000000000000000000010000  (decimal 16)
  000000000000000000000000000000010001  (decimal 17)
  000000000000000000000000000000010010  (decimal 18)
  000000000000000000000000000000010011  (decimal 19)
  000000000000000000000000000000011000  (decimal 24)
  000000000000000000000000000000011001  (decimal 25)
  000000000000000000000000000000011010  (decimal 26)
  000000000000000000000000000000011011  (decimal 27)
  The entire 36-bit address space still begins initialized to the value 0 at every address,
  and you still need the sum of all values left in memory at the end of the program. In this example, the sum is 208.

  Execute the initialization program using an emulator for a version 2 decoder chip.
  What is the sum of all values left in memory after it completes?
  """
  def mem_sum_after_init_2 do
    {addr_vals, _mask} =
      get_init_program()
      |> Enum.reduce({%{}, []}, fn instr, {addr_vals, mask} ->
        process_instr_2(instr, addr_vals, mask)
      end)

    addr_vals
    |> Map.keys()
    |> Enum.reject(fn addr -> addr == nil end)
    |> Enum.reduce(0, fn addr, sum -> sum + addr_vals[addr] end)
  end

  defp process_instr_2(instr, addr_vals, mask) do
    case Map.has_key?(instr, :mask) do
      true ->
        {addr_vals, instr[:mask]}

      # if not a mask instruction, must be addr/value instruction
      false ->
        addr_vals =
          apply_mask_2(instr[:addr], mask)
          |> Enum.reduce(addr_vals, fn addr, addr_vals ->
            Map.put(addr_vals, addr, instr[:value])
          end)

        {addr_vals, mask}
    end
  end

  # Return list of addresses to update with this instruction's value
  defp apply_mask_2(addr, mask) do
    # Remember we reversed bit order of mask (LSB is first, from the left)
    # first modifiy the original address, if needed
    {_mult, mod_addr} =
      mask
      |> Enum.reduce({1, addr}, fn mask_x, {mult, curr_addr} ->
        case mask_x do
          ?X -> {2 * mult, curr_addr}
          ?0 -> {2 * mult, curr_addr}
          ?1 -> {2 * mult, curr_addr ||| mult}
        end
      end)

    # then generate the list of affected addresses
    affected_addrs = gen_addrs(mask, 1, [mod_addr])
    # IO.puts("#{mask}, #{addr}, #{mod_addr}, #{inspect(affected_addrs)}")
    affected_addrs
  end

  defp gen_addrs([], _mult, mod_addrs), do: mod_addrs

  defp gen_addrs([mask_x | rem_mask], mult, mod_addrs) do
    case mask_x do
      # We have a wild card,
      # double the address list and
      # vary the new set of address at the current mask position (i.e. mult)
      ?X ->
        new_addrs =
          Enum.map(mod_addrs, fn new_addr ->
            if (new_addr &&& mult) == mult do
              new_addr ^^^ mult
            else
              new_addr ||| mult
            end
          end)

        gen_addrs(rem_mask, 2 * mult, mod_addrs ++ new_addrs)

      ?0 ->
        gen_addrs(rem_mask, 2 * mult, mod_addrs)

      ?1 ->
        gen_addrs(rem_mask, 2 * mult, mod_addrs)
    end
  end

  # Common functions

  defp get_init_program(input \\ "inputs/day14_input.txt") do
    File.read!(input)
    |> String.split("\n")
    |> Enum.reject(fn instr -> instr == "" end)
    |> Enum.map(&parse_instr/1)
  end

  defp parse_instr(instr) do
    Regex.named_captures(
      ~r/^(mask = (?'mask'[0,1,X]{36}))|(mem\[(?'addr'[0-9]{1,11})\] = (?'value'[0-9]{1,11}))$/,
      instr
    )
    |> Enum.reject(fn {_key_str, value_str} -> value_str == "" end)
    |> Map.new(fn {key_str, value_str} ->
      key = String.to_atom(key_str)

      case key do
        # Reverse mask so LSB is first
        :mask -> {:mask, Enum.reverse(String.to_charlist(value_str))}
        # Address or Value
        _ -> {key, String.to_integer(value_str)}
      end
    end)
  end
end
