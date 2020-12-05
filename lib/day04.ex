defmodule Day04 do
  @moduledoc """
  --- Day 4: Passport Processing ---
  """

  @doc """
  --- Part One ---

  Detect which passports have all required fields. The expected fields are as follows:

  byr (Birth Year)
  iyr (Issue Year)
  eyr (Expiration Year)
  hgt (Height)
  hcl (Hair Color)
  ecl (Eye Color)
  pid (Passport ID)
  cid (Country ID)
  Passport data is validated in batch files (your puzzle input).
  Each passport is represented as a sequence of key:value pairs separated by spaces or newlines.
  Passports are separated by blank lines.

  Here is an example batch file containing four passports:

  ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
  byr:1937 iyr:2017 cid:147 hgt:183cm

  iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
  hcl:#cfa07d byr:1929

  hcl:#ae17e1 iyr:2013
  eyr:2024
  ecl:brn pid:760753108 byr:1931
  hgt:179cm

  hcl:#cfa07d eyr:2025 pid:166559648
  iyr:2011 ecl:brn hgt:59in
  The first passport is valid - all eight fields are present. The second passport is invalid - it is missing hgt (the Height field).

  The third passport is interesting; the only missing field is cid, so it looks like data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

  The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing any other field is not, so this passport is invalid.

  According to the above rules, your improved system would report 2 valid passports.

  Count the number of valid passports - those that have all required fields. Treat cid as optional. In your batch file, how many passports are valid?
  """
  def count_valid_passports_1 do
    get_passports()
    |> Enum.reduce(0, fn pp_map, count ->
      if valid_passport_1?(pp_map) do
        count + 1
      else
        count
      end
    end)
  end

  defp valid_passport_1?(pp_map) do
    pp_field_count = map_size(pp_map)
    pp_field_count == 8 || (pp_field_count == 7 && !Map.has_key?(pp_map, :cid))
  end

  @doc """
  --- Part Two ---

  Add some data validation.

  You can continue to ignore the cid field, but each other field has strict rules about what values are valid for automatic validation:

  byr (Birth Year) - four digits; at least 1920 and at most 2002.
  iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  hgt (Height) - a number followed by either cm or in:
  If cm, the number must be at least 150 and at most 193.
  If in, the number must be at least 59 and at most 76.
  hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  pid (Passport ID) - a nine-digit number, including leading zeroes.
  cid (Country ID) - ignored, missing or not.
  Your job is to count the passports where all required fields are both present and valid according to the above rules.
  Here are some example values:

  byr valid:   2002
  byr invalid: 2003

  hgt valid:   60in
  hgt valid:   190cm
  hgt invalid: 190in
  hgt invalid: 190

  hcl valid:   #123abc
  hcl invalid: #123abz
  hcl invalid: 123abc

  ecl valid:   brn
  ecl invalid: wat

  pid valid:   000000001
  pid invalid: 0123456789
  Here are some invalid passports:

  eyr:1972 cid:100
  hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

  iyr:2019
  hcl:#602927 eyr:1967 hgt:170cm
  ecl:grn pid:012533040 byr:1946

  hcl:dab227 iyr:2012
  ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

  hgt:59cm ecl:zzz
  eyr:2038 hcl:74454a iyr:2023
  pid:3556412378 byr:2007
  Here are some valid passports:

  pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
  hcl:#623a2f

  eyr:2029 ecl:blu cid:129 byr:1989
  iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

  hcl:#888785
  hgt:164cm byr:2001 iyr:2015 cid:88
  pid:545766238 ecl:hzl
  eyr:2022

  iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
  Count the number of valid passports - those that have all required fields and valid values. Continue to treat cid as optional.
  """
  def count_valid_passports_2 do
    get_passports()
    |> Enum.reduce(0, fn pp_map, count ->
      if valid_passport_2(pp_map) do
        count + 1
      else
        count
      end
    end)
  end

  defp get_passports do
    File.read!("day04_input.txt")
    |> String.split("\n")
    # Group each individual's passport data strings into one list.
    # There is a blank string between each individual's passport data
    |> Enum.chunk_by(fn pp_str -> String.length(pp_str) > 0 end)
    # Delete the lists that only contain a blank string
    |> Enum.filter(fn pp_str_list -> String.length(Enum.at(pp_str_list, 0)) > 0 end)
    # Concatonate each list of strings into one string of passport data
    |> Enum.map(fn pp_str_list -> Enum.join(pp_str_list, " ") end)
    |> Enum.map(&map_passport/1)
  end

  # Convert string of passport data to a key/value map
  defp map_passport(pp_str) do
    String.split(pp_str)
    |> Map.new(fn kv_str ->
      [key_str, value] = String.split(kv_str, ":")
      {String.to_atom(key_str), value}
    end)
  end

  defp valid_passport_2(pp_map) do
    if byr_valid?(pp_map) &&
         iyr_valid?(pp_map) &&
         eyr_valid?(pp_map) &&
         hgt_valid?(pp_map) &&
         hcl_valid?(pp_map) &&
         ecl_valid?(pp_map) &&
         pid_valid?(pp_map) do
      true
    else
      false
    end
  end

  defp byr_valid?(pp_map) do
    case Map.get(pp_map, :byr) do
      nil -> false
      year_str -> valid_year?(year_str, 1920, 2002)
    end
  end

  defp iyr_valid?(pp_map) do
    case Map.get(pp_map, :iyr) do
      nil -> false
      year_str -> valid_year?(year_str, 2010, 2020)
    end
  end

  defp eyr_valid?(pp_map) do
    case Map.get(pp_map, :eyr) do
      nil -> false
      year_str -> valid_year?(year_str, 2020, 2030)
    end
  end

  defp valid_year?(year_str, min_year, max_year) do
    case Integer.parse(year_str) do
      :error -> false
      {year, ""} -> min_year <= year && year <= max_year
      _invalid_year_str -> false
    end
  end

  defp hgt_valid?(pp_map) do
    case Map.get(pp_map, :hgt) do
      nil ->
        false

      hgt_str ->
        {hgt, units} = Integer.parse(hgt_str)

        case units do
          "cm" -> 150 <= hgt && hgt <= 193
          "in" -> 59 <= hgt && hgt <= 76
          _invalid_units -> false
        end
    end
  end

  defp hcl_valid?(pp_map) do
    case Map.get(pp_map, :hcl) do
      nil -> false
      hcl -> Regex.match?(~r/^#[0-9,a-f]{6}$/, hcl)
    end
  end

  @valid_ecls ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

  defp ecl_valid?(pp_map) do
    case Map.get(pp_map, :ecl) do
      nil -> false
      ecl -> Enum.member?(@valid_ecls, ecl)
    end
  end

  defp pid_valid?(pp_map) do
    case Map.get(pp_map, :pid) do
      nil -> false
      pid -> Regex.match?(~r/^[0-9]{9}$/, pid)
    end
  end
end
