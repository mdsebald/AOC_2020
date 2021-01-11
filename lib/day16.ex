defmodule Day16 do
  @moduledoc """
  --- Day 16: Ticket Translation ---
  """

  @doc """
  --- Part One ---

  As you're walking to yet another connecting flight, you realize that one of
  the legs of your re-routed trip coming up is on a high-speed train.
  However, the train ticket you were given is in a language you don't
  understand. You should probably figure out what it says before you get to
  the train station after the next flight.

  Unfortunately, you can't actually read the words on the ticket. You can,
  however, read the numbers, and so you figure out the fields these tickets
  must have and the valid ranges for values in those fields.

  You collect the rules for ticket fields, the numbers on your ticket, and
  the numbers on other nearby tickets for the same train service (via the
  airport security cameras) together into a single document you can reference
  (your puzzle input).

  The rules for ticket fields specify a list of fields that exist somewhere
  on the ticket and the valid ranges of values for each field. For example, a
  rule like class: 1-3 or 5-7 means that one of the fields in every ticket is
  named class and can be any value in the ranges 1-3 or 5-7 (inclusive, such
  that 3 and 5 are both valid in this field, but 4 is not).

  Each ticket is represented by a single line of comma-separated values. The
  values are the numbers on the ticket in the order they appear; every ticket
  has the same format. For example, consider this ticket:

  .--------------------------------------------------------.
  | ????: 101    ?????: 102   ??????????: 103     ???: 104 |
  |                                                        |
  | ??: 301  ??: 302             ???????: 303      ??????? |
  | ??: 401  ??: 402           ???? ????: 403    ????????? |
  '--------------------------------------------------------'

  Here, ? represents text in a language you don't understand. This ticket
  might be represented as 101,102,103,104,301,302,303,401,402,403; of course,
  the actual train tickets you're looking at are much more complicated. In
  any case, you've extracted just the numbers in such a way that the first
  number is always the same specific field, the second number is always a
  different specific field, and so on - you just don't know what each
  position actually means!

  Start by determining which tickets are completely invalid; these are
  tickets that contain values which aren't valid for any field. Ignore your
  ticket for now.

  For example, suppose you have the following notes:

  class: 1-3 or 5-7
  row: 6-11 or 33-44
  seat: 13-40 or 45-50

  your ticket:
  7,1,14

  nearby tickets:
  7,3,47
  40,4,50
  55,2,20
  38,6,12

  It doesn't matter which position corresponds to which field; you can
  identify invalid nearby tickets by considering only whether tickets contain
  values that are not valid for any field. In this example, the values on the
  first nearby ticket are all valid for at least one field. This is not true
  of the other three nearby tickets: the values 4, 55, and 12 are are not
  valid for any field. Adding together all of the invalid values produces
  your ticket scanning error rate: 4 + 55 + 12 = 71.

  Consider the validity of the nearby tickets you scanned. What is your
  ticket scanning error rate?

  Your puzzle answer was 26988.
  """

  def calc_ticket_scan_error_rate do
    {fields, _your_ticket, nearby_tickets} = get_tickets()
    {{lowest_lo, highest_lo}, {lowest_hi, highest_hi}} = get_valid_ranges(fields)

    # IO.puts("{{#{lowest_lo}, #{highest_lo}}, {#{lowest_hi}, #{highest_hi}}}")

    nearby_tickets
    |> Enum.reduce(0, fn ticket, tickets_error_sum ->
      Enum.reduce(ticket, tickets_error_sum, fn ticket_field, ticket_error_sum ->
        if(
          (lowest_lo <= ticket_field && ticket_field <= highest_lo) ||
            (lowest_hi <= ticket_field && ticket_field <= highest_hi)
        ) do
          ticket_error_sum
        else
          # IO.puts("Invalid: #{ticket_field}")
          ticket_error_sum + ticket_field
        end
      end)
    end)
  end

  @doc """
  --- Part Two ---

  Now that you've identified which tickets contain invalid values, discard
  those tickets entirely. Use the remaining valid tickets to determine which
  field is which.

  Using the valid ranges for each field, determine what order the fields
  appear on the tickets. The order is consistent between all tickets: if seat
  is the third field, it is the third field on every ticket, including your
  ticket.

  For example, suppose you have the following notes:

  class: 0-1 or 4-19
  row: 0-5 or 8-19
  seat: 0-13 or 16-19

  your ticket:
  11,12,13

  nearby tickets:
  3,9,18
  15,1,5
  5,14,9

  Based on the nearby tickets in the above example, the first position must
  be row, the second position must be class, and the third position must be
  seat; you can conclude that in your ticket, class is 12, row is 11, and
  seat is 13.

  Once you work out which field is which, look for the six fields on your
  ticket that start with the word departure. What do you get if you multiply
  those six values together?

  Your puzzle answer was 426362917709.
  """

  def mult_your_ticket_departure_fields do
    {fields, your_ticket, nearby_tickets} = get_tickets()
    valid_ranges = get_valid_ranges(fields)

    # Delete invalid tickets
    valid_tickets = Enum.filter(nearby_tickets, &valid_ticket?(&1, valid_ranges))

    # Generate a list of valid field IDs for each ticket value position
    valid_field_ids_list =
      Enum.reduce(0..19, [], fn idx, valid_field_ids_list ->
        List.insert_at(
          valid_field_ids_list,
          idx,
          Enum.reduce(valid_tickets, Map.keys(fields), fn ticket, valid_field_ids ->
            filter_field_ids(valid_field_ids, fields, Enum.at(ticket, idx))
          end)
        )
      end)

    # By the process of elimination, narrow down the list of valid field ids
    # for each ticket value position, to one valid field id per position
    # IO.puts("#{inspect(valid_field_ids_list)}")
    reduce_valid_field_ids(valid_field_ids_list, [])
    |> mult_depart_fields(your_ticket)
  end

  defp mult_depart_fields(field_id_to_pos, ticket) do
    Enum.filter(field_id_to_pos, fn {field_id, _position} ->
      String.starts_with?(field_id, "departure")
    end)
    |> Enum.map(fn {_field_id, position} ->
      Enum.at(ticket, position)
    end)
    |> Enum.reduce(1, fn ticket_value, prod -> ticket_value * prod end)
  end

  defp reduce_valid_field_ids([], field_to_pos), do: field_to_pos

  defp reduce_valid_field_ids(valid_field_ids_list, field_id_to_pos) do
    result =
      Enum.filter(valid_field_ids_list, fn valid_field_ids ->
        # IO.puts("#{length(valid_field_ids)}, #{inspect(valid_field_ids)}")
        length(valid_field_ids) == 1 && !already_found?(field_id_to_pos, valid_field_ids)
      end)

    case result do
      [] ->
        field_id_to_pos

      [[field_id]] ->
        # IO.puts("Key field ID: #{inspect(field_id)}")

        # Need to know the the ticket value position this field ID maps to
        position = Enum.find_index(valid_field_ids_list, &(&1 == [field_id]))

        # Delete the field ID just found, from all of the other lists of valid field IDs.
        # It's already used in another position
        next_valid_field_ids_list =
          Enum.map(valid_field_ids_list, fn valid_field_ids ->
            if length(valid_field_ids) > 1 do
              List.delete(valid_field_ids, field_id)
            else
              valid_field_ids
            end
          end)

        # IO.puts("#{inspect(next_valid_field_ids_list)}")
        reduce_valid_field_ids(next_valid_field_ids_list, [{field_id, position} | field_id_to_pos])
    end
  end

  defp already_found?(field_id_to_pos, [chk_field_id]) do
    found =
      Enum.filter(field_id_to_pos, fn {field_id, _postion} ->
        field_id == chk_field_id
      end)

    length(found) > 0
  end

  defp filter_field_ids(field_ids, fields, ticket_val) do
    # Remove field ids from the field id list,
    # where the ticket value is not in the range of the field ID
    Enum.reject(field_ids, &invalid_value?(&1, fields, ticket_val))
  end

  defp invalid_value?(field_id, fields, value) do
    {{lo_lo, lo_hi}, {hi_lo, hi_hi}} = Map.get(fields, field_id)
    value < lo_lo || (lo_hi < value && value < hi_lo) || hi_hi < value
  end

  # Common functions

  defp get_tickets(input \\ "inputs/day16_input.txt") do
    [ticket_fields_str, your_ticket_str, nearby_tickets_str] =
      File.read!(input)
      |> String.split(["your ticket:", "nearby tickets:"], trim: true)

    {
      parse_ticket_fields(ticket_fields_str),
      parse_ticket(your_ticket_str),
      parse_tickets(nearby_tickets_str)
    }
  end

  defp parse_ticket_fields(ticket_fields_str) do
    String.split(ticket_fields_str, "\n", trim: true)
    |> Enum.map(fn ticket_field_str ->
      Regex.named_captures(
        ~r/^(?'field_id'[a-z ]+): (?'lo_lo'[0-9]{2,3})-(?'lo_hi'[0-9]{2,3}) or (?'hi_lo'[0-9]{2,3})-(?'hi_hi'[0-9]{2,3})$/,
        ticket_field_str
      )
    end)
    |> Enum.reduce(%{}, fn raw_field, parsed_field ->
      field_id = raw_field["field_id"]

      # Field value ranges looks like this: {{lo_lo, lo_hi}, {hi_lo, hi_hi}}
      lo_lo = String.to_integer(raw_field["lo_lo"])
      lo_hi = String.to_integer(raw_field["lo_hi"])
      hi_lo = String.to_integer(raw_field["hi_lo"])
      hi_hi = String.to_integer(raw_field["hi_hi"])
      Map.put(parsed_field, field_id, {{lo_lo, lo_hi}, {hi_lo, hi_hi}})
    end)
  end

  defp parse_tickets(ticket_strs) do
    String.split(ticket_strs, "\n", trim: true)
    |> Enum.map(&parse_ticket/1)
  end

  defp parse_ticket(ticket_str) do
    String.split(ticket_str, [",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp get_valid_ranges(fields) do
    Map.keys(fields)
    |> Enum.reduce({{9999, 0}, {9999, 0}}, fn field_id,
                                              {{lowest_lo, highest_lo}, {lowest_hi, highest_hi}} ->
      {{lo_lo, lo_hi}, {hi_lo, hi_hi}} = Map.get(fields, field_id)

      {{min(lowest_lo, lo_lo), max(highest_lo, lo_hi)},
       {min(lowest_hi, hi_lo), max(highest_hi, hi_hi)}}
    end)
  end

  defp valid_ticket?(ticket, {{lowest_lo, highest_lo}, {lowest_hi, highest_hi}}) do
    Enum.reduce_while(ticket, true, fn ticket_field, _valid ->
      if(
        (lowest_lo <= ticket_field && ticket_field <= highest_lo) ||
          (lowest_hi <= ticket_field && ticket_field <= highest_hi)
      ) do
        {:cont, true}
      else
        {:halt, false}
      end
    end)
  end
end
